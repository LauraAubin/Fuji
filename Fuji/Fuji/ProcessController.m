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

    // Tells the delegate that the app has become active.
    - (void)applicationDidBecomeActive:(NSNotification *)notification
    {
        // rearrageObjects is a method that calls arrangeObjects which returns an array containing filtered and sorted (sortDescriptors) objects.
        [self.arrayOfRunningProcesses rearrangeObjects];
        
        NSLog(@"Array: %@", _arrayOfRunningProcesses); // printing
    }

    // Workspaces are used to launch apps and perform file services.
    - (NSWorkspace *)workspace;
    {
        // You can call sharedWorkspace from anywhere in the app, so it is needed to bind to the UI.
        return [NSWorkspace sharedWorkspace];
    }
@end

@implementation NSRunningApplication (params)
@end

