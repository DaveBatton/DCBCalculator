//
//  DCBCalculatorViewController.m
//  DCBCalculator
//
//  Created by Dave Batton on 10/28/13.
//  Copyright (c) 2013 Dave Batton. All rights reserved.
//

static NSString * const DCBCalculatorResultText = @"DCBCalculatorResultText";


#import "DCBCalculatorViewController.h"
#import "DCBCalculatorButtton.h"


typedef enum {
    DCBCalculatorTagOne = 1,
    DCBCalculatorTagTwo,
    DCBCalculatorTagThree,
    DCBCalculatorTagFour,
    DCBCalculatorTagFive,
    DCBCalculatorTagSix,
    DCBCalculatorTagSeven,
    DCBCalculatorTagEight,
    DCBCalculatorTagNine,
    DCBCalculatorTagZero,
    DCBCalculatorTagDecimalPoint,

    DCBCalculatorTagDivide,
    DCBCalculatorTagMultiply,
    DCBCalculatorTagSubtract,
    DCBCalculatorTagAdd,
    DCBCalculatorTagEqual,

    DCBCalculatorTagClear,
    DCBCalculatorTagChangeSign,
    DCBCalculatorTagPercent,
} DCBCalculatorTag;


typedef enum {
    DCBOperatorNone = 0,
    DCBOperatorAdd,
    DCBOperatorSubtract,
    DCBOperatorMultiply,
    DCBOperatorDivide,
    DCBOperatorEqual
} DCBOperator;


@interface DCBCalculatorViewController ()

@property (nonatomic, weak) IBOutlet UILabel *resultLabel;
@property (nonatomic, strong) IBOutletCollection(DCBCalculatorButtton) NSArray *buttons;
@property (nonatomic, weak) IBOutlet UIButton *customButton;

@property (nonatomic, strong) NSDecimalNumber *displayedNumber;
@property (nonatomic, strong) NSString *displayedText;
@property (nonatomic, strong) NSDecimalNumber *leftOperand;
@property (nonatomic, strong) NSDecimalNumber *rightOperand;
@property (nonatomic) DCBOperator selectedOperator;
@property (nonatomic) BOOL deleteInput;  // Indicates that the next digit typed should clear the display first for new number entry.
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic) CGRect nibFrame;

@end


@implementation DCBCalculatorViewController

@synthesize displayedNumber = _displayedNumber;


#pragma mark - Setup


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [_numberFormatter setGroupingSeparator:@","];
        [_numberFormatter setGroupingSize:3];
        [_numberFormatter setLenient:YES];
        [_numberFormatter setMinimumSignificantDigits:1];
        [_numberFormatter setMaximumSignificantDigits:7];
        [_numberFormatter setMaximumIntegerDigits:9];
        [_numberFormatter setMinimumFractionDigits:0];
        [_numberFormatter setMaximumFractionDigits:8];
    }
    return self;
}


#pragma mark - UIViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Some of the operators are smaller, but aligned on the same baseline as the numbers.
    // This makes them appear uncentered in the buttons. We'll make some adjustments here to help center them.
    [self buttonWithCalculatorTag:DCBCalculatorTagClear].titleEdgeInsets = UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 2.0f);
    [self buttonWithCalculatorTag:DCBCalculatorTagChangeSign].titleEdgeInsets = UIEdgeInsetsMake(-3.0f, 0.0f, 3.0f, 0.0f);
    [self buttonWithCalculatorTag:DCBCalculatorTagZero].titleEdgeInsets = UIEdgeInsetsMake(0.0f, -5.0f, 0.0f, 5.0f);
    [self buttonWithCalculatorTag:DCBCalculatorTagDivide].titleEdgeInsets = UIEdgeInsetsMake(-5.0f, 0.0f, 5.0f, 0.0f);
    [self buttonWithCalculatorTag:DCBCalculatorTagMultiply].titleEdgeInsets = UIEdgeInsetsMake(-5.0f, 0.0f, 5.0f, 0.0f);
    [self buttonWithCalculatorTag:DCBCalculatorTagSubtract].titleEdgeInsets = UIEdgeInsetsMake(-5.0f, 0.0f, 5.0f, 0.0f);
    [self buttonWithCalculatorTag:DCBCalculatorTagAdd].titleEdgeInsets = UIEdgeInsetsMake(-5.0f, 0.0f, 5.0f, 0.0f);
    [self buttonWithCalculatorTag:DCBCalculatorTagEqual].titleEdgeInsets = UIEdgeInsetsMake(-5.0f, 0.0f, 5.0f, 0.0f);

    // We need to save the frame size from the nib because when we get to
    // -viewWillAppear: it will have been modified by the popover controller.
    self.nibFrame = self.view.frame;

    self.deleteInput = YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([self.customButtonText length] > 0) {
        [self.customButton setTitle:self.customButtonText forState:UIControlStateNormal];
    }
    else {
        self.customButton.hidden = YES;
    }

    [self setDisplayedText:[[NSUserDefaults standardUserDefaults] objectForKey:DCBCalculatorResultText] format:YES];
    self.deleteInput = YES;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:self.displayedText forKey:DCBCalculatorResultText];

    if ([self.delegate respondsToSelector:@selector(calculatorViewController:willDismissWithNumber:text:)]) {
        [self.delegate calculatorViewController:self willDismissWithNumber:self.displayedNumber text:self.displayedText];
    }

    [super viewWillDisappear:animated];
}


- (CGSize)contentSizeForViewInPopover
{
    CGRect frame = self.nibFrame;

    if ([self.customButtonText length] == 0) {
        frame.size.height -= (self.customButton.frame.size.height + 9.0f);
    }

    return frame.size;
}


#pragma mark - Private


- (IBAction)buttonTouched:(DCBCalculatorButtton *)sender
{
    //    if ([self.resultText isEqualToString:@"0"]) {
    //        self.deleteInput = YES;
    //    }

    // We sometimes need to delete the current text, but we never have to do so for the change sign button
    //    if (self.deleteInput && sender.tag != DCBCalculatorTagChangeSign) {
    //        self.resultText = @"";
    //    }
    //    self.deleteInput = NO;

    // See which button the user pressed
    switch (sender.tag) {
        case DCBCalculatorTagOne:
        case DCBCalculatorTagTwo:
        case DCBCalculatorTagThree:
        case DCBCalculatorTagFour:
        case DCBCalculatorTagFive:
        case DCBCalculatorTagSix:
        case DCBCalculatorTagSeven:
        case DCBCalculatorTagEight:
        case DCBCalculatorTagNine:
            [self addDigit:sender.tag];
            break;

        case DCBCalculatorTagZero:
            [self addDigit:0];
            break;

        case DCBCalculatorTagDecimalPoint:
            if ([self.displayedText isEqualToString:@"0"]) {
                self.displayedText = @"0.";
            }
            else if ([self.displayedText rangeOfString:@"."].location == NSNotFound) {
                self.displayedText = [self.displayedText stringByAppendingString:@"."];
            }
            break;

        case DCBCalculatorTagClear:
            // Trying to simulate the behavior of the iPhone calculator.
            if (self.leftOperand && [self.displayedNumber isEqualToNumber:[NSDecimalNumber zero]] == NO) {
                self.displayedNumber = [NSDecimalNumber zero];
                self.rightOperand = nil;
            }
            else {
                self.displayedNumber = [NSDecimalNumber zero];
                self.leftOperand = nil;
                self.rightOperand = nil;
                self.selectedOperator = DCBOperatorNone;
            }
            [[self buttonWithCalculatorTag:DCBCalculatorTagClear] setTitle:@"AC" forState:UIControlStateNormal];
            self.deleteInput = NO;
            break;

        case DCBCalculatorTagChangeSign:
            if ([self.displayedText rangeOfString:@"-"].location == NSNotFound) {
                self.displayedText = [@"-" stringByAppendingString:self.displayedText];
            }
            else {
                self.displayedText = [self.displayedText stringByReplacingOccurrencesOfString:@"-" withString:@""];
            }
            break;

        case DCBCalculatorTagPercent: {
                NSDecimalNumber *oneHundred = [[NSDecimalNumber alloc] initWithString:@"100"];
                self.displayedNumber = [self.displayedNumber decimalNumberByDividingBy:oneHundred];
            }
            break;

        case DCBCalculatorTagDivide:
            [self addOperator:DCBOperatorDivide];
            break;

        case DCBCalculatorTagMultiply:
            [self addOperator:DCBOperatorMultiply];
            break;

        case DCBCalculatorTagSubtract:
            [self addOperator:DCBOperatorSubtract];
            break;

        case DCBCalculatorTagAdd:
            [self addOperator:DCBOperatorAdd];
            break;
            
        case DCBCalculatorTagEqual:
            [self addOperator:DCBOperatorEqual];
            break;
    }
}


- (void)addDigit:(NSInteger)digit
{
    NSString *text = self.displayedText;  // Using the displayed text preserves the decimal point that might be at the end.

    if (self.deleteInput) {
        text = @"";
    }

    // The user can enter a max of 9 digits (not including negative sign,
    // commas and the decimal point) just like the iPhone calculator.
    NSString *digitsOnly = text;
    digitsOnly = [digitsOnly stringByReplacingOccurrencesOfString:@"." withString:@""];
    digitsOnly = [digitsOnly stringByReplacingOccurrencesOfString:@"-" withString:@""];
    digitsOnly = [digitsOnly stringByReplacingOccurrencesOfString:@"," withString:@""];
    if ([digitsOnly length] >= 9) {
        return;
    }

    text = [text stringByAppendingFormat:@"%d", digit];

    // If we haven't gotten to the decimal yet, we need to get group separators back in the right place.
    // If we're adding to the right of the decimal, we may be adding 0, which we want to stay. Formatting would remove it.
    BOOL hasDecimal = [text rangeOfString:@"."].location != NSNotFound;
    [self setDisplayedText:text format:!hasDecimal];

    self.deleteInput = NO;
}


- (void)addOperator:(DCBOperator)operator
{
    // If deleteInput is YES and we already have an operator, it means the user
    // just hit an operator button, then another one right after that.
    // Just change the operator without doing any math.
    if (self.deleteInput && self.selectedOperator && operator != DCBOperatorEqual) {
        self.selectedOperator = operator;
        return;
    }

    if (self.deleteInput == NO) {
        // A new number has been typed, so make it the new right operand.
        self.rightOperand = self.displayedNumber;
    }

    if (self.leftOperand) {
        switch (self.selectedOperator) {
            case DCBOperatorAdd:
                self.displayedNumber = [self.leftOperand decimalNumberByAdding:self.rightOperand];
                break;
            case DCBOperatorSubtract:
                self.displayedNumber = [self.leftOperand decimalNumberBySubtracting:self.rightOperand];
                break;
            case DCBOperatorMultiply:
                self.displayedNumber = [self.leftOperand decimalNumberByMultiplyingBy:self.rightOperand];
                break;
            case DCBOperatorDivide:
                self.displayedNumber = [self.leftOperand decimalNumberByDividingBy:self.rightOperand];
                break;
            case DCBOperatorEqual:
                break;
            default:
                break;
        }
    }

    if (operator != DCBOperatorEqual) {
        // If = was touched, leave the previous selected operator and left operand in place.
        self.selectedOperator = operator;
    }

    self.leftOperand = self.displayedNumber;
    self.deleteInput = YES;
}


- (NSString *)formattedNumberFromString:(NSString *)aString
{
    // The NSNumberFormatter seems to choke on commas. It shouldn't. But we pull them out to fix this.
    aString = [aString stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSNumber *number = [self.numberFormatter numberFromString:aString];
    return [self.numberFormatter stringFromNumber:number];
}


- (DCBCalculatorButtton *)buttonWithCalculatorTag:(DCBCalculatorTag)tag
{
    return (DCBCalculatorButtton *)[self.view viewWithTag:tag];
}


- (void)updateClearButtonTitle
{
    NSString *clearButtonText = [self buttonWithCalculatorTag:DCBCalculatorTagClear].currentTitle;

    if (self.leftOperand || self.selectedOperator != DCBOperatorNone || ![self.displayedNumber isEqualToNumber:[NSDecimalNumber zero]]) {
        clearButtonText = @"C";
    }
    else {
        clearButtonText = @"AC";
    }

    [[self buttonWithCalculatorTag:DCBCalculatorTagClear] setTitle:clearButtonText forState:UIControlStateNormal];
}


#pragma mark - Actions


- (IBAction)customButtonTouched
{
    if ([self.delegate respondsToSelector:@selector(calculatorViewController:buttonTouchedWithNumber:text:)]) {
        if (self.deleteInput == NO) {
            // A number was just entered. Do the calculation first.
            [self addOperator:DCBOperatorEqual];
        }

        [self.delegate calculatorViewController:self buttonTouchedWithNumber:self.displayedNumber text:self.displayedText];
    }
}


#pragma mark - Accessors


- (NSString *)formattedText
// Returns the number as properly formatted text.
{
    BOOL numberIsZero = [self.displayedNumber isEqualToNumber:[NSDecimalNumber zero]];
    [self.numberFormatter setUsesSignificantDigits:!numberIsZero];

    return [self.numberFormatter stringFromNumber:self.displayedNumber];
}


- (NSString *)displayedText
// Returns the text exactly as the user sees it.
{
    return self.resultLabel.text;
}


- (void)setDisplayedText:(NSString *)text
// Always sets the display as passed. So don't pass junk.
{
    [self setDisplayedText:text format:NO];
}


- (void)setDisplayedText:(NSString *)text format:(BOOL)format
// Also sets the underlying number.
{
    // Whether we format it or not, be careful not to screw up the number.
    // Convert nil or blank text to zero.
    NSDecimalNumber *number;
    if ([text length] == 0) {
        number = [NSDecimalNumber zero];
    }
    else {
        NSString *convertableText = [text stringByReplacingOccurrencesOfString:@"," withString:@""];
        number = [[NSDecimalNumber alloc] initWithString:convertableText locale:[NSLocale currentLocale]];
    }

    self.displayedNumber = number;  // This will set the displayed text, but we'll set it again below.

    if (format) {
        text = [self formattedText];
    }

    self.resultLabel.text = text;
}


- (NSDecimalNumber *)displayedNumber
{
    if (_displayedNumber == nil) {
        _displayedNumber = [NSDecimalNumber zero];
    }

    return _displayedNumber;
}


- (void)setDisplayedNumber:(NSDecimalNumber *)number
{
    if ([_displayedNumber isEqualToNumber:number] == NO) {
        _displayedNumber = number;
    }

    self.resultLabel.text = [self formattedText];

    [self updateClearButtonTitle];
}


@end
