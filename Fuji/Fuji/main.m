//
//  main.m
//  Fuji
//
//  Created by Laura Aubin on 2018-03-18.
//

#import <Cocoa/Cocoa.h>
#import "ProcessController.h"
#include <sys/types.h>
#include <sys/sysctl.h>

int CurrentlySelectedProcessID = 0;
float last_time = 0;
float curr_time = 0;

bool newProcessSelectedForCPUArray = false;

int main(int argc, const char * argv[]) {
    ProcessController* processControllerInstance = [[ProcessController alloc] init];

    NSWorkspace* workspaceInstance = [processControllerInstance workspace];

    NSArray<NSRunningApplication *> *allRunningApplications = [workspaceInstance runningApplications];

    for(int i = 0; i < [allRunningApplications count]; i++){
        NSRunningApplication *arrayAtIndex = allRunningApplications[i];

        //NSLog(@"Name %@ with pid: %d\n", arrayAtIndex.localizedName, arrayAtIndex.processIdentifier);
    }
    
    return NSApplicationMain(argc, argv);
}
