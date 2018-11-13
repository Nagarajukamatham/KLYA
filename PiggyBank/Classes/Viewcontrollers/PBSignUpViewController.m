//
//  PBSignUpViewController.m
//  PiggyBank
//
//  Created by Nagaraju on 17/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBSignUpViewController.h"
#import "PBConstants.h"
#import "PBUtility.h"
#import "PBLoginViewController.h"
#import "PBNetworkCall.h"
#import "PBCheckBLEViewController.h"
#import "PBHomeViewController.h"
#import "BLEManager.h"
#import "HDLocalizeHelper.h"

@interface PBSignUpViewController ()<networkDelegate,BLESerialDelegate,UITextFieldDelegate>{
    NSInteger btnTag;
    NSUserDefaults *def;
    PBNetworkCall *networkCall;
    BLEManager *bleManager;
    BOOL isApiCalled;
    
}

@end

@implementation PBSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    def = [NSUserDefaults standardUserDefaults];
    networkCall = [[PBNetworkCall alloc] init];
    networkCall.delegate = self;
    bleManager=[[BLEManager alloc] init];
    btnTag=1;
    NSString *fullText = LocalizedString(@"Click here to LOGIN");
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: [UIColor darkGrayColor],
                              NSFontAttributeName: [UIFont systemFontOfSize:12]
                              };
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:fullText
                                           attributes:attribs];
    UIColor *gColor = [UIColor whiteColor];
    NSRange greenTextRange = [fullText rangeOfString:@"LOGIN"];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:gColor}
                            range:greenTextRange];
    [_loginBtn setAttributedTitle:attributedText forState:UIControlStateNormal];
    
    _nextBtn.layer.cornerRadius = 5.0;
    _nextBtn.layer.masksToBounds=YES;
    [self validateInputs];
    self.backBtn.hidden=YES;
    
    
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(doneClicked)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexibleItem,doneButton, nil]];
    self.contactNoTxt.inputAccessoryView = keyboardDoneButtonView;
    self.pinTxt.inputAccessoryView = keyboardDoneButtonView;
    self.confirmPinTxt.inputAccessoryView = keyboardDoneButtonView;
    
}

- (void)doneClicked
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
}

- (IBAction)loginBtnClicked:(id)sender {
    [self.view endEditing:YES];
    _nameTxt.text=@"";
    _contactNoTxt.text=@"";
    PBLoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"PBLoginViewController"];
    [self.navigationController pushViewController:login animated:YES];
}

- (IBAction)cancelBtnClicked:(id)sender {
    [self.view endEditing:YES];
    
    if (btnTag==3) {
        self.view1.hidden=YES;
        self.view2.hidden=NO;
        self.view3.hidden=YES;
        btnTag=2;
        [self.nextBtn setTitle:LocalizedString(@"PROCEED") forState:UIControlStateNormal];
        self.backBtn.hidden=NO;
    }
    else if (btnTag==2){
        self.view1.hidden=NO;
        self.view2.hidden=YES;
        self.view3.hidden=YES;
        btnTag=1;
        [self.nextBtn setTitle:LocalizedString(@"NEXT") forState:UIControlStateNormal];
        self.backBtn.hidden=YES;
        
        _pinTxt.text = @"";
        _confirmPinTxt.text = @"";
        
    }
    else if (btnTag==1){
        NSLog(@"view1 --->>> no one to show");
    }

}

- (IBAction)nextBtnClicked:(id)sender {
  //  [self getDenominations:_contactNoTxt.text];
    
    [self.view endEditing:YES];
    if (btnTag==1) {
        if ([_nameTxt validate] & [_contactNoTxt validate]) {
          //  NSLog(@"_enteredMobileNo-->>> %@",_enteredMobileNo);
          //  NSLog(@"_contactNoTxt-->>> %@",_contactNoTxt.text);
            if (isApiCalled && [_contactNoTxt.text isEqualToString:_enteredMobileNo]) {
                self.view1.hidden=YES;
                self.view2.hidden=NO;
                self.view3.hidden=YES;
                btnTag=2;
                self.backBtn.hidden=NO;
                [self.nextBtn setTitle:LocalizedString(@"PROCEED") forState:UIControlStateNormal];

            }else{
                [self startActivityIndicator:YES];
                [networkCall checkExistedUserUrlStr:_contactNoTxt.text];
            }
        }
    }
    else if (btnTag==2){
        if ([_pinTxt validate] & [_confirmPinTxt validate]) {
            // network call
            [self startActivityIndicator:YES];
            [networkCall patchServiceurlStr:_contactNoTxt.text withParamas:[self signupPayload]];
        }
    }

}

//Checking the registering user is existed or not, If existed restrict the user and showing alert
-(void)isExistedUserCheck_response:(id)response{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicator];
        NSString *str = (NSString*)response;
        if ([str isEqualToString:@"null"]||[str isEqualToString:@""]) {
            self.view1.hidden=YES;
            self.view2.hidden=NO;
            self.view3.hidden=YES;
            btnTag=2;
            self.backBtn.hidden=NO;
            [self.nextBtn setTitle:LocalizedString(@"PROCEED") forState:UIControlStateNormal];
            isApiCalled=YES;
            _enteredMobileNo = _contactNoTxt.text;
            
        }else{
            [PBUtility showAlertWithMessage:LocalizedString(@"Mobile number is already registered, please login to continue")  title:@""];
        }

    });
}

//Making the signup object/payload to network call
-(NSDictionary*)signupPayload{
    NSDictionary *piggyDict = @{
                                @"goalCreated":[NSNumber numberWithBool:false],
                                @"piggyAttached":[NSNumber numberWithBool:false],
                                };
    
    NSString *childalphaNumbericStr = [NSString stringWithFormat:@"%@_%@",[PBUtility getRandomAlphabetString:8],[PBUtility getRandomPINString:16]];
    NSString *parentalphaNumbericStr = [NSString stringWithFormat:@"%@_%@",[PBUtility getRandomAlphabetString:8],[PBUtility getRandomPINString:16]];
    
    NSString *childaccountNumber = [PBUtility getRandomPINString:16];
    NSDictionary *childAccount = @{
                                   @"accountId":childalphaNumbericStr,
                                   @"accountName": @"Children Account",
                                   @"accountNumber": [NSNumber numberWithInteger:[childaccountNumber integerValue]],
                                   @"accountType": @"child",
                                   @"balance": [NSNumber numberWithDouble:[@"0.00" doubleValue]],
                                   @"piggyDetails": piggyDict,
                                   };
    
    NSString *parentAccountNumber = [PBUtility getRandomPINString:16];
    NSString *balStr = @"9999";//[PBUtility getRandomPINString:5];
    NSDictionary *mainAccount = @{
                                  @"accountId":parentalphaNumbericStr,
                                  @"accountName": @"Savings Account",
                                  @"accountNumber": [NSNumber numberWithInteger:[parentAccountNumber integerValue]],
                                  @"accountType": @"parent",
                                  @"balance": [NSNumber numberWithDouble:[balStr doubleValue]],
                                  };
    
    
    NSDictionary *AccountsDict = @{
                                   childalphaNumbericStr:childAccount,
                                   parentalphaNumbericStr:mainAccount,
                                   };
    NSDictionary *transcationDict = @{};
    
    NSDictionary *postDict = @{
                               @"accounts":AccountsDict,
                               @"loginPin": _pinTxt.text,
                               @"mobileNumber": _contactNoTxt.text,
                               @"name": _nameTxt.text,
                               @"transactionPin": _upiTxt.text,
                               @"transactions": transcationDict,
                               };
    NSLog(@"patch request ---->>> %@",postDict);
    
    return postDict;
}

-(void)success_response:(id)response{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"response ---->>>> %@",response);
        [self stopActivityIndicator];
        [PBUtility loginResponseSetToDefaults:response];
        
        if (bleManager.centralManager.state == CBManagerStatePoweredOn) {
            //NSLog(@"bluetooth on --------------->>>> go to home screen");
            PBHomeViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"PBHomeViewController"];
            [self.navigationController pushViewController:home animated:YES];
        }else{
            // NSLog(@"bluetooth off --------------->>>> go to ble screen");
            PBCheckBLEViewController *ble = [self.storyboard instantiateViewControllerWithIdentifier:@"PBCheckBLEViewController"];
            [self.navigationController pushViewController:ble animated:YES];
            
        }
    });
}

-(void)failure_error:(NSString *)errStr{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicator];
        NSLog(@"Error ---->>>> %@",errStr);
        [PBUtility showAlertWithMessage:errStr title:@""];
    });
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==self.contactNoTxt) {
        self.enteredMobileNo = textField.text;
        NSLog(@"mobile number ----->>>> %@",self.enteredMobileNo);
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
//}

-(void)validateInputs{
    [_nameTxt addRegx:REGEX_USER_NAME_LIMIT withMsg:LocalizedString(@"Please enter name with minimum 3 and maximum 20 characters")];
    [_contactNoTxt addRegx:REGEX_PHONE_DEFAULT withMsg:LocalizedString(@"Please enter 10 digit mobile number")];
    
    [_pinTxt addRegx:REGEX_PIN_LENGTH withMsg:LocalizedString(@"Please enter 4 digit login Pin")];
    [_confirmPinTxt addConfirmValidationTo:_pinTxt withMsg:LocalizedString(@"Confirmation pin is not matched with login pin")];
    
    [_upiTxt addRegx:REGEX_UPI_LENGTH withMsg:LocalizedString(@"Please enter 6 digit transaction pin")];
    [_confirmUpiTxt addConfirmValidationTo:_upiTxt withMsg:LocalizedString(@"Confirmation transaction pin is not matched with transaction Pin")];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"textfiled delegate ------>>>>");
    if (textField==_contactNoTxt) {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 10;
    }
    else if (textField==_nameTxt){
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 20;
    }
    else if (textField==_pinTxt||textField==_confirmPinTxt){
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 4;
    }
    else{
        return YES;
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
