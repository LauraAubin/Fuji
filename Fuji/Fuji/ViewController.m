//
//  ViewController.m
//  Fuji
//
//  Created by Laura Aubin on 2018-03-29.
//

#import <Foundation/Foundation.h>
#import "ProcessController.h"
#import "ViewController.h"
#import <Cocoa/Cocoa.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/sysctl.h>

extern int CurrentlySelectedProcessID;
extern float last_time;
extern float curr_time;

int updateTimerIntervalSeconds = 5;

float CurrentlySelectedProcessCPUValue = 0;

int sizeOfCPUArray = 2;
int CPUArrayDifference = 30;
float lastCPUReadings[2];
extern bool newProcessSelectedForCPUArray;

@implementation ViewController

//----------------------------------------------------------------
// --------------------- PRIORITY / NICENESS ---------------------
//----------------------------------------------------------------

    - (IBAction)increaseSelectedNI:(id)sender {
        int increasedPriority = [self getCurrentProcessPriority] + 1;

        setpriority(PRIO_PROCESS, CurrentlySelectedProcessID, increasedPriority);

        // convert an int to a string
        NSString *currentProcessPriorityString = [NSString stringWithFormat:@"%d", [self getCurrentProcessPriority]];

        _increasingProcessPriorityDisplay.stringValue = currentProcessPriorityString;
    }

    - (IBAction)decreaseSelectedNI:(id)sender {
        int decreasedPriority = [self getCurrentProcessPriority] - 1;
        
        setpriority(PRIO_PROCESS, CurrentlySelectedProcessID, decreasedPriority);
        
        // convert an int to a string
        NSString *currentProcessPriorityString = [NSString stringWithFormat:@"%d", [self getCurrentProcessPriority]];

        _decreasingProcessPriorityDisplay.stringValue = currentProcessPriorityString;
    }

    - (int)getCurrentProcessPriority; {
        return getpriority(PRIO_PROCESS, CurrentlySelectedProcessID);
    }

//----------------------------------------------------------------
// ----------------------------- CPU -----------------------------
//----------------------------------------------------------------

    - (NSString *)selectedProcessCPU {
        [NSTimer scheduledTimerWithTimeInterval:updateTimerIntervalSeconds target:self selector:@selector (calculateSingleCPU) userInfo:nil repeats:YES];
        
        return 0;
    }

    - (void)calculateSingleCPU {
        FILE *pipeStream;
        
        char cpuBuffer[500];
        int done = 0;
        
        char selectedPID[10000];
        sprintf(selectedPID, "%d", CurrentlySelectedProcessID);
        
        char command[100] = "top -stats time -pid ";
        strcat(command, selectedPID);
        
        // open the command for reading
        // -n1 : only run once
        pipeStream = popen(command, "r");
        if (pipeStream == NULL) {
            printf("Failed to run command\n" );
            exit(1);
        }
        
        // read the output one line at a time
        while ((done < 13) && (fgets(cpuBuffer, sizeof(cpuBuffer) - 1, pipeStream) != NULL)) {
            done++;
        }
        
        pclose(pipeStream);
        
        char cpuUsage[100];
        int cpuIndex = 0;
        int cpuBufferIndex = 0;
        
        while(cpuBuffer[cpuBufferIndex] != '.'){
            cpuBufferIndex++;
        }
        
        cpuBufferIndex -= 2; //go back to the start of the seconds
        
        //Read the seconds and decimal seconds
        for(int i = 0; i < 5; i++){
            cpuUsage[cpuIndex++] = cpuBuffer[cpuBufferIndex++];
        }
        
        //Save this as the current seconds
        curr_time = (float)atof(cpuUsage);
        
        if(last_time == 0){
            last_time = curr_time;
            return;
        }
        
        float time_delta;
        
        if(last_time > curr_time){
            time_delta = (60 - last_time) + curr_time;
        }
        else{
            time_delta = curr_time - last_time;
        }
        
        last_time = curr_time;
        
        CurrentlySelectedProcessCPUValue = ((time_delta * 100))/updateTimerIntervalSeconds;

        [self updateCpuDisplayText];
    }

    - (void)updateCpuDisplayText {
        NSString *formattedCPUValue = [NSString stringWithFormat:@"%.01f%%", CurrentlySelectedProcessCPUValue];
        _cpuRefreshValue.stringValue = formattedCPUValue;
        
        _selectedCPUProgressBarRefreshValue.doubleValue = CurrentlySelectedProcessCPUValue;
        
        // push a new element to the end and drop the first
        for(int x = 1; x < sizeOfCPUArray; x++){
            lastCPUReadings[x - 1] = lastCPUReadings[x];
        }
        lastCPUReadings[sizeOfCPUArray - 1] = CurrentlySelectedProcessCPUValue;
        
        if (newProcessSelectedForCPUArray == true){
            [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector (setCPUProcessArrayVariableToFalse) userInfo:nil repeats:NO];
        }
        
        if (newProcessSelectedForCPUArray == false){
            [self evaluateSelectedCPU];
        }
    }

    - (void)setCPUProcessArrayVariableToFalse {
        newProcessSelectedForCPUArray = false;
    }

    - (void)evaluateSelectedCPU {
        if (lastCPUReadings[1] < (lastCPUReadings[0] - CPUArrayDifference) || lastCPUReadings[1] > (lastCPUReadings[0] + CPUArrayDifference)){
            printf("Change\n");
        }
    }

    - (int)maxCPUProgressBarValue {
        return 100;
    }
@end
