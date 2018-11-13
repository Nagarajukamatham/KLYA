//
//  PBConfirmationViewController.m
//  PiggyBank
//
//  Created by Nagaraju on 21/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBConfirmationViewController.h"
#import "PBHomeViewController.h"
#import "PBUtility.h"
#import "PBNetworkCall.h"
#import "BLEManager.h"
#import "PBMessage.h"
#import "PBConstants.h"
#import "UserModel.h"

@interface PBConfirmationViewController ()<networkDelegate,BLESerialDelegate>{
    NSUserDefaults *defaults;
    PBNetworkCall *networkCall;
    UserModel *user;
    BLEManager *bleManager;
    
    CFTimeInterval progressStart;
    int progressCount,count;
    UILabel *timerrLbl;
    UIProgressView *progressBar;
    UIView *bgProgressView;
}
@property (nonatomic, strong) NSTimer *myTimer;
@end

@implementation PBConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bleManager = [[BLEManager alloc] init];
    bleManager.serialDelegate = self;
    networkCall = [[PBNetworkCall alloc] init];
    networkCall.delegate = self;
    defaults=[NSUserDefaults standardUserDefaults];
    
    self.finishBtn.layer.cornerRadius=5.0;
    
    NSData *loginData = [defaults objectForKey:@"loginResp"];
    user = [NSKeyedUnarchiver unarchiveObjectWithData:loginData];

    NSString *childBalance = [NSString stringWithFormat:@"%0.f",user.accounts.child.balance];
    self.piggyNameLbl.text = self.enteredPiggyName;
   // NSString *dateStr = [PBUtility getDateTimeWithFormat:@"EEEE, d MMMM YYYY"];
    self.connectedKLYALbl.text = self.toyManualName;
    self.linkAccountLbl.text = self.selectedAccountNumber;
    self.balanceLbl.text = [PBUtility amountWithRupee:childBalance];
    
}

-(void)serialDidUpdateState{
    NSLog(@"central state ---->>>> ");
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(IBAction)finishBtnClciked:(id)sender{
    [self addPiggyServiceCall];
}

-(void)addPiggyServiceCall{
    NSDictionary *postDict;
    if (user.accounts.child.piggyDetails.goalCreated) {
        postDict = @{@"deviceId": self.selectedToy.identifier.UUIDString,
                     @"deviceName" : self.toyManualName,
                     @"piggyAttached":[NSNumber numberWithBool:YES],
                     @"piggyLastConnectedDateAndTime":[PBUtility getDateTimeWithFormat:@"dd/MM/yyyy HH:mm"],
                     @"piggyName":_enteredPiggyName,
                     
                     @"goalAmount":[NSNumber numberWithDouble:[user.accounts.child.piggyDetails.goalAmount doubleValue]],
                     @"goalCreatedDate":[PBUtility getDateTimeWithFormat:@"dd/MM/yyyy HH:mm"],
                     @"goalDate":[PBUtility getDateTimeWithFormat:@"dd/MM/yyyy HH:mm"],
                     @"goalName":user.accounts.child.piggyDetails.goalName,
                     @"goalStatus":@"0",
                     @"goalCreated":[NSNumber numberWithBool:true],
                     };
    }else{
        postDict = @{@"deviceId": self.selectedToy.identifier.UUIDString,
                     @"deviceName" : self.toyManualName,
                     @"piggyAttached":[NSNumber numberWithBool:YES],
                     @"piggyLastConnectedDateAndTime":[PBUtility getDateTimeWithFormat:@"dd/MM/yyyy HH:mm"],
                     @"piggyName":_enteredPiggyName,
                     
                     @"goalAmount":[NSNumber numberWithDouble:[@"9999" doubleValue]],
                     @"goalCreatedDate":[PBUtility getDateTimeWithFormat:@"dd/MM/yyyy HH:mm"],
                     @"goalDate":[PBUtility getDateTimeWithFormat:@"dd/MM/yyyy HH:mm"],
                     @"goalName":@"Goal",
                     @"goalStatus":@"0",
                     @"goalCreated":[NSNumber numberWithBool:true],
                     };
    }
    

    NSLog(@"patch request --->>> %@",postDict);
    
    NSString *pathStr=[NSString stringWithFormat:@"accounts/%@/piggyDetails",user.accounts.child.accountId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",user.mobileNumber,pathStr];
    [self startActivityIndicator:YES];
    [networkCall patchServiceurlStr:urlStr withParamas:postDict];
    
}

-(void)success_response:(id)response{
    NSLog(@"response ---->>> %@",response);
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self stopActivityIndicator];
        [self getUserData];
    });
}

-(void)getUserData{
    [networkCall getserviceCallurlStr:user.mobileNumber];
}

-(void)success_getresponse:(id)response{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [PBUtility loginResponseSetToDefaults:response];
        
        [self showProgressViewWithTimer];
        [bleManager sendMessage:[PBMessage passAccountNumber:_selectedAccountNumber piggyName:_enteredPiggyName] toPiggy:self.selectedToy withCharacteristics:self.writeCharacteristic];
        [self performSelector:@selector(Delay_goalSend) withObject:self afterDelay:5.0];
    });
}

-(void)Delay_goalSend{
    NSLog(@"Delay_goalSend ======>>>");
    if (user.accounts.child.piggyDetails.goalCreated) {
        NSLog(@"<<<====== GOAL AVAILABLE ======>>>");
        [bleManager sendMessage:[PBMessage passGoal:user.accounts.child.piggyDetails.goalName amount:user.accounts.child.piggyDetails.goalAmount] toPiggy:self.selectedToy withCharacteristics:self.writeCharacteristic];
    }else{
        NSLog(@"<<<====== GOAL NOT ======>>>");
        [bleManager sendMessage:[PBMessage passGoal:@"Goal" amount:@"9999"] toPiggy:self.selectedToy withCharacteristics:self.writeCharacteristic];
    }
    
    [self performSelector:@selector(Delay_YashSend) withObject:self afterDelay:5.0];
}

-(void)Delay_YashSend{
    NSLog(@"Delay_YashSend ======>>>");
    [bleManager sendMessage:[PBMessage transferSpecialCharacter:@"#"] toPiggy:self.selectedToy withCharacteristics:self.writeCharacteristic];
    
    [self performSelector:@selector(Delay_BalanceSend) withObject:self afterDelay:3.0];
}

-(void)Delay_BalanceSend{
    NSLog(@"Delay_BalanceSend ======>>>");
    NSString *childAcBalance=[NSString stringWithFormat:@"%.2f",user.accounts.child.balance];
    [bleManager sendMessage:[PBMessage passBalance:childAcBalance currencyName:keuros] toPiggy:self.selectedToy withCharacteristics:self.writeCharacteristic];
    [self performSelector:@selector(Delay_TransferBalance) withObject:self afterDelay:5.0];
}

-(void)Delay_TransferBalance{
    NSLog(@"Delay_TransferBalance ======>>>");
    [bleManager sendMessage:[PBMessage transferMoney:[NSString stringWithFormat:@"0"]] toPiggy:self.selectedToy withCharacteristics:self.writeCharacteristic];
    
     [self performSelector:@selector(Delay_StarSend) withObject:self afterDelay:5.0];
}

-(void)Delay_StarSend{
    NSLog(@"Delay_StarSend ======>>>");
    [self stopActivityIndicator];
    [bleManager sendMessage:[PBMessage transferSpecialCharacter:@"*"] toPiggy:self.selectedToy withCharacteristics:self.writeCharacteristic];
    [bgProgressView removeFromSuperview];
    
    PBHomeViewController *confirm = [self.storyboard instantiateViewControllerWithIdentifier:@"PBHomeViewController"];
    [self.navigationController pushViewController:confirm animated:YES];
}

-(void)failure_geterror:(NSString *)errStr{
    NSLog(@"errStr ---->>>> %@",errStr);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicator];
        [PBUtility showAlertWithMessage:errStr title:@""];
    });
}

-(void)failure_error:(NSString *)errStr{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicator];
        [PBUtility showAlertWithMessage:errStr title:@""];
    });
}


-(IBAction)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showProgressViewWithTimer
{
    //self.progressView.progress = 1.0;
    progressBar.progress = 1.0;
    progressStart = CACurrentMediaTime();
    progressCount = 23;

    bgProgressView =[[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, (self.view.frame.size.height/2)-130, 200, 60)];
    bgProgressView.backgroundColor = [UIColor whiteColor];//[[PBUtility colorFromHexString:APP_COLOR] colorWithAlphaComponent:0.5];
    bgProgressView.layer.cornerRadius = 5.0;
    [self.view addSubview:bgProgressView];
    
    timerrLbl = [[UILabel alloc] initWithFrame:CGRectMake((bgProgressView.frame.size.width/2)-60, 10, 120, 25)];
    timerrLbl.textAlignment = NSTextAlignmentCenter;
    timerrLbl.text = [NSString stringWithFormat:@"Updating KLYA 0%%"];
    timerrLbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    //timerrLbl.textColor = [UIColor darkGrayColor];
    //timerrLbl.backgroundColor = [UIColor greenColor];
    [bgProgressView addSubview:timerrLbl];
    
    progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressBar.frame = CGRectMake((bgProgressView.frame.size.width/2)-70, 40, 140, 10);
    [progressBar setTintColor:[PBUtility colorFromHexString:APP_COLOR]];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 2.0f);
    progressBar.transform = transform;
    [bgProgressView addSubview:progressBar];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];

}

- (void)updateUI:(NSTimer *)timer
{
    count++;
    // int progressTime = 14;
    float totalTime = (float)progressCount;
    if (count <= progressCount)
    {
        float current = (float)count;
        timerrLbl.text = [NSString stringWithFormat:@"Updating KLYA %.f%%",(current/totalTime)*100];
        // NSLog(@"val ---->>> %.f",val);
        progressBar.progress = [[NSString stringWithFormat:@"%.f",(current/totalTime)*100] floatValue]/100;
    } else
    {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
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
