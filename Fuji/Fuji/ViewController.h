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
    @property (strong) IBOutlet NSProgressIndicator *selectedCPUProgressBarRefreshValue;
    - (void)calculateSingleCPU;
    - (void)setCPUProcessArrayVariableToFalse;
    - (void)evaluateSelectedCPU;

    - (int)getCurrentProcessPriority;
    - (void)updateCpuDisplayText;
    - (int)maxCPUProgressBarValue;
@end

#endif /* ViewController_h */
