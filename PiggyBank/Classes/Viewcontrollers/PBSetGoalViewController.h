//
//  PBSetGoalViewController.h
//  PiggyBank
//
//  Created by Nagaraju on 22/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBBaseViewController.h"
#import "TextFieldValidator.h"
@interface PBSetGoalViewController : PBBaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet TextFieldValidator *goalAmtTxt;
@property (weak, nonatomic) IBOutlet TextFieldValidator *goalNameTxt;

@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UIButton *goalBtn;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UIButton *datePickerBtn;

@end
