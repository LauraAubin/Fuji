//
//  ProcessController.m
//  Fuji
//
//  Created by Laura Aubin on 2018-03-20.
//

#import <Foundation/Foundation.h>
#import "ProcessController.h"
#import <Cocoa/Cocoa.h>
#include <sys/time.h>
#include <sys/resource.h>

@implementation ProcessController

    - (void)applicationDidBecomeActive:(NSNotification *)notification
    {
        [self.arrayOfRunningProcesses rearrangeObjects];
        NSLog(@"Array: %@", _arrayOfRunningProcesses);
    }

    - (NSWorkspace *)workspace;
    {
        return [NSWorkspace sharedWorkspace];
    }
@end

@implementation NSRunningApplication (params)

    - (pid_t)selectedPID;
    {
        return self.processIdentifier;
    }

    - (int)selectedPriority;
    {
        int priority_level;
        pid_t selected_PID;
        
        selected_PID = self.processIdentifier;
        
        priority_level = getpriority(PRIO_PROCESS, selected_PID);
        
        return priority_level;
    }
@end

