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

@interface ViewController : NSViewController
    - (IBAction)increaseSelectedNI:(id)sender;

    @property (strong) IBOutlet NSTextField *increasingProcessPriorityDisplay;

    - (int)getCurrentProcessPriority;
@end

#endif /* ViewController_h */
