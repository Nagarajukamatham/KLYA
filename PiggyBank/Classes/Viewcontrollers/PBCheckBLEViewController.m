//
//  PBCheckBLEViewController.m
//  PiggyBank
//
//  Created by Nagaraju on 17/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBCheckBLEViewController.h"
#import "PBUtility.h"
#import "PBConstants.h"
#import "PBHomeViewController.h"
#import "BLEManager.h"

@interface PBCheckBLEViewController (){
    BLEManager *bleManager;
}

@end

@implementation PBCheckBLEViewController
@synthesize maskImgView,turnOnBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    bleManager=[[BLEManager alloc] init];
   // bleManager.serialDelegate = self;
    turnOnBtn.layer.cornerRadius = 5.0;
    maskImgView.image = [PBUtility filledImageFrom:[UIImage imageNamed:@"mask"] withColor:[PBUtility colorFromHexString:APP_COLOR]];
}

-(void)serialDidUpdateState{
//    NSLog(@"serialDidUpdateState --------------->>>>");
    if (bleManager.centralManager.state != CBManagerStatePoweredOn) {
        NSLog(@"bluetooth off =>==>>=>>>check");
    }else{
        NSLog(@"bluetooth on  =>>====>>>>check");
    }
}

- (IBAction)skipBtnClicked:(id)sender {
    PBHomeViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"PBHomeViewController"];
    [self.navigationController pushViewController:home animated:YES];
    
}

//Opening the device Bluetooth settings
- (IBAction)turnOnBlebtnClicked:(id)sender {
    //@"prefs:root=General&path=Keyboard"       @"App-Prefs:root=General&path=Keyboard/KEYBOARDS"
     //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Bluetooth"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Bluetooth"] options:nil completionHandler:nil];
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
