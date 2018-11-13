//
//  PBLoginViewController.m
//  PiggyBank
//
//  Created by Nagaraju on 17/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBLoginViewController.h"
#import "PBUtility.h"
#import "PBConstants.h"
#import "PBNetworkCall.h"
#import "PBHomeViewController.h"
#import "HDLocalizeHelper.h"

@interface PBLoginViewController ()<networkDelegate>{
    NSUserDefaults *def;
    PBNetworkCall *networkCall;
    BOOL isLoginAPI;
}

@end

@implementation PBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    def = [NSUserDefaults standardUserDefaults];
    networkCall = [[PBNetworkCall alloc] init];
    networkCall.delegate = self;
    
    NSString *fullText = LocalizedString(@"Click here to SignUp");
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: [UIColor darkGrayColor],
                              NSFontAttributeName: [UIFont systemFontOfSize:12]
                              };
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:fullText
                                           attributes:attribs];
    UIColor *gColor = [UIColor whiteColor];
    NSRange greenTextRange = [fullText rangeOfString:@"SignUp"];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:gColor}
                            range:greenTextRange];
    [_signUpBtn setAttributedTitle:attributedText forState:UIControlStateNormal];
    
    
    [_contactNoTxt addRegx:REGEX_PHONE_DEFAULT withMsg:ERROR_MSG_PHONENO_LENGTH];
    [_pinTxt addRegx:REGEX_PIN_LENGTH withMsg:ERROR_MSG_PIN_LENGTH];
    
    _proceedBtn.layer.cornerRadius = 5.0;
    _proceedBtn.layer.masksToBounds=YES;
}

-(IBAction)signUpBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelBtnClicked:(id)sender {
    [self.view endEditing:YES];
    _contactNoTxt.text=@"";
    _pinTxt.text=@"";
}
- (IBAction)proceedBtnClicked:(id)sender {
    if ([_contactNoTxt validate] & [_pinTxt validate]) {
        [self.view endEditing:YES];
        [self startActivityIndicator:YES];
        //[networkCall getserviceCallurlStr:_contactNoTxt.text];
        [networkCall checkExistedUserUrlStr:_contactNoTxt.text];
    }
}

-(IBAction)forgotLoginPinBtnClicked:(id)sender{
    if (_contactNoTxt.text.length==10) {
        [self startActivityIndicator:YES];
        isLoginAPI=NO;
        [self loginServiCall];
    }else{
        [PBUtility showAlertWithMessage:LocalizedString(@"Please enter your registered mobile number") title:@""];
    }
}

//Checking the user before login, whether it have account(Registerd user) or not , If not showing alert
-(void)isExistedUserCheck_response:(id)response{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *str = (NSString*)response;
        if ([str isEqualToString:@"null"] || [str isEqualToString:@""]) {
            [self stopActivityIndicator];
            _contactNoTxt.text=@"";
            _pinTxt.text=@"";
            [PBUtility showAlertWithMessage:LocalizedString(@"This user is not yet sign up, Please sign up") title:@""];
        }else{
            isLoginAPI=YES;
            [self loginServiCall];
        }
    });
}

-(void)loginServiCall{
    [networkCall getserviceCallurlStr:_contactNoTxt.text];
}

-(void)success_getresponse:(id)response{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicator];
      //  NSLog(@"response ---->>>> %@",response);
        if (isLoginAPI) {
            if ([[response objectForKey:@"loginPin"] isEqualToString:_pinTxt.text]) {
                // Storing response into user defaults
                [PBUtility loginResponseSetToDefaults:response];
                PBHomeViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"PBHomeViewController"];
                [self.navigationController pushViewController:home animated:YES];
            }else{
                _contactNoTxt.text = nil;
                _pinTxt.text = nil;
                [PBUtility showAlertWithMessage:LocalizedString(@"Please enter correct Login Pin") title:@""];
            }
        }else{
            //forgot login pin
            NSString *msgStr = [NSString stringWithFormat:@"Your login pin is %@",[response objectForKey:@"loginPin"]];
            [PBUtility showAlertWithMessage:msgStr title:@""];
        }
    });
}

-(void)failure_error:(NSString *)errStr{
    NSLog(@"errStr ---->>>> %@",errStr);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicator];
        [PBUtility showAlertWithMessage:errStr title:@""];
    });
}

-(void)failure_geterror:(NSString *)errStr{
    NSLog(@"errStr ---->>>> %@",errStr);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicator];
        [PBUtility showAlertWithMessage:errStr title:@""];
    });
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
    }else if (textField==_pinTxt){
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
