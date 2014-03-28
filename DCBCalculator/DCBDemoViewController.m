//
//  DCBDemoViewController.m
//  DCBCalculator
//
//  Created by Dave Batton on 10/28/13.
//  Copyright (c) 2013 Dave Batton. All rights reserved.
//

#import "DCBDemoViewController.h"
#import "DCBCalculatorViewController.h"


@interface DCBDemoViewController () <DCBCalculatorViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, strong) UIPopoverController *calcPopoverController;

@end


@implementation DCBDemoViewController


#pragma mark - DCBCalculatorViewControllerDelegate


- (void)calculatorViewController:(DCBCalculatorViewController *)calculatorViewController buttonTouchedWithNumber:(NSNumber *)number text:(NSString *)text
{
    self.textField.text = text;
    [self.calcPopoverController dismissPopoverAnimated:YES];
}


#pragma mark - Actions


- (IBAction)displayCalculator:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    DCBCalculatorViewController *calculatorViewController = [[DCBCalculatorViewController alloc] init];
    calculatorViewController.delegate = self;
    calculatorViewController.customButtonText = @"Apply";

    self.calcPopoverController = [[UIPopoverController alloc] initWithContentViewController:calculatorViewController];
    if ([self.calcPopoverController respondsToSelector:@selector(setBackgroundColor:)]) {
        self.calcPopoverController.backgroundColor = [UIColor blackColor];  // iOS 7 only.
    }
    [self.calcPopoverController presentPopoverFromRect:sender.frame
                                                inView:sender.superview
                              permittedArrowDirections:UIPopoverArrowDirectionAny
                                              animated:YES];
}


@end
