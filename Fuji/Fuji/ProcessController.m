//
//  ProcessController.m
//  Fuji
//
//  Created by Laura Aubin on 2018-03-20.
//

#import <Foundation/Foundation.h>
#import "ProcessController.h"
#import "ViewController.h"
#import <Cocoa/Cocoa.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int CurrentlySelectedProcessID; // access the global variable declared in main
extern float last_time;
extern float curr_time;
extern bool newProcessSelectedForCPUArray;
extern bool processHasBeenConstant;

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
        
        last_time = 0;
        curr_time = 0;
        newProcessSelectedForCPUArray = true;
        
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
@end

