//
//  ProcessController.m
//  Fuji
//
//  Created by Laura Aubin on 2018-03-20.
//

#import <Foundation/Foundation.h>
#import "ProcessController.h"
#import <Cocoa/Cocoa.h>

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
    printf("PROCESS %d\n", self.processIdentifier);
    return self.processIdentifier;
}
@end

