//
//  PBSearchViewController.h
//  PiggyBank
//
//  Created by Nagaraju on 21/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBBaseViewController.h"
@interface PBSearchViewController : PBBaseViewController

@property (weak, nonatomic) IBOutlet UIView *scanView;
@property (weak, nonatomic) IBOutlet UIView *tryagainView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UILabel *piggyNameLbl;
@property (nonatomic,retain) NSString *cameFrom;
@property (nonatomic,retain) NSString *amountToTransfer;
@property (nonatomic,retain) NSString *goalName;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshBtn;
@property (weak, nonatomic) IBOutlet UILabel *tapLbl;
@property (assign, nonatomic) NSInteger disconnectChk;
@end
