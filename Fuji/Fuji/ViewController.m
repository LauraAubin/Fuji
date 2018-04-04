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

extern int CurrentlySelectedProcessID;
int updateTimerIntervalSeconds = 7;

@implementation ViewController
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

    - (NSString *) selectedProcessCPU {
        [NSTimer scheduledTimerWithTimeInterval:updateTimerIntervalSeconds target:self selector:@selector (updateCpuDisplayText) userInfo:nil repeats:YES];
        
        NSString *formattedCPUValue = [NSString stringWithFormat:@"%.01f%%", [self calculateIndividualCPU]];
        
        return formattedCPUValue;
    }

    - (void)updateCpuDisplayText {
        NSString *formattedCPUValue = [NSString stringWithFormat:@"%.01f%%", [self calculateIndividualCPU]];
        NSString *formattedTotalCPUValue = [NSString stringWithFormat:@"%.02f%%", [self calculateTotalCPU]];
        
        _cpuRefreshValue.stringValue = formattedCPUValue;
    }

    - (float)calculateIndividualCPU {
        FILE *pipeStream;
        
        char cpuBuffer[500];
        int done = 0;
        
        char selectedPID[50];
        sprintf(selectedPID, "%d", CurrentlySelectedProcessID);
        
        char command[100] = "ps -p ";
        strcat(command, selectedPID);
        strcat(command, " -o %cpu");
        
        // open the command for reading
        // -n1 : only run once
        pipeStream = popen(command, "r");
        if (pipeStream == NULL) {
            printf("Failed to run command\n" );
            exit(1);
        }
        
        // Read the output one line at a time
        // 2 is the number of lines we are traversing to find the one that we will parse
        while ((done < 2) && (fgets(cpuBuffer, sizeof(cpuBuffer) - 1, pipeStream) != NULL)) {
            done++;
        }
        
        pclose(pipeStream);
        
        char cpuUsage[100];
        int cpuIndex = 0;
        int cpuBufferIndex = 2;
        
        for(int i = 0; i < 3; i++){
            cpuUsage[cpuIndex++] = cpuBuffer[cpuBufferIndex++];
        }
        
        float cpuUsageFloat;
        cpuUsageFloat = (float)atof(cpuUsage);
        
        return cpuUsageFloat;
    }

     - (float)calculateTotalCPU {
         FILE *pipeStream;
         
         char cpuBuffer[500];
         int done = 0;

         // open the command for reading
         // -n1 : only run once
         pipeStream = popen("top -n1 -stats 'cpu,command'", "r");
         
         if (pipeStream == NULL) {
             printf("Failed to run command\n" );
             exit(1);
         }

         /* Read the output a line at a time - output it. */
         while ((done < 4) && (fgets(cpuBuffer, sizeof(cpuBuffer) - 1, pipeStream) != NULL)) {
             done++;
         }

         pclose(pipeStream);

         char user[100];
         char sys[100];
         char idle[100];
         
         int index = 0;
         
         int cpuBufferIndex = 11; // first CPU reading
         
         while(cpuBuffer[cpuBufferIndex] != '%'){
             user[index++] = cpuBuffer[cpuBufferIndex++];
         }
         cpuBufferIndex += 8; //second CPU reading
         index = 0;
         
         while(cpuBuffer[cpuBufferIndex] != '%'){
             sys[index++] = cpuBuffer[cpuBufferIndex++];
         }
         
         cpuBufferIndex += 7; //third CPU reading
         index = 0;
         
         while(cpuBuffer[cpuBufferIndex] != '%'){
             idle[index++] = cpuBuffer[cpuBufferIndex++];
         }

         float userF, sysF;
         userF = (float)atof(user);
         sysF = (float)atof(sys);
         float inUse = (userF + sysF)/2;
         float idleF = (float)atof(idle) + (userF + sysF)/2;

//         printf("CPU in use: %.2f%%\n", inUse);
//         printf("CPU idle: %.2f%%\n", idleF);

         return inUse;
     }
@end
