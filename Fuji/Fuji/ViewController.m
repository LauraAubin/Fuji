//
//  ViewController.m
//  Fuji
//
//  Created by Laura Aubin on 2018-03-08.
//

#import "ViewController.h"
#import <Cocoa/Cocoa.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

- (IBAction)ChangeNiceValueButton:(id)sender {
    setpriority(PRIO_PROCESS, 2335, 6);
    printf("Setting priority of PID:2335 to 6\n");
}

- (void)runningApplications:(NSNotification *)notification
{
    // rearrageObjects is a method that calls arrangeObjects which returns an array containing filtered and sorted (sortDescriptors) objects.
    [self.arrayOfRunningProcesses rearrangeObjects];
}

// Workspaces are used to launch apps and perform file services.
- (NSWorkspace *)workspace;
{
    // You can call sharedWorkspace from anywhere in the app, so it is needed to bind to the UI.
    return [NSWorkspace sharedWorkspace];
}

@end

// This writes the implementation of NSRunningApplications. This is used to manipulate and provide information for a single instance of an app.
@implementation NSRunningApplication (params)

- (NSString *)currentProcess;
{
    printf("Current processes");
    return 0;
}

@end
