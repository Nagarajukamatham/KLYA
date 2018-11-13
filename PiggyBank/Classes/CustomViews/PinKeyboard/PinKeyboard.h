//
//  PinKeyboard.h
//  NBKeyboardExtMock
//
//  Created by Sujan Reddy on 26/02/18.
//  Copyright © 2018 Innovation Makers. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DApinKeyPadDelegate;

@interface PinKeyboard : UIView

@property UIView *keyboardView;

@property (nonatomic, weak) IBOutlet UIButton *one;
@property (nonatomic, weak) IBOutlet UIButton *two;
@property (nonatomic, weak) IBOutlet UIButton *three;

@property (nonatomic, weak) IBOutlet UIButton *four;
@property (nonatomic, weak) IBOutlet UIButton *five;
@property (nonatomic, weak) IBOutlet UIButton *six;

@property (nonatomic, weak) IBOutlet UIButton *seven;
@property (nonatomic, weak) IBOutlet UIButton *eight;
@property (nonatomic, weak) IBOutlet UIButton *nine;

@property (nonatomic, weak) IBOutlet UIButton *zero;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet UIButton *okButton;

@property (nonatomic, assign) id<DApinKeyPadDelegate> keyboardDelegate;
-(IBAction)keyboardButtonAction:(id)sender;

@end

@protocol DApinKeyPadDelegate <NSObject>

- (void)pinPad:(PinKeyboard *)pinPad didAcceptCandidate:(NSString *)candidate withIndex:(NSInteger)index;
- (void)pinPadDidInputDelete:(PinKeyboard *)pinPad;
- (void)pinPadDidInputReturn:(PinKeyboard *)pinPad;

@optional


@end
