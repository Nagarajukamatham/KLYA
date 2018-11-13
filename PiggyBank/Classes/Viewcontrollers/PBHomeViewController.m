//
//  PBHomeViewController.m
//  PiggyBank
//
//  Created by Nagaraju on 17/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBHomeViewController.h"
#import "PBUtility.h"
#import "PBConstants.h"
#import "PBSearchViewController.h"
#import "PBMoneyTransferViewController.h"
#import "PBSetGoalViewController.h"
#import "PBSignUpViewController.h"
#import "UserModel.h"
#import "HDLocalizeHelper.h"

#import "BLEManager.h"
#import "PBNetworkCall.h"

@interface PBHomeViewController ()<networkDelegate>{
     PBNetworkCall *networkCall;
    NSUserDefaults *def;
    UserModel *userObj;
    NSArray *menuArr;
    BOOL isMenuOpened,isAutoAddNewKLYA;
    BLEManager *bleManager;
    NSInteger alrtChk,apiChk;
}

@end

@implementation PBHomeViewController
@synthesize maskImgView,nameLbl,transferBtn,goalBtn,piggyBalLbl,piggyNameLbl,goalAmtLbl,goalNameLbl,goalProgressBar,setupBtn,goalReachView,accNoLbl,updateKLYABtn,menuView,transfarentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    networkCall = [[PBNetworkCall alloc] init];
    networkCall.delegate = self;
    bleManager = [[BLEManager alloc] init];
    
    menuArr = [NSArray arrayWithObjects:@"Home",@"Disconnect", nil];
    def = [NSUserDefaults standardUserDefaults];
    maskImgView.image = [PBUtility filledImageFrom:[UIImage imageNamed:@"mask"] withColor:[PBUtility colorFromHexString:APP_COLOR]];
    
    transferBtn.layer.cornerRadius=5.0;
    goalBtn.layer.cornerRadius=5.0;
    
    setupBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    setupBtn.layer.borderWidth = 0.5;
    setupBtn.layer.cornerRadius = 5.0;
    setupBtn.layer.shadowColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
    //[PBUtility colorFromHexString:APP_COLOR].CGColor;
    setupBtn.layer.shadowOffset = CGSizeMake(-5,5);
    setupBtn.layer.shadowOpacity = 1;

    updateKLYABtn.layer.cornerRadius = 5.0;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f,3.0f);
    goalProgressBar.transform = transform;
    
    goalReachView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    goalReachView.layer.borderWidth = 0.5;
    goalReachView.backgroundColor = [[PBUtility colorFromHexString:APP_COLOR] colorWithAlphaComponent:0.7];
    goalReachView.layer.cornerRadius = 5.0;
    
    self.menuTbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [menuView addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swipeleft1=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenu)];
    swipeleft1.direction=UISwipeGestureRecognizerDirectionLeft;
    [transfarentView addGestureRecognizer:swipeleft1];
    
    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu)];
    [transfarentView addGestureRecognizer:letterTapRecognizer];
    
    _menuTbl.scrollEnabled=NO;
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self closeMenu];
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSData *loginData = [def objectForKey:@"loginResp"];;
    userObj = [NSKeyedUnarchiver unarchiveObjectWithData:loginData];
    NSLog(@"userModel ---->>> %@",userObj);
    
    NSString *str = LocalizedString(@"Welcome");
    NSString *fullText = [NSString stringWithFormat:@"%@, %@",str,userObj.name];
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: [UIColor whiteColor],
                              NSFontAttributeName: [UIFont systemFontOfSize:15]
                              };
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:fullText
                                           attributes:attribs];
    UIColor *gColor = [UIColor whiteColor];
    NSRange greenTextRange = [fullText rangeOfString:userObj.name];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:gColor}
                            range:greenTextRange];
    nameLbl.attributedText = attributedText;
    _menuUsernameLbl.text = userObj.name;
    
    accNoLbl.text = [NSString stringWithFormat:@"A/c No. : %@",[PBUtility spaceBetweenAcNo:userObj.accounts.parent.accountNumber]];
    NSString *mainBalance = [NSString stringWithFormat:@"%0.f",userObj.accounts.parent.balance];
    self.balanceLbl.text=[PBUtility amountWithRupee:mainBalance];

    NSString *childBalance = [NSString stringWithFormat:@"%0.f",userObj.accounts.child.balance];
    NSString *pname = userObj.accounts.child.piggyDetails.piggyName;
    if (pname == nil || [pname isKindOfClass:[NSNull class]] || [pname isEqualToString:@"null"]) {
        //NSLog(@"null contains-----");
        self.syncKlyaBtn.hidden = YES;
        self.setupView.hidden=NO;
    }else{
       // NSLog(@"name theree----- %@",pname);
        maskImgView.backgroundColor = [UIColor whiteColor];
        self.syncKlyaBtn.hidden = NO;
        self.setupView.hidden=YES;
        self.piggyNameLbl.text = userObj.accounts.child.piggyDetails.piggyName;
        self.piggyBalLbl.text =[PBUtility amountWithRupee:childBalance];
    }

    BOOL isPiggyAttached = userObj.accounts.child.piggyDetails.piggyAttached;
    if (isPiggyAttached) {
        //enable
        self.bottomTransfarentView.hidden = YES;
        self.updateKLYABtn.userInteractionEnabled=YES;
        self.updateKLYABtn.alpha = 1.0;
        self.bleConnectionStatusLbl.text= @"CONNECTED";
    }else{
        //disable
        self.bottomTransfarentView.hidden = NO;
        self.updateKLYABtn.userInteractionEnabled=NO;
        self.updateKLYABtn.alpha = 0.5;
        self.bleConnectionStatusLbl.text= @"DIS-CONNECTED";
    }
    
    BOOL isGoalCreated = userObj.accounts.child.piggyDetails.goalCreated;
    if (isGoalCreated) {
        self.goalViewHightContraint.constant = 180;
        _goalProgressAmtLbl.hidden=NO;
        NSLog(@"goal name --->>> %@",userObj.accounts.child.piggyDetails.goalName);
        self.goalNameLbl.text = userObj.accounts.child.piggyDetails.goalName;
        self.goalAmtLbl.text = [PBUtility amountWithRupee:userObj.accounts.child.piggyDetails.goalAmount];

        CGFloat presentStatus = 0.0;
        presentStatus = [childBalance floatValue]/[userObj.accounts.child.piggyDetails.goalAmount floatValue];
        //NSLog(@"presentStatus --->>>%f",presentStatus);
        CGFloat padding = [PBUtility getGoalViewX];
        goalProgressBar.progress = presentStatus;
        NSString *percentage=@"%";
        CGFloat present = presentStatus;
        present=present*100;
        self.goalProgressAmtLbl.text = [NSString stringWithFormat:@"%.f%@",present,percentage];
        if (presentStatus > 0.915) {
            presentStatus = 1.0;
            self.goalProgressAmtLblContraintX.constant = padding * presentStatus * 10 - self.goalProgressAmtLbl.frame.size.width;
        }else{
            self.goalProgressAmtLblContraintX.constant = padding * presentStatus * 10;
        }
        
        double goalAmt = [userObj.accounts.child.piggyDetails.goalAmount doubleValue];
        double childBal = [childBalance doubleValue];
        if (childBal >= goalAmt) {
            goalReachView.hidden=NO;
            goalProgressBar.hidden=YES;
            _goalProgressAmtLbl.hidden=YES;
            self.goalBtnNameLbl.text = LocalizedString(@"SET NEW GOAL");
        }else{
            goalReachView.hidden=YES;
            goalProgressBar.hidden=NO;
           self.goalBtnNameLbl.text = LocalizedString(@"UPDATE GOAL");
            [self.goalBtn setImage:[UIImage imageNamed:@"updateGoal"] forState:UIControlStateNormal];
        }
    }
    else{
        self.goalViewHightContraint.constant = 80;
        _goalProgressAmtLbl.hidden=YES;
        self.goalBtnNameLbl.text = LocalizedString(@"SET GOAL");
        [self.goalBtn setImage:[UIImage imageNamed:@"setgoal_icon"] forState:UIControlStateNormal];
    }
    // auto call
    if ([def boolForKey:@"isDisconnected"]) {
        [self movoToBLESearchWithFilter:@"home" disconnectChk:0];
        [def setBool:NO forKey:@"isDisconnected"];
        [def synchronize];
    }

}

- (IBAction)transferBtnClicker:(id)sender {
    if (userObj.accounts.parent.balance <= 0) {
        alrtChk=3;
        [self showAlertmsgStr:@"Insufficient balace you can't perform any operation, please reset data to continue" titleMsg:@""];
    }else{
        PBMoneyTransferViewController *transfer = [self.storyboard instantiateViewControllerWithIdentifier:@"PBMoneyTransferViewController"];
        [self.navigationController pushViewController:transfer animated:YES];
    }
}
- (IBAction)goalBtnClicked:(id)sender {
    if (userObj.accounts.parent.balance <= 0) {
        alrtChk=3;
        [self showAlertmsgStr:@"Insufficient balace you can't perform any operation, please reset data to continue" titleMsg:@""];
    }else{
        PBSetGoalViewController *search = [self.storyboard instantiateViewControllerWithIdentifier:@"PBSetGoalViewController"];
        [self.navigationController pushViewController:search animated:YES];
    }
}

-(IBAction)addNewKylaBtnClicked:(id)sender{
    
    if (bleManager.centralManager.state != CBManagerStatePoweredOn) {
        // NSLog(@"Please turnOn Bluetooth ------>>>");
        alrtChk=1;
        [self showAlertmsgStr:LocalizedString(@"Your Bluetooth is turnOff, please turnon Bluetooth to search KLYA") titleMsg:@""];
    }else{
        if (userObj.accounts.child.piggyDetails.piggyAttached) {
            alrtChk=2;
            [self showAlertmsgStr:@"Before adding new KLYA current connected device will be disconnected. Are you sure..?" titleMsg:@"Confirm"];
        }else{
            [self movoToBLESearchWithFilter:@"home" disconnectChk:0];
        }
    }
}

- (IBAction)updatePiggyBtnClicked:(id)sender {
    [self movoToBLESearchWithFilter:@"update" disconnectChk:0];
}


-(IBAction)setupBtnClicked:(id)sender{
    [self movoToBLESearchWithFilter:@"home" disconnectChk:0];
}

-(void)movoToBLESearchWithFilter:(NSString*)filterStr disconnectChk:(NSInteger)chkVal{
    if (bleManager.centralManager.state != CBManagerStatePoweredOn) {
        alrtChk=1;
        [self showAlertmsgStr:LocalizedString(@"Your Bluetooth is turnOff, please turnon Bluetooth to search KLYA") titleMsg:@""];
    }else{
        PBSearchViewController *search = [self.storyboard instantiateViewControllerWithIdentifier:@"PBSearchViewController"];
        search.cameFrom = filterStr;
        search.disconnectChk = chkVal;
        [self.navigationController pushViewController:search animated:YES];
    }
}

-(IBAction)menuBtnClicked:(id)sender{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        transfarentView.hidden = NO;
        menuView.frame = CGRectMake(0, 0, 280, self.view.frame.size.height);
        isMenuOpened=YES;
    } completion:^(BOOL finished) {
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

}

-(void)closeMenu{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        if (isMenuOpened) {
            transfarentView.hidden = YES;
            menuView.frame = CGRectMake(0, 0, -280, self.view.frame.size.height);
            isMenuOpened=NO;
        }
    } completion:^(BOOL finished) {
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return menuArr.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [menuArr objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelect row --->>> %ld",(long)indexPath.row);
    [self closeMenu];
    if (indexPath.row==1) {
        [self performSelector:@selector(callDisConnect) withObject:self afterDelay:0.5];
    }
}
-(void)callDisConnect{
    BOOL isPiggyAttached = userObj.accounts.child.piggyDetails.piggyAttached;
    if (isPiggyAttached) {
        isAutoAddNewKLYA=NO;
        [self ApiCall_PiggyConnectStatusUpdate];
    }else{
//        NSString *pname = userObj.accounts.child.piggyDetails.piggyName;
//        if (pname == nil || [pname isKindOfClass:[NSNull class]] || [pname isEqualToString:@"null"]) {
//           [PBUtility showAlertWithMessage:@"You already dis-connected" title:@""];
//        }else{
//           [PBUtility showAlertWithMessage:@"You already dis-connected" title:@""];
//        }
        [PBUtility showAlertWithMessage:@"You already dis-connected" title:@""];
    }

}
-(void)showAlertmsgStr:(NSString*)msgStr titleMsg:(NSString*)title{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:msgStr
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    //Add Buttons
    if (alrtChk==2) {
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Cancel"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //NSLog(@"cancel ---->>>");

                                    }];
        [alert addAction:yesButton];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"DISCONNECT"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       isAutoAddNewKLYA=YES;
                                       [self ApiCall_PiggyConnectStatusUpdate];
                                       // [bleManager disConnectPeripheral];
                                   }];
        [alert addAction:noButton];
    }
    else if (alrtChk==3) {
        UIAlertAction *yesButton = [UIAlertAction
                                    actionWithTitle:@"Cancel"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //NSLog(@"cancel ---->>>");
                                        
                                    }];
        [alert addAction:yesButton];
        
        UIAlertAction *noButton = [UIAlertAction
                                   actionWithTitle:@"RESET"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       [self ApiCall_AccountReset];
                                   }];
        [alert addAction:noButton];
    }
    else{
        UIAlertAction* okButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction * action) {
                                        
                                    }];
        [alert addAction:okButton];
    }

    //62086==> 42000-4000-3000=35000
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)ApiCall_PiggyConnectStatusUpdate{
    apiChk=1;
    NSDictionary *postDict = @{
                               @"piggyAttached":[NSNumber numberWithBool:NO],
                               };
    NSLog(@"patch request --->>> %@",postDict);
    
    NSString *pathStr=[NSString stringWithFormat:@"accounts/%@/piggyDetails",userObj.accounts.child.accountId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",userObj.mobileNumber,pathStr];
    [self startActivityIndicator:YES];
    [networkCall patchServiceurlStr:urlStr withParamas:postDict];
    
}

-(void)ApiCall_AccountReset{
    if (bleManager.centralManager.state != CBManagerStatePoweredOn) {
        // NSLog(@"Please turnOn Bluetooth ------>>>");
        alrtChk=1;
        [self showAlertmsgStr:LocalizedString(@"Your Bluetooth is turnOff, please turnon Bluetooth to search KLYA") titleMsg:@""];
    }
    else{
        apiChk=2;
        NSString *childAccountId = userObj.accounts.child.accountId;
        NSString *parentAccountId = userObj.accounts.parent.accountId;
        
        NSDictionary *postDict = @{
                                   [NSString stringWithFormat:@"%@/balance",childAccountId] : [NSNumber numberWithDouble:0.0],
                                   [NSString stringWithFormat:@"%@/balance",parentAccountId]: [NSNumber numberWithDouble:9999.0],
                                   [NSString stringWithFormat:@"%@/piggyDetails/goalName",childAccountId]:@"Goal",
                                   [NSString stringWithFormat:@"%@/piggyDetails/goalAmount",childAccountId]:[NSNumber numberWithDouble:9999.0]
                                   };
        NSLog(@"patch request --->>> %@",postDict);
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/accounts",userObj.mobileNumber];
        [self startActivityIndicator:YES];
        [networkCall patchServiceurlStr:urlStr withParamas:postDict];
    }
}

-(void)success_response:(id)response{
    NSLog(@"response ---->>> %@",response);
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self stopActivityIndicator];
        [self getUserData];
    });
}

-(void)getUserData{
    [networkCall getserviceCallurlStr:userObj.mobileNumber];
}

-(void)success_getresponse:(id)response{
    dispatch_async(dispatch_get_main_queue(), ^{
        [PBUtility loginResponseSetToDefaults:response];
        [self stopActivityIndicator];
        if (apiChk==1) {
            if (isAutoAddNewKLYA) {
                [self movoToBLESearchWithFilter:@"disconnect" disconnectChk:1];
            }else{
                [self movoToBLESearchWithFilter:@"disconnect" disconnectChk:0];
            }
            
        }else{
           [self movoToBLESearchWithFilter:@"reset" disconnectChk:0];
        }
        
    });
}

-(void)failure_error:(NSString *)errStr{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicator];
        [PBUtility showAlertWithMessage:errStr title:@""];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
