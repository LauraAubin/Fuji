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

extern int CurrentlySelectedProcessID;

@implementation ViewController
    - (IBAction)increaseSelectedNI:(id)sender {
        printf("Button clicked for %d\n", CurrentlySelectedProcessID);
        
        int currentlySelectedPriority = getpriority(PRIO_PROCESS, CurrentlySelectedProcessID);
        int increasedPriority = currentlySelectedPriority + 1;
        
        setpriority(PRIO_PROCESS, CurrentlySelectedProcessID, increasedPriority);
    }
@end
