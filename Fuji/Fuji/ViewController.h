//
//  ViewController.h
//  Fuji
//
//  Created by Laura Aubin on 2018-03-29.
//

#ifndef ViewController_h
#define ViewController_h

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "ProcessController.h"
#import "ViewController.h"

@interface ViewController : NSViewController
    - (IBAction)increaseSelectedNI:(id)sender;
    - (IBAction)decreaseSelectedNI:(id)sender;

    @property (strong) IBOutlet NSTextField *increasingProcessPriorityDisplay;
    @property (strong) IBOutlet NSTextField *decreasingProcessPriorityDisplay;

    // individual process' CPU value
    @property (readonly) NSString *selectedProcessCPU;
    @property (strong) IBOutlet NSTextField *cpuRefreshValue;
    - (float)calculateIndividualCPU;
    - (void)updateCpuDisplayText;

    // total system CPU value
    - (float)calculateTotalCPU;

    - (int)getCurrentProcessPriority;
@end

#endif /* ViewController_h */
