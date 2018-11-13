//
//  PBLoginViewController.h
//  PiggyBank
//
//  Created by Nagaraju on 17/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBBaseViewController.h"
#import "TextFieldValidator.h"

@interface PBLoginViewController : PBBaseViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet TextFieldValidator *contactNoTxt;
@property (strong, nonatomic) IBOutlet TextFieldValidator *pinTxt;

@property (strong, nonatomic) IBOutlet UIButton *proceedBtn;
@property (strong, nonatomic) IBOutlet UIButton *signUpBtn;

@end
