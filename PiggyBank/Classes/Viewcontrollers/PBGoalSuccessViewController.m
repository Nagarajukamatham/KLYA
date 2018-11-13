//
//  PBGoalSuccessViewController.m
//  PiggyBank
//
//  Created by Nagaraju on 30/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBGoalSuccessViewController.h"
#import "PBSearchViewController.h"
#import "PBUtility.h"
#import "PBHomeViewController.h"
#import "UIImage+animatedGIF.h"
#import "BLEManager.h"
#import "HDLocalizeHelper.h"

@interface PBGoalSuccessViewController (){
    BLEManager *bleManager;
}

@end

@implementation PBGoalSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bleManager = [[BLEManager alloc] init];
    self.updateBtn.layer.cornerRadius=5.0;
    
    self.goalNameLbl.text = self.enteredGoalName;
    self.goalAmountLbl.text = [PBUtility amountWithRupee:self.enteredGoalAmount];
    self.goalDateLbl.text = self.goalDate;
    
    double extraToSave = [self.enteredGoalAmount doubleValue] - [self.childAvailableBalance doubleValue];
    self.extraSaveLbl.text = [PBUtility amountWithRupee:[NSString stringWithFormat:@"%.2f",extraToSave]];
    
    NSURL *urlZif = [[NSBundle mainBundle] URLForResource:@"success" withExtension:@"gif"];
    self.successimgView.image= [UIImage animatedImageWithAnimatedGIFURL:urlZif];
}
- (IBAction)updatePiggyBtnClicked:(id)sender {
    if (bleManager.centralManager.state != CBManagerStatePoweredOn) {
        // NSLog(@"Please turnOn Bluetooth ------>>>");
        [PBUtility showAlertWithMessage:LocalizedString(@"Your Bluetooth is turnOff, please turnon Bluetooth to search KLYA") title:@""];
    }else{
        PBSearchViewController *search = [self.storyboard instantiateViewControllerWithIdentifier:@"PBSearchViewController"];
        search.cameFrom = @"goal";
        search.amountToTransfer =self.enteredGoalAmount;
        search.goalName = self.enteredGoalName;
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
