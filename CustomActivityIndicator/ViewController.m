//
//  ViewController.m
//  CustomActivityIndicator
//
//  Created by Robert on 3/27/17.
//  Copyright © 2017 Robert. All rights reserved.
//

#import "ViewController.h"
#import "RActivityIndicatorView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet RActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stepper.value = self.activityIndicator.numberOfLines;
}

- (IBAction)actStepper:(UIStepper *)sender {
    self.activityIndicator.numberOfLines = (int)sender.value;
    
    if (sender.value == 12) {
        [self.activityIndicator spin];
        [self.activityIndicator startAnimate];
    }
}

- (IBAction)actReset:(id)sender {
    [self.activityIndicator reset];
    self.stepper.value = 1;
}

@end
