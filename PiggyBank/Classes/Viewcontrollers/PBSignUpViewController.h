//
//  PBSignUpViewController.h
//  PiggyBank
//
//  Created by Nagaraju on 17/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBBaseViewController.h"
#import "TextFieldValidator.h"

@interface PBSignUpViewController : PBBaseViewController

@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet TextFieldValidator *nameTxt;
@property (strong, nonatomic) IBOutlet TextFieldValidator *contactNoTxt;
@property (strong, nonatomic) IBOutlet UIView *view1;

@property (strong, nonatomic) IBOutlet TextFieldValidator *pinTxt;
@property (strong, nonatomic) IBOutlet TextFieldValidator *confirmPinTxt;
@property (strong, nonatomic) IBOutlet UIView *view2;

@property (strong, nonatomic) IBOutlet TextFieldValidator *upiTxt;
@property (strong, nonatomic) IBOutlet TextFieldValidator *confirmUpiTxt;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) NSString *enteredMobileNo;

@end
