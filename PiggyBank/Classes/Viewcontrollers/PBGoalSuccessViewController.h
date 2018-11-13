//
//  PBGoalSuccessViewController.h
//  PiggyBank
//
//  Created by Nagaraju on 30/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBBaseViewController.h"

@interface PBGoalSuccessViewController : PBBaseViewController

@property (nonatomic,retain) NSString *enteredGoalName;
@property (nonatomic,retain) NSString *enteredGoalAmount;
@property (nonatomic,retain) NSString *childAvailableBalance;
@property (nonatomic,retain) NSString *goalDate;
@property (weak, nonatomic) IBOutlet UILabel *goalNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *goalAmountLbl;
@property (weak, nonatomic) IBOutlet UILabel *goalDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *extraSaveLbl;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (nonatomic,retain) IBOutlet UIImageView *successimgView;
@end
