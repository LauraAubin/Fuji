//
//  ProcessController.m
//  Fuji
//
//  Created by Laura Aubin on 2018-03-20.
//

#import <Foundation/Foundation.h>
#import "ProcessController.h"
#import <Cocoa/Cocoa.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int CurrentlySelectedProcessID; // access the global variable declared in main

@implementation ProcessController

    - (void)applicationDidBecomeActive:(NSNotification *)notification
    {
        [self.arrayOfRunningProcesses rearrangeObjects];
        // NSLog(@"Array: %@", _arrayOfRunningProcesses);
    }

    - (NSWorkspace *)workspace;
    {
        return [NSWorkspace sharedWorkspace];
    }
@end

@implementation NSRunningApplication (params)
    - (pid_t)selectedPID;
    {
        CurrentlySelectedProcessID = self.processIdentifier;
        return self.processIdentifier;
    }

    - (int)selectedNiceness;
    {
        int niceness_value;
        pid_t selected_PID;

        selected_PID = self.processIdentifier;
        niceness_value = getpriority(PRIO_PROCESS, selected_PID);

        return niceness_value;
    }

    - (int) selectedCPU;
    {
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
@end

