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

#include <sys/types.h>
#include <unistd.h>

extern int CurrentlySelectedProcessID;

@implementation ViewController
    - (IBAction)increaseSelectedNI:(id)sender {
        int increasedPriority = [self getCurrentProcessPriority] + 1;
        
        setpriority(PRIO_PROCESS, CurrentlySelectedProcessID, increasedPriority);
        
        // convert an int to a string
        NSString *currentProcessPriorityString = [NSString stringWithFormat:@"%d", [self getCurrentProcessPriority]];
        
        _increasingProcessPriorityDisplay.stringValue = currentProcessPriorityString;
    }

    - (IBAction)decreaseSelectedNI:(id)sender {
        int decreasedPriority = -20;
        
        setpriority(PRIO_PROCESS, CurrentlySelectedProcessID, -3);
        
        system("sudo renice -n -10 -p 1054");
        
//        printf("Decreased priority: %d and ", decreasedPriority);
        printf("get priority: %d\n", [self getCurrentProcessPriority]);
        
        // convert an int to a string
        NSString *currentProcessPriorityString = [NSString stringWithFormat:@"%d", [self getCurrentProcessPriority]];
        
        _decreasingProcessPriorityDisplay.stringValue = currentProcessPriorityString;
    }

    - (int)getCurrentProcessPriority; {
        return getpriority(PRIO_PROCESS, CurrentlySelectedProcessID);
    }
@end
