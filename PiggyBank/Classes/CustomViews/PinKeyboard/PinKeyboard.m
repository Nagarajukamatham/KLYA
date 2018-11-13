//
//  PinKeyboard.m
//  NBKeyboardExtMock
//
//  Created by Sujan Reddy on 26/02/18.
//  Copyright © 2018 Innovation Makers. All rights reserved.
//

#import "PinKeyboard.h"

@implementation PinKeyboard

- (id)init
{
    if(self = [super init]) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame])
    {
        [self setupXIB];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self setupXIB];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code

}

- (void)setupXIB {
    
    self.keyboardView = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"PinKeyboard" owner:self options:nil]objectAtIndex:0];
    
    self.keyboardView.frame =  self.bounds;
    
    self.keyboardView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    [self addSubview:self.keyboardView];
}

-(IBAction)keyboardButtonAction:(id)sender {
    
    UIButton *clickedButton = (UIButton *)sender;
    
    if (clickedButton.tag == 99) {
        [self.keyboardDelegate pinPadDidInputDelete:self];
    }
    else if (clickedButton.tag == 100) {
        [self.keyboardDelegate pinPadDidInputReturn:self];
    }
    else{
        [self.keyboardDelegate pinPad:self didAcceptCandidate:[NSString stringWithFormat:@"%ld", (long)clickedButton.tag] withIndex:101];
    }
}


@end
