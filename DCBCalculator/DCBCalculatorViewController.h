//
//  DCBCalculatorViewController.h
//  DCBCalculator
//
//  Created by Dave Batton on 10/28/13.
//  Copyright (c) 2013 Dave Batton. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DCBCalculatorViewControllerDelegate;

@interface DCBCalculatorViewController : UIViewController

@property (nonatomic, weak) id<DCBCalculatorViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *customButtonText;

@end


@protocol DCBCalculatorViewControllerDelegate <NSObject>

@optional
- (void)calculatorViewController:(DCBCalculatorViewController *)calculatorViewController willDismissWithNumber:(NSNumber *)number text:(NSString *)text;
- (void)calculatorViewController:(DCBCalculatorViewController *)calculatorViewController buttonTouchedWithNumber:(NSNumber *)number text:(NSString *)text;

@end
