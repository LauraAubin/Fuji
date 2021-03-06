//
//  ProcessController.h
//  Fuji
//
//  Created by Laura Aubin on 2018-03-20.
//

#ifndef ProcessController_h
#define ProcessController_h

#import <Cocoa/Cocoa.h>
#import "ProcessController.h"
#import "ViewController.h"

@interface ProcessController : NSObject
    @property (weak, readonly) NSWorkspace *workspace;
    @property(weak, readonly) NSArray *sortDescriptors;
    @property (strong) IBOutlet NSArrayController *arrayOfRunningProcesses;
@end

@interface NSRunningApplication (params)
    @property (readonly) NSString* selectedName;
    @property (readonly) NSString* selectedPID;
    @property (readonly) int selectedNiceness;
@end

#endif /* ProcessController_h */
