//
//  PBTransferSuccessViewController.h
//  PiggyBank
//
//  Created by Nagaraju on 29/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBBaseViewController.h"

@interface PBTransferSuccessViewController : PBBaseViewController

@property (nonatomic,retain) NSString *enteredAmount;
@property (nonatomic,retain) NSString *enteredDescription;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *fromNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *fromAccountNumberLbl;
@property (weak, nonatomic) IBOutlet UILabel *toNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *toccountNumberLbl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UIButton *upadteBtn;
@property (nonatomic,retain) IBOutlet UIImageView *successimgView;
@end
