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
extern bool newProcessSelectedForCPUArray;

int updateTimerIntervalSeconds = 5;

float CurrentlySelectedProcessCPUValue = 0;

int sizeOfCPUArray = 2;
int CPUArrayDifference = 30;
float lastCPUReadings[2];

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
        _nicenessProgressBar.doubleValue = [self getCurrentProcessPriority];
        _circlePriorityValue.doubleValue = [self getCurrentProcessPriority];
    }

    - (IBAction)decreaseSelectedNI:(id)sender {
        int decreasedPriority = [self getCurrentProcessPriority] - 1;
        
        setpriority(PRIO_PROCESS, CurrentlySelectedProcessID, decreasedPriority);
        
        // convert an int to a string
        NSString *currentProcessPriorityString = [NSString stringWithFormat:@"%d", [self getCurrentProcessPriority]];

        _decreasingProcessPriorityDisplay.stringValue = currentProcessPriorityString;
        _nicenessProgressBar.doubleValue = [self getCurrentProcessPriority];
        _circlePriorityValue.doubleValue = [self getCurrentProcessPriority];
    }

    - (int)getCurrentProcessPriority; {
        return getpriority(PRIO_PROCESS, CurrentlySelectedProcessID);
    }

    - (int)maxNicenessProgressValue {
        return 19;
    }

    - (int)minNicenessProgressValue {
        return -20;
    }

//----------------------------------------------------------------
// ----------------------------- CPU -----------------------------
//----------------------------------------------------------------

    // this runs on initial program launch
    - (NSString *)selectedProcessCPU {
        [NSTimer scheduledTimerWithTimeInterval:updateTimerIntervalSeconds target:self selector:@selector (calculateSingleCPU) userInfo:nil repeats:YES];
        
        _selectedCPUProgressBarRefreshValue.frame = CGRectMake(248, 235, 120, 120);
        
        _decreaseButton.frame = CGRectMake(420, 140, 85, 45);
        _increaseButton.frame = CGRectMake(500, 140, 85, 45);
        _nicenessProgressBar.frame = CGRectMake(445, 235, 120, 120);
        _nicenessProgressBar.doubleValue = [self getCurrentProcessPriority];
        
        NSString *formattedCPUValue = [NSString stringWithFormat:@"%.01f%%", CurrentlySelectedProcessCPUValue];
        _circleCPUPercentage.stringValue = formattedCPUValue;
        
        _nicenessRecommendationText.stringValue = @"";
        _nicenessAdditionalRecommendationText.stringValue = @"";
        
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
        _circleCPUPercentage.stringValue = formattedCPUValue;
        _nicenessProgressBar.doubleValue = [self getCurrentProcessPriority];
        
        _selectedCPUProgressBarRefreshValue.doubleValue = CurrentlySelectedProcessCPUValue;
        
        _CPUCheckMark.stringValue = @"😊"; //✔
        _CPUCheckMark.textColor = [NSColor colorWithSRGBRed:88.0/255  green:165.0/255 blue:90.0/255  alpha:1.0]; // green
        _CPUInnerCircle.textColor = [NSColor colorWithSRGBRed:88.0/255  green:165.0/255 blue:90.0/255  alpha:1.0]; // green
        _CPUOuterCircle.textColor = [NSColor colorWithSRGBRed:165.0/255  green:217.0/255 blue:165.0/255  alpha:1.0]; // light green
        _CPUCircleText.stringValue = @"Stable";
        _CPUContainerHeader.textColor = [NSColor colorWithSRGBRed:88.0/255  green:165.0/255 blue:90.0/255  alpha:1.0]; // green

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
        
        if (CurrentlySelectedProcessCPUValue < 10){
            _nicenessRecommendationText.stringValue = @"This process has a low CPU usage";
            _nicenessAdditionalRecommendationText.stringValue = @"It is recommended that you increase it's niceness";
            
        } else if (CurrentlySelectedProcessCPUValue > 10 && CurrentlySelectedProcessCPUValue < 50){
            _nicenessRecommendationText.stringValue = @"This process is running smoothly";
            _nicenessAdditionalRecommendationText.stringValue = @"";
            
        } else if (CurrentlySelectedProcessCPUValue > 80){
            _nicenessRecommendationText.stringValue = @"This process has a high CPU usage";
            _nicenessAdditionalRecommendationText.stringValue = @"It is recommended that you decrease it's niceness";
            
        } else {
            _nicenessRecommendationText.stringValue = @"";
            _nicenessAdditionalRecommendationText.stringValue = @"";
        }
    }

    - (void)setCPUProcessArrayVariableToFalse {
        newProcessSelectedForCPUArray = false;
    }

    - (void)evaluateSelectedCPU {
        if (lastCPUReadings[1] < (lastCPUReadings[0] - CPUArrayDifference)){

            _CPUCheckMark.stringValue = @"😰"; //✕
            _CPUCheckMark.textColor = [NSColor colorWithSRGBRed:220.0/255 green:56.0/255 blue:37.0/255 alpha:1.0]; // red
            _CPUInnerCircle.textColor = [NSColor colorWithSRGBRed:220.0/255 green:56.0/255 blue:37.0/255 alpha:1.0]; // red
            _CPUOuterCircle.textColor = [NSColor colorWithSRGBRed:252.0/255 green:173.0/255 blue:156.0/255 alpha:1.0]; // light red
            _CPUCircleText.stringValue = @"Unstable ↓";
            _CPUContainerHeader.textColor = [NSColor colorWithSRGBRed:220.0/255 green:56.0/255 blue:37.0/255 alpha:1.0]; // red
            
        } else if (lastCPUReadings[1] > (lastCPUReadings[0] + CPUArrayDifference)){
            
            _CPUCheckMark.stringValue = @"😰"; //✕
            _CPUCheckMark.textColor = [NSColor colorWithSRGBRed:220.0/255 green:56.0/255 blue:37.0/255 alpha:1.0]; // red
            _CPUInnerCircle.textColor = [NSColor colorWithSRGBRed:220.0/255 green:56.0/255 blue:37.0/255 alpha:1.0]; // red
            _CPUOuterCircle.textColor = [NSColor colorWithSRGBRed:252.0/255 green:173.0/255 blue:156.0/255 alpha:1.0]; // light red
            _CPUCircleText.stringValue = @"Unstable ↑";
            _CPUContainerHeader.textColor = [NSColor colorWithSRGBRed:220.0/255 green:56.0/255 blue:37.0/255 alpha:1.0]; // red
        }
    }

    - (int)maxCPUProgressBarValue {
        return 100;
    }
@end
