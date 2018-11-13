//
//  PBMoneyTransferViewController.m
//  PiggyBank
//
//  Created by Nagaraju on 22/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBMoneyTransferViewController.h"
#import "PBMoneySwipeViewController.h"
#import "PBConstants.h"
#import "PBUtility.h"
#import "PBNetworkCall.h"
#import "PBSearchViewController.h"
#import "PBTransferSuccessViewController.h"
#import "UserModel.h"
#import "HDLocalizeHelper.h"
@interface PBMoneyTransferViewController ()<networkDelegate>{
    NSUserDefaults *def;
    UserModel *user;
    PBNetworkCall *networkCall;
}

@end

@implementation PBMoneyTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    networkCall = [[PBNetworkCall alloc] init];
    networkCall.delegate=self;
    
    def = [NSUserDefaults standardUserDefaults];
    NSData *loginData = [def objectForKey:@"loginResp"];
    user = [NSKeyedUnarchiver unarchiveObjectWithData:loginData];
    
    self.transferBtn.layer.cornerRadius=5.0;
    [_amountTxt addRegx:REGEX_AMOUNT_LIMIT withMsg:ERROR_MSG_AMOUNT];
    [_descTxt addRegx:REGEX_DESCRIPTION_LIMIT withMsg:ERROR_MSG_DESCRIPTION];
//    self.AvlBalLbl.text = [NSString stringWithFormat:@"Available Balance : ",[PBUtility amountWithRupee:mainBalance]];
    NSString *mainBalance = [NSString stringWithFormat:@"%0.f",user.accounts.parent.balance];
    self.AvlBalLbl.text=[NSString stringWithFormat:@"Available Balance : %@",[PBUtility amountWithRupee:mainBalance]];
}

- (IBAction)transferBtnClicked:(id)sender {
    if ([_amountTxt validate] & [_descTxt validate]) {
        NSInteger parentBal = (NSInteger)user.accounts.parent.balance;
        
        if ([_amountTxt.text integerValue] <= parentBal) {
            [self.view endEditing:YES];
            [self startActivityIndicator:YES];
            NSDictionary *payload = [PBUtility transferPayload:user amount:[_amountTxt.text doubleValue] desc:_descTxt.text];
            [networkCall patchServiceurlStr:user.mobileNumber withParamas:payload];
        }else{
            NSString *msgStr = [NSString stringWithFormat:@"You can able to transfer up to %ld%@",(long)parentBal,Euro];
            [PBUtility showAlertWithMessage:msgStr title:@""];
        }
    }
}

-(void)success_response:(id)response{
    NSLog(@"response ---->>>> %@",response);
    dispatch_async(dispatch_get_main_queue(), ^{
       // [self stopActivityIndicator];
        [self getUserData];
    });
}

-(void)getUserData{
    //[self startActivityIndicator:YES];
    [networkCall getserviceCallurlStr:user.mobileNumber];
}

-(void)success_getresponse:(id)response{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicator];
        [PBUtility loginResponseSetToDefaults:response];
        
        PBTransferSuccessViewController *transferS = [self.storyboard instantiateViewControllerWithIdentifier:@"PBTransferSuccessViewController"];
        transferS.enteredAmount = self.amountTxt.text;
        transferS.enteredDescription = self.descTxt.text;
        [self.navigationController pushViewController:transferS animated:YES];
        
    });
}

-(void)failure_geterror:(NSString *)errStr{
    NSLog(@"errStr ---->>>> %@",errStr);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicator];
        [PBUtility showAlertWithMessage:errStr title:@""];
    });
}

-(void)failure_error:(NSString *)errStr{
    NSLog(@"errStr ---->>>> %@",errStr);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicator];
        [PBUtility showAlertWithMessage:errStr title:@""];
    });
}


- (IBAction)backbtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
    if (textField==_amountTxt) {
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
