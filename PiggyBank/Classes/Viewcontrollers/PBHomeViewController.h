//
//  PBHomeViewController.h
//  PiggyBank
//
//  Created by Nagaraju on 17/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBBaseViewController.h"

@interface PBHomeViewController : PBBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *maskImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *accNoLbl;
@property (weak, nonatomic) IBOutlet UILabel *balanceLbl;
@property (weak, nonatomic) IBOutlet UIButton *setupBtn;
@property (weak, nonatomic) IBOutlet UILabel *piggyNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *piggyBalLbl;
@property (weak, nonatomic) IBOutlet UILabel *bleConnectionStatusLbl;
@property (weak, nonatomic) IBOutlet UILabel *goalNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *goalAmtLbl;
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;
@property (weak, nonatomic) IBOutlet UIButton *goalBtn;
@property (weak, nonatomic) IBOutlet UILabel *goalBtnNameLbl;
@property (weak, nonatomic) IBOutlet UIProgressView *goalProgressBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goalProgressAmtLblContraintX;
@property (weak, nonatomic) IBOutlet UILabel *goalProgressAmtLbl;
@property (weak, nonatomic) IBOutlet UIView *setupView;
@property (weak, nonatomic) IBOutlet UIView *goalReachView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goalViewHightContraint;
@property (weak, nonatomic) IBOutlet UIButton *updateKLYABtn;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *transfarentView;
@property (weak, nonatomic) IBOutlet UITableView *menuTbl;
@property (weak, nonatomic) IBOutlet UIButton *syncKlyaBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomTransfarentView;
@property (weak, nonatomic) IBOutlet UILabel *menuUsernameLbl;;

//@property (weak, nonatomic) IBOutlet UIImageView *goalImgView;
@end
