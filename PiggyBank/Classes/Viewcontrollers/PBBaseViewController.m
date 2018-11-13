//
//  PBBaseViewController.m
//  PiggyBank
//
//  Created by Nagaraju on 16/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBBaseViewController.h"
#import "PBActivityView.h"
#import "PBUtility.h"
#import "PBConstants.h"
#import "PBSignUpViewController.h"
#import "PBLoginViewController.h"

@interface PBBaseViewController ()<PBActivityViewDelegate>
@property (nonatomic, strong) PBActivityView *activityView;

@end

@implementation PBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation PBBaseViewController (PBActivityIndicatorHelper)

#pragma mark - Activity Indicator

- (BOOL) isShowingActivityIndicator
{
    return [self.activityView superview]!=nil;
}
- (void)startActivityIndicator:(BOOL)animated {
    [self.activityView removeFromSuperview];
    self.activityView = nil;
    if (!self.activityView){
        self.activityView = [[PBActivityView alloc] initWithFrame:self.view.bounds];
        [self.activityView setStrokeThickness:3.0f];
        [self.activityView setStrokeColor:[PBUtility colorFromHexString:APP_COLOR]];
        CGFloat size = MIN(60.0f, CGRectGetWidth(self.view.frame) / 2);
        CGFloat radius = size / 2;
        [self.activityView setRadius:radius];
        
//        if ([self class] == [PBSignUpViewController class] || [self class] == [PBLoginViewController class]) {
//            self.activityView.activityDelegate = self;
//            [self.activityView setCloseButtonToView:YES];
//        }
        [UIView animateWithDuration:0.2 animations:^{
            self.activityView.alpha = 1;
        }];
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            self.activityView.alpha = 1;
        }];
    }
    [self.view addSubview:self.activityView];
}

- (void)stopActivityIndicator {
    
    [UIView animateWithDuration:0.1 animations:^{
        self.activityView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.activityView removeFromSuperview];
        self.activityView = nil;
        self.view.userInteractionEnabled = YES;
    }];
}
- (void)didSelectCloseKeyboard {
   // [(HDKeyboardViewController *)self.parentViewController.parentViewController changeKeyboard];
}

@end
