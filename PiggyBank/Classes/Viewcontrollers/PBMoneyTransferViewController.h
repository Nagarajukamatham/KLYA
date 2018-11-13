//
//  PBMoneyTransferViewController.h
//  PiggyBank
//
//  Created by Nagaraju on 22/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBBaseViewController.h"
#import "TextFieldValidator.h"
@interface PBMoneyTransferViewController : PBBaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet TextFieldValidator *amountTxt;
@property (weak, nonatomic) IBOutlet TextFieldValidator *descTxt;
@property (weak, nonatomic) IBOutlet UILabel *AvlBalLbl;
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;
@end
