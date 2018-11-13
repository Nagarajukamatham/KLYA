//
//  PBSetGoalViewController.m
//  PiggyBank
//
//  Created by Nagaraju on 22/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBSetGoalViewController.h"
#import "PBConstants.h"
#import "PBNetworkCall.h"
#import "PBUtility.h"
#import "PBGoalSuccessViewController.h"
#import "UserModel.h"
#import "HDLocalizeHelper.h"

@interface PBSetGoalViewController ()<networkDelegate>{
    PBNetworkCall *networkCall;
    NSUserDefaults *def;
    UserModel *user;
    NSString *selectedDateString;
}

@end

@implementation PBSetGoalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    def = [NSUserDefaults standardUserDefaults];
    NSData *loginData = [def objectForKey:@"loginResp"];
    user = [NSKeyedUnarchiver unarchiveObjectWithData:loginData];
    
    networkCall = [[PBNetworkCall alloc] init];
    networkCall.delegate=self;
    self.goalBtn.layer.cornerRadius=5.0;
    
    [_goalNameTxt addRegx:REGEX_GOALNAME_LIMIT withMsg:ERROR_MSG_GOALNAME];
    [_goalAmtTxt addRegx:REGEX_AMOUNT_LIMIT withMsg:ERROR_MSG_GOALAMOUNT];
    
    self.datePickerBtn.layer.borderWidth=0.5;
    self.datePickerBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.datePickerBtn.layer.cornerRadius=5;
    
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.datePicker setMinimumDate:[NSDate date]];
    [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    _dateLbl.textColor=[UIColor lightGrayColor];
    [_dateLbl setText:LocalizedString(@"Please select goal date")];
    
    BOOL isGoalCreated = user.accounts.child.piggyDetails.goalCreated;
//    double goalAmt = [user.accounts.child.piggyDetails.goalAmount doubleValue];
//    double childBal = user.accounts.child.balance;
    //                     1302     1301
    if (isGoalCreated ) { //&& goalAmt > childBal
        self.headerLbl.text = LocalizedString(@"Update goal");
        _goalAmtTxt.text = [NSString stringWithFormat:@"%@",user.accounts.child.piggyDetails.goalAmount];
        _goalNameTxt.text = user.accounts.child.piggyDetails.goalName;
        _dateLbl.text = user.accounts.child.piggyDetails.goalDate;
        _dateLbl.textColor=[UIColor blackColor];
        [self.goalBtn setTitle:LocalizedString(@"Update goal") forState:UIControlStateNormal];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self hideDatePicker];
}

- (void)onDatePickerValueChanged:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"]; //hh:mm a
    selectedDateString = [dateFormat stringFromDate:sender.date];
    _dateLbl.textColor=[UIColor blackColor];
    self.dateLbl.text = [PBUtility dateChangeFormate:@"dd/MM/yyyy HH:mm" fromDateStr:selectedDateString toFormate:@"dd/MM/yyyy"];
}

- (IBAction)goalBtnClicked:(id)sender {
    if ([_goalNameTxt validate] & [_goalAmtTxt validate]) {
        [self.view endEditing:YES];
       // self.datePickerView.hidden=YES;
        [self hideDatePicker];
        if ([_goalAmtTxt.text doubleValue] <= user.accounts.child.balance) {
            NSString *childBalance = [NSString stringWithFormat:@"%0.f",user.accounts.child.balance];
            NSString *str = LocalizedString(@"Please enter the goal amount more than the KLYA balance");
            NSString *msg = [NSString stringWithFormat:@"%@(%@)",str,[PBUtility amountWithRupee:childBalance]];
            [PBUtility showAlertWithMessage:msg title:@""];
        }
        else{

            NSDictionary *payload = @{
                                      @"goalAmount":[NSNumber numberWithDouble:[_goalAmtTxt.text doubleValue]],
                                      @"goalCreatedDate":[PBUtility getDateTimeWithFormat:@"dd/MM/yyyy HH:mm"],
                                      @"goalDate":[PBUtility getDateTimeWithFormat:@"dd/MM/yyyy HH:mm"],
                                      @"goalName":_goalNameTxt.text,
                                      @"goalStatus":@"0",
                                      @"goalCreated":[NSNumber numberWithBool:true],
                                      @"piggyLastConnectedDateAndTime":[PBUtility getDateTimeWithFormat:@"dd/MM/yyyy HH:mm"]
                                      };
            
            NSLog(@"payload ---->>> %@",payload);
            
            NSString *pathStr=[NSString stringWithFormat:@"accounts/%@/piggyDetails",user.accounts.child.accountId];
            NSString *urlStr = [NSString stringWithFormat:@"%@/%@",user.mobileNumber,pathStr];
            [self startActivityIndicator:YES];
            [networkCall patchServiceurlStr:urlStr withParamas:payload];
        }
    }
}

- (IBAction)datePickerBtnClicked:(id)sender {
    [self.view endEditing:YES];
    self.datePickerView.hidden=NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat startY=self.view.frame.size.height - self.datePickerView.frame.size.height;
        self.datePickerView.frame = CGRectMake(0,startY,self.datePickerView.frame.size.width,205);
    }];
}

- (IBAction)datePickerDoneBtnClicked:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [self hideDatePicker];
    }];
}
-(void)hideDatePicker{
    CGFloat startY=self.view.frame.size.height;
    self.datePickerView.frame = CGRectMake(0,startY,self.datePickerView.frame.size.width,205);
}

-(void)success_response:(id)response{
    // NSLog(@"response ---->>>> %@",response);
    dispatch_async(dispatch_get_main_queue(), ^{
      //[self stopActivityIndicator];
        [self getUserData];
    });
}
-(void)getUserData{
    //[self startActivityIndicator:YES];
    [networkCall getserviceCallurlStr:user.mobileNumber];
}

-(void)success_getresponse:(id)response{
     NSLog(@"response ---->>>> %@",response);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicator];
        [PBUtility loginResponseSetToDefaults:response];
        
        PBGoalSuccessViewController *goalS = [self.storyboard instantiateViewControllerWithIdentifier:@"PBGoalSuccessViewController"];
        goalS.enteredGoalName = self.goalNameTxt.text;
        goalS.enteredGoalAmount = self.goalAmtTxt.text;
        goalS.childAvailableBalance=[NSString stringWithFormat:@"%0.f",user.accounts.child.balance];
        goalS.goalDate =[PBUtility getDateTimeWithFormat:@"EEEE, d MMMM YYYY"];
        [self.navigationController pushViewController:goalS animated:YES];
        
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

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"hide---->>>");
    [self hideDatePicker];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"textfiled delegate ------>>>>");
    if (textField==_goalNameTxt) {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 7;
    }
    if (textField==_goalAmtTxt) {
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
