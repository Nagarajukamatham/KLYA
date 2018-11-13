//
//  SplashViewController.m
//  PiggyBank
//
//  Created by Nagaraju on 17/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "SplashViewController.h"
#import "PBUtility.h"
#import "PBConstants.h"
#import "PBSignUpViewController.h"
#import "PBPinViewController.h"
#import "PBMoneySwipeViewController.h"
#import "PBSearchViewController.h"

#import "HDLocalizeHelper.h"
#import "NSBundle+Language.h"


@interface SplashViewController (){
    NSUserDefaults *def;
    
}

@end

@implementation SplashViewController
@synthesize maskImgView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    [numberFormatter setLocale:[NSLocale currentLocale]];
//    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//    [numberFormatter setMaximumFractionDigits:2];
//    NSString *theString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:99999.72]];
//    NSLog(@"The string--->>>: %@", theString);
    
    
    def = [NSUserDefaults standardUserDefaults];
    maskImgView.image = [PBUtility filledImageFrom:[UIImage imageNamed:@"mask"] withColor:[PBUtility colorFromHexString:APP_COLOR]];
    /*
     Here Adding localization
     */
    if (![def boolForKey:@"reloadCheck"]) {
        NSString *languageKey=@"en";
        //This is to change the text in IBoutles
        LocalizationSetLanguage(languageKey);
        //This is to change the text in UI, after this need to reload the VC
        [NSBundle setLanguage:languageKey];
        [self reloadRootViewController];
    }
    else{
        [def setBool:NO forKey:@"reloadCheck"];
        [self performSelector:@selector(moveToNext) withObject:self afterDelay:1.5];
    }
    
//        PBMoneySwipeViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"PBMoneySwipeViewController"];
//        home.transferedAmount = @"699";
//        [self.navigationController pushViewController:home animated:YES];
}

- (void)reloadRootViewController
{
    // AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [def setBool:YES forKey:@"reloadCheck"];
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    [UIApplication sharedApplication].delegate.window.rootViewController = [storyboard instantiateInitialViewController];
}
// Here Checking the user is Existed or New and navigating rspective
-(void)moveToNext{
    NSData *loginData = [def objectForKey:@"loginResp"];
    NSDictionary *loginDict = [NSKeyedUnarchiver unarchiveObjectWithData:loginData];
    if (loginDict != NULL) {
        // go to PIN screen
        PBPinViewController *pin = [self.storyboard instantiateViewControllerWithIdentifier:@"PBPinViewController"];
        [self.navigationController pushViewController:pin animated:YES];
    }else{
        // signUp 
        PBSignUpViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"PBSignUpViewController"];
        [self.navigationController pushViewController:login animated:YES];
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
