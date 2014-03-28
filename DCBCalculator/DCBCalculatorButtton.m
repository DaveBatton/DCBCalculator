//
//  DCBCalculatorButtton.m
//  DCBCalculator
//
//  Created by Dave Batton on 10/28/13.
//  Copyright (c) 2013 Dave Batton. All rights reserved.
//

#import "DCBCalculatorButtton.h"


@interface DCBCalculatorButtton ()

@property (nonatomic, strong) UIColor *buttonColor;

@end


@implementation DCBCalculatorButtton


#pragma mark - Setup & Teardown


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self calculatorButtonInit];
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self calculatorButtonInit];
}


- (void)calculatorButtonInit
{
    _buttonColor = self.backgroundColor;  // Save the color set in the xib.

    _style = -1 ;  // So the next line does some work.
    [self setStyle:DCBCalculatorButttonStyleNumber];  // Use the accessor so the background color gets set.
    self.layer.borderWidth = 0.5f / [UIScreen mainScreen].scale;
}


#pragma mark - UIButton


- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];

    if (highlighted) {
        self.backgroundColor = [self highlightedBackgroundColor];
    }
    else {
        [self updateStyle];
    }
}


#pragma mark - Private


- (void)updateStyle
{
    self.backgroundColor = self.buttonColor;
}


- (UIColor *)highlightedBackgroundColor
{
    CGFloat brightness = 0.85f;

    const CGFloat *components = CGColorGetComponents(self.buttonColor.CGColor);

    return [UIColor colorWithRed:components[0] * brightness
                           green:components[1] * brightness
                            blue:components[2] * brightness
                           alpha:components[3]];
}


#pragma mark - Accessors


- (void)setStyle:(DCBCalculatorButttonStyle)style
{
    if (_style != style) {
        _style = style;
        [self updateStyle];
    }
}


@end
