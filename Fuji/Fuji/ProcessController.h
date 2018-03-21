//
//  ProcessController.h
//  Fuji
//
//  Created by Laura Aubin on 2018-03-20.
//

#ifndef ProcessController_h
#define ProcessController_h

#import <Cocoa/Cocoa.h>

// for defining what kind of OS is going to be able to run our application
@interface operatingSystemArchitecture : NSObject
@end

@interface ProcessController : NSObject
   // weak: keeps a pointer to the object so long as it exists. When it is deallocated, pointer is set to nil automatically.
   // readonly: only generate a getter, no setter. Will warn you if you try to change this property.
   // NSWorkspace: can launch apps and handle file services. There is one shared workspace within the entire app.
   @property (weak, readonly) NSWorkspace *workspace;

   // Sorts an array as part of arrangeObjects.
   @property(weak, readonly) NSArray *sortDescriptors;

   @property (strong) IBOutlet NSArrayController *arrayOfRunningProcesses;
@end

@interface NSRunningApplication (params)
@end

#endif /* ProcessController_h */
