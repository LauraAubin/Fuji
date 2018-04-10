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
    // niceness
    @property (strong) IBOutlet NSButton *increaseButton;
    @property (strong) IBOutlet NSButton *decreaseButton;
    @property (strong) IBOutlet NSProgressIndicator *nicenessProgressBar;
    @property (strong) IBOutlet NSTextField *increasingProcessPriorityDisplay;
    @property (strong) IBOutlet NSTextField *decreasingProcessPriorityDisplay;
    @property (strong) IBOutlet NSTextField *circlePriorityValue;

    - (IBAction)increaseSelectedNI:(id)sender;
    - (IBAction)decreaseSelectedNI:(id)sender;

    - (int)maxNicenessProgressValue;
    - (int)minNicenessProgressValue;

    // individual process' CPU value
    @property (readonly) NSString *selectedProcessCPU;
    @property (strong) IBOutlet NSTextField *cpuRefreshValue;
    @property (strong) IBOutlet NSProgressIndicator *selectedCPUProgressBarRefreshValue;
    @property (strong) IBOutlet NSTextField *circleCPUPercentage;
    - (void)calculateSingleCPU;
    - (void)setCPUProcessArrayVariableToFalse;
    - (void)evaluateSelectedCPU;

    - (int)getCurrentProcessPriority;
    - (void)updateCpuDisplayText;
    - (int)maxCPUProgressBarValue;

    // CPU stability animations
    @property (strong) IBOutlet NSTextField *CPUOuterCircle;
    @property (strong) IBOutlet NSTextField *CPUInnerCircle;
    @property (strong) IBOutlet NSTextField *CPUCheckMark;
    @property (strong) IBOutlet NSTextField *CPUContainerHeader;
    @property (strong) IBOutlet NSTextField *CPUCircleText;

    // niceness recommendations
    @property (strong) IBOutlet NSTextField *nicenessRecommendationText;
    @property (strong) IBOutlet NSTextField *nicenessAdditionalRecommendationText;
@end

#endif /* ViewController_h */
