//
//  PBPinViewController.m
//  PiggyBank
//
//  Created by Nagaraju on 17/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBPinViewController.h"
#import "PBCheckBLEViewController.h"
#import "PBHomeViewController.h"
#import "PBUtility.h"
#import "UserModel.h"

#import "PBMoneySwipeViewController.h"
#import "HDLocalizeHelper.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "PBNetworkCall.h"
@interface PBPinViewController ()<networkDelegate,DApinKeyPadDelegate>{
    NSString *mPinString;
    BOOL isPinEnabled,isBluetoothTurnOn;
    NSUserDefaults *def;
    UserModel *userObj;
    PBNetworkCall *networkCall;
}

@end

@implementation PBPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    networkCall = [[PBNetworkCall alloc] init];
    networkCall.delegate = self;
    mPinString= [[NSString alloc] init];
    def = [NSUserDefaults standardUserDefaults];
    self.bleManager=[[BLEManager alloc] init];
    self.bleManager.serialDelegate = self;
    NSData *loginData = [def objectForKey:@"loginResp"];
    userObj = [NSKeyedUnarchiver unarchiveObjectWithData:loginData];
    self.pinKeyboard.keyboardDelegate=self;
}

-(void)serialDidUpdateState{
    //    NSLog(@"serialDidUpdateState --------------->>>>");
    if (self.bleManager.centralManager.state != CBManagerStatePoweredOn) {
        NSLog(@"bluetooth off check===++====>>>>pin");
    }else{
        NSLog(@"bluetooth on check===++=====>>>>pin");
    }
}

-(void)viewDidAppear:(BOOL)animated{
    
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [self loginWithTouchID:myContext];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            // [self showAlertWithMsg:authError.localizedDescription];
            // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
            NSLog(@"cancel btn clicked111");
        });
    }
}

- (IBAction)forgotPasswordBtnClicked:(id)sender {
    NSString *str = LocalizedString(@"Your login PIN is");
    NSString *msgStr =[NSString stringWithFormat:@"%@ %@",str,userObj.loginPin];
    [PBUtility showAlertWithMessage:msgStr title:@""];
}

//Checking the device bluetooth Off/On and navigating to respective
-(void)stopWheel{
    
            if ([mPinString isEqualToString:userObj.loginPin]) {
                [self getUserData];
            }else{
                [self stopActivityIndicator];
                [self performSelector:@selector(clearPin) withObject:self afterDelay:0.25];
            }
}

-(void)goToHomeScreen{
    
    
    if (self.bleManager.centralManager.state != CBManagerStatePoweredOn) {
        //NSLog(@"bluetooth off --------------->>>> go to home screen");
        PBCheckBLEViewController *ble = [self.storyboard instantiateViewControllerWithIdentifier:@"PBCheckBLEViewController"];
        [self.navigationController pushViewController:ble animated:YES];
    }else {
        // NSLog(@"bluetooth on --------------->>>> go to ble screen");
        PBHomeViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"PBHomeViewController"];
        [self.navigationController pushViewController:home animated:YES];
        
    }
}


-(void)getUserData{
    //[self startActivityIndicator:YES];
    [networkCall getserviceCallurlStr:userObj.mobileNumber];
}

-(void)success_getresponse:(id)response{
    NSLog(@"response ---->>>> %@",response);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicator];
        [PBUtility loginResponseSetToDefaults:response];
        [self goToHomeScreen];
    });
}


-(void)failure_geterror:(NSString *)errStr{
    NSLog(@"errStr ---->>>> %@",errStr);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicator];
        [PBUtility showAlertWithMessage:errStr title:@""];
    });
}

// Delegate method(PIN keybaord) and Here getting the input keyboard candidate
- (void)pinPad:(PinKeyboard *)pinPad didAcceptCandidate:(NSString *)candidate withIndex:(NSInteger)index {
    self.inputView.showErrorLbl.hidden=YES;
    [self.inputView inputAuthDidAcceptCandidate:candidate isPinEnable:isPinEnabled];
    mPinString = [mPinString stringByAppendingString:candidate];
    if (mPinString.length==4) {
        [self startActivityIndicator:YES];
        [self performSelector:@selector(stopWheel) withObject:self afterDelay:0.1];
    }
}

//deleting the pin numbers
-(void)clearPin{
    [self.inputView inputAuthDidInputDelete];
    [self.inputView inputAuthDidInputDelete];
    [self.inputView inputAuthDidInputDelete];
    [self.inputView inputAuthDidInputDelete];
    mPinString = @"";
   // [PBUtility showAlertWithMessage:LocalizedString(@"Please enter correct Login Pin") title:@""];
    self.inputView.showErrorLbl.hidden=NO;
    
}

// Delegate method(PIN keybaord) and deletinh the passcode
- (void)pinPadDidInputDelete:(PinKeyboard *)pinPad {
    [self.inputView inputAuthDidInputDelete];
    if (mPinString.length < 1) {
        return;
    }
    mPinString = [mPinString substringToIndex:[mPinString length]-1];
    // NSLog(@"mPinString delete----->>>> %@",mPinString);
}

- (void)pinPadDidInputReturn:(PinKeyboard *)pinPad {
    
}

- (IBAction)showHideBtnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (isPinEnabled) {
        [btn setTitle:LocalizedString(@"   SHOW") forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"pin_white_show"] forState:UIControlStateNormal];
        isPinEnabled = NO;
        //NSLog(@"selected");
        NSInteger len = mPinString.length;
        switch (len) {
            case 1:
                self.inputView.dotImg1.image = [UIImage imageNamed:@"dot_white_HD"];
                break;
            case 2:
                self.inputView.dotImg1.image = [UIImage imageNamed:@"dot_white_HD"];
                self.inputView.dotImg2.image = [UIImage imageNamed:@"dot_white_HD"];
                break;
            case 3:
                self.inputView.dotImg1.image = [UIImage imageNamed:@"dot_white_HD"];
                self.inputView.dotImg2.image = [UIImage imageNamed:@"dot_white_HD"];
                self.inputView.dotImg3.image = [UIImage imageNamed:@"dot_white_HD"];
                break;
            case 4:
                self.inputView.dotImg1.image = [UIImage imageNamed:@"dot_white_HD"];
                self.inputView.dotImg2.image = [UIImage imageNamed:@"dot_white_HD"];
                self.inputView.dotImg3.image = [UIImage imageNamed:@"dot_white_HD"];
                self.inputView.dotImg4.image = [UIImage imageNamed:@"dot_white_HD"];
                break;
                
            default:
                break;
        }
        self.inputView.numLbl1.text = @"";
        self.inputView.numLbl2.text = @"";
        self.inputView.numLbl3.text = @"";
        self.inputView.numLbl4.text = @"";
    }else{
        // NSLog(@"not selected");
        [btn setTitle:LocalizedString(@"   HIDE") forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"pin_white_hide"] forState:UIControlStateNormal];
        isPinEnabled = YES;
        NSInteger len = mPinString.length;
        switch (len) {
            case 1:
                self.inputView.numLbl1.text = [mPinString substringWithRange:NSMakeRange(0, 1)];
                break;
            case 2:
                self.inputView.numLbl1.text = [mPinString substringWithRange:NSMakeRange(0, 1)];
                self.inputView.numLbl2.text = [mPinString substringWithRange:NSMakeRange(1, 1)];
                break;
            case 3:
                self.inputView.numLbl1.text = [mPinString substringWithRange:NSMakeRange(0, 1)];
                self.inputView.numLbl2.text = [mPinString substringWithRange:NSMakeRange(1, 1)];
                self.inputView.numLbl3.text = [mPinString substringWithRange:NSMakeRange(2, 1)];
                
                break;
            case 4:
                self.inputView.numLbl1.text = [mPinString substringWithRange:NSMakeRange(0, 1)];
                self.inputView.numLbl2.text = [mPinString substringWithRange:NSMakeRange(1, 1)];
                self.inputView.numLbl3.text = [mPinString substringWithRange:NSMakeRange(2, 1)];
                self.inputView.numLbl4.text = [mPinString substringWithRange:NSMakeRange(3, 1)];
                break;
                
            default:
                break;
        }
        self.inputView.dotImg1.image = [UIImage imageNamed:@""];
        self.inputView.dotImg2.image = [UIImage imageNamed:@""];
        self.inputView.dotImg3.image = [UIImage imageNamed:@""];
        self.inputView.dotImg4.image = [UIImage imageNamed:@""];
    }
}

-(void)loginWithTouchID:(LAContext*)myContext{
    [self startActivityIndicator:YES];
    NSString *myLocalizedReasonString = @"Scan with your Touch ID to proceed";
    [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
              localizedReason:myLocalizedReasonString
                        reply:^(BOOL success, NSError *error) {
                            if (success) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    //success
                                    //[self stopActivityIndicator];
                                    [self getUserData];
                                });
                            } else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
                                    [self stopActivityIndicator];
                                    NSLog(@"cancel btn clciked");
                                    //  [self showAlertWithMsg:error.localizedDescription];
                                });
                            }
                        }];
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
