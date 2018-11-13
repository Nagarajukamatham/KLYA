//
//  PBSuccessViewController.m
//  PiggyBank
//
//  Created by Nagaraju on 30/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBSuccessViewController.h"
#import "PBHomeViewController.h"
#import "UIImage+animatedGIF.h"

@interface PBSuccessViewController ()

@end

@implementation PBSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.finishBtn.layer.cornerRadius=5.0;
    
    NSURL *urlZif = [[NSBundle mainBundle] URLForResource:@"success" withExtension:@"gif"];
  //  NSString *path=[[NSBundle mainBundle]pathForResource:@"bar180" ofType:@"gif"];
   // NSURL *url=[[NSURL alloc] initFileURLWithPath:path];
    self.successimgView.image= [UIImage animatedImageWithAnimatedGIFURL:urlZif];
}

-(IBAction)doneBtnClicked:(id)sender{
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
