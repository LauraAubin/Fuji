//
//  ViewController.m
//  Fuji
//
//  Created by Laura Aubin on 2018-03-08.
//

#import "ViewController.h"

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

@end
