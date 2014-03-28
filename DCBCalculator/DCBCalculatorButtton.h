//
//  DCBCalculatorButtton.h
//  DCBCalculator
//
//  Created by Dave Batton on 10/28/13.
//  Copyright (c) 2013 Dave Batton. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DCBCalculatorButttonStyleNumber,
    DCBCalculatorButttonStyleOperator,
    DCBCalculatorButttonStyleOther
} DCBCalculatorButttonStyle;

@interface DCBCalculatorButtton : UIButton

@property (nonatomic) DCBCalculatorButttonStyle style;

@end
