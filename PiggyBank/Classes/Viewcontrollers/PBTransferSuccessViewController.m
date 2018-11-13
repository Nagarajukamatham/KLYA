//
//  PBTransferSuccessViewController.m
//  PiggyBank
//
//  Created by Nagaraju on 29/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBTransferSuccessViewController.h"
#import "PBUtility.h"
#import "PBMoneySwipeViewController.h"
#import "PBSearchViewController.h"
#import "PBHomeViewController.h"
#import "UserModel.h"
#import "HDLocalizeHelper.h"
#import "UIImage+animatedGIF.h"
#import "BLEManager.h"

@interface PBTransferSuccessViewController (){
    NSUserDefaults *defaults;
    BLEManager *bleManager;
}

@end

@implementation PBTransferSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bleManager = [[BLEManager alloc] init];
    defaults = [NSUserDefaults standardUserDefaults];
    NSData *loginData = [defaults objectForKey:@"loginResp"];
    UserModel *user = [NSKeyedUnarchiver unarchiveObjectWithData:loginData];
    
    self.upadteBtn.layer.cornerRadius=5.0;
    self.amountLbl.text = [PBUtility amountWithRupee:self.enteredAmount];
    self.descriptionLbl.text = self.enteredDescription;
    self.fromNameLbl.text = user.name;
    self.toNameLbl.text = user.accounts.child.piggyDetails.piggyName;
    self.toccountNumberLbl.text= [PBUtility spaceBetweenAcNo:user.accounts.child.accountNumber];
    self.fromAccountNumberLbl.text = [PBUtility spaceBetweenAcNo:user.accounts.parent.accountNumber];
    self.dateLbl.text = [PBUtility getDateTimeWithFormat:@"dd MMMM YYYY HH:mm"];
    
    NSURL *urlZif = [[NSBundle mainBundle] URLForResource:@"success" withExtension:@"gif"];
    self.successimgView.image= [UIImage animatedImageWithAnimatedGIFURL:urlZif];
}

-(IBAction)updatePiggyBankBtnClicked:(id)sender{
    if (bleManager.centralManager.state != CBManagerStatePoweredOn) {
        // NSLog(@"Please turnOn Bluetooth ------>>>");
        [PBUtility showAlertWithMessage:LocalizedString(@"Your Bluetooth is turnOff, please turnon Bluetooth to search KLYA") title:@""];
    }else{
        PBSearchViewController *search = [self.storyboard instantiateViewControllerWithIdentifier:@"PBSearchViewController"];
        search.cameFrom = @"transfer";
        search.amountToTransfer =self.enteredAmount;
        [self.navigationController pushViewController:search animated:YES];
    }
}

-(IBAction)homeBtnClicked:(id)sender{
    PBHomeViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"PBHomeViewController"];
    [self.navigationController pushViewController:home animated:YES];
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
