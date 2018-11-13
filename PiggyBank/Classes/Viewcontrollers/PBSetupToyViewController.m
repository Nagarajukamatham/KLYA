//
//  PBSetupToyViewController.m
//  PiggyBank
//
//  Created by Nagaraju on 20/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBSetupToyViewController.h"
#import "PBInterfaceOrientation.h"
#import "PBUtility.h"
#import "PBConfirmationViewController.h"
#import "PBConstants.h"
#import "PBNetworkCall.h"
#import "BLEManager.h"
#import "PBMessage.h"

#import "UserModel.h"
#import "HDLocalizeHelper.h"

@interface PBSetupToyViewController ()<PBAccountSelectionViewDelegate,networkDelegate,BLESerialDelegate>{
    NSMutableArray *dummy;
    BOOL selected;
    NSDictionary *selectedAcc;
    NSUserDefaults *def;
    PBNetworkCall *networkCall;
    UserModel *user;
    BLEManager *bleManager;
    BOOL keyboardIsShown;
    NSInteger kTabBarHeight;
}

@end

@implementation PBSetupToyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kTabBarHeight = 0;
    bleManager = [[BLEManager alloc] init];
    bleManager.serialDelegate = self;
    def = [NSUserDefaults standardUserDefaults];
    NSData *loginData = [def objectForKey:@"loginResp"];
    user = [NSKeyedUnarchiver unarchiveObjectWithData:loginData];
    
    networkCall = [[PBNetworkCall alloc] init];
    networkCall.delegate = self;
    
    selectedAcc=[[NSDictionary alloc] init];
    if ([self.selectedToy.name isEqualToString:@"MLT-BT05"]) {
        self.piggyToyName.text = @"KLYA-WHITE";
    }else if([self.selectedToy.name isEqualToString:@"BT05"]){
       self.piggyToyName.text = @"KLYA-PINK";
    }else{
       self.piggyToyName.text = @"UNKNOWN";
    }
    
    if (user.accounts.child.piggyDetails.piggyName.length!=0) {
        _nameTxt.text = user.accounts.child.piggyDetails.piggyName;
        self.selectedAccountLbl.text = [PBUtility spaceBetweenAcNo:user.accounts.child.accountNumber];
        self.selectedAccountLbl.textColor = [UIColor blackColor];
    }
    
    self.accountSelectionBtn.layer.borderWidth=0.5;
    self.accountSelectionBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.accountSelectionBtn.layer.cornerRadius=5.0;
    self.accountSelectionBtn.backgroundColor=[UIColor clearColor];
    self.continueBtn.layer.cornerRadius=5.0;
    
    // For account number drop down list
    dummy=[[NSMutableArray alloc] init];
    NSString *childBalance = [NSString stringWithFormat:@"%0.f",user.accounts.child.balance];
    NSDictionary *option1 = @{
                              @"account": [NSString stringWithFormat:@"%@",[PBUtility spaceBetweenAcNo:user.accounts.child.accountNumber]],
                              @"balance" : [PBUtility amountWithRupee:childBalance],
                              };
    [dummy addObject:option1];
    
    if (dummy.count==1) {
//        self.accountSelectionBtn.userInteractionEnabled=NO;
//        selectedAcc=[dummy objectAtIndex:0];
//        self.selectedAccountLbl.text = [selectedAcc objectForKey:@"account"];
//        self.selectedAccountLbl.textColor = [UIColor blackColor];
    }else{
        
    }
    [_nameTxt addRegx:REGEX_PIGGY_NAME_LIMIT withMsg:ERROR_MSG_PIGGYNAME_LENGTH];
    [self registerKeybaordNotifications];
}


-(void)serialDidUpdateState{
    if (bleManager.centralManager.state != CBManagerStatePoweredOn) {
        NSLog(@"************* serial Bluetooth TrunOff **************");
    }
}

-(IBAction)selectAccountBtnclicked:(id)sender{
    
    if ( !self.accountSelectionView) {
        self.accountSelectionView = [[PBAccountSelectionView alloc] initWithFrame:[self getAccountSelectionViewPostion]];
        self.accountSelectionView.accountSelectionDelegate = self;
        self.accountSelectionView.accountsArray = dummy;
        [self.view addSubview:self.accountSelectionView];
    }

    if (selected) {
        self.arrowImgView.transform = CGAffineTransformMakeRotation(0); // flip the image view
        selected=NO;
        [self.accountSelectionView removeFromSuperview];
        self.accountSelectionView =nil;
    }
    else{
        self.arrowImgView.transform = CGAffineTransformMakeRotation(M_PI);
        selected=YES;
    }
}

- (void)didSelectAccount:(id)selectedAccount withIndex:(NSInteger) index selectionView:(PBAccountSelectionView *)selectionView {
    selectedAcc=selectedAccount;
    [dummy removeObjectAtIndex:index];
    [dummy insertObject:selectedAcc atIndex:0];
    NSLog(@"selectedAccount--->>> %@",selectedAcc);
    self.selectedAccountLbl.text = [selectedAccount objectForKey:@"account"];
    self.selectedAccountLbl.textColor = [UIColor blackColor];
    self.arrowImgView.transform = CGAffineTransformMakeRotation(0); // flip the image view
    selected=NO;
    [self.accountSelectionView removeFromSuperview];
    self.accountSelectionView =nil;
}

- (IBAction)continueBtnClicked:(id)sender {
    if ([self.selectedAccountLbl.text isEqualToString:@"Please select Account number"]) {
        [PBUtility showAlertWithMessage:LocalizedString(@"Please select the Account") title:@""];
        return;
    }
    
    if ([_nameTxt validate] && _nameTxt.text.length!=0) {
        
        PBConfirmationViewController *confirm = [self.storyboard instantiateViewControllerWithIdentifier:@"PBConfirmationViewController"];
        confirm.selectedToy=self.selectedToy;
        confirm.toyManualName=self.piggyToyName.text;
        confirm.writeCharacteristic=self.writeCharacteristic;
        confirm.selectedAccountNumber= self.selectedAccountLbl.text;//[selectedAcc objectForKey:@"account"];
        confirm.enteredPiggyName = self.nameTxt.text;
        [self.navigationController pushViewController:confirm animated:YES];

    }
}


-(CGRect)getAccountSelectionViewPostion {
    CGRect frame = [self.view convertRect:self.accountSelectionBtn.bounds fromView:self.accountSelectionBtn];
    CGFloat keybaordHeight = 0.0f;
    CGFloat accountViewStartY = CGRectGetMaxY(frame);
    if ([PBInterfaceOrientation orientation] == InterfaceOrientationTypePortrait) {
        keybaordHeight = self.view.frame.size.height;//[PBUtility getKeyboardHeight];
    }else{ // iphone8--- 280, se---230
        if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS){
            keybaordHeight = self.view.frame.size.width-230;
        }else{
            keybaordHeight = self.view.frame.size.width-280;
        }
        
    }
    CGFloat acccuntViewHeight = keybaordHeight - accountViewStartY - 15;
    CGFloat maximumHeight = 44 * [dummy count] + 15;
    if (maximumHeight < acccuntViewHeight) {
        acccuntViewHeight = maximumHeight;
    }
    CGRect accountViewFrame = CGRectMake(0, accountViewStartY, CGRectGetWidth(self.view.bounds), acccuntViewHeight);
    return accountViewFrame;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)registerKeybaordNotifications{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    keyboardIsShown = NO;
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
    CGSize scrollContentSize = CGSizeMake(320, 345);
    self.myScroll.contentSize = scrollContentSize;
}

- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    // resize the scrollview
    CGRect viewFrame = self.myScroll.frame;
    viewFrame.size.height += (keyboardSize.height - kTabBarHeight);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.myScroll setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    if (keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.myScroll.frame;
    viewFrame.size.height -= (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.myScroll setFrame:viewFrame];
    [UIView commitAnimations];
    keyboardIsShown = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"textfiled delegate ------>>>>");
    if (textField==_nameTxt) {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 10;
    }

    else{
        return YES;
    }
    
}

-(IBAction)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
