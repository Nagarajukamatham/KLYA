//
//  PBActivityView.h
//  PiggyBank
//
//  Created by Nagaraju on 17/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PBActivityViewDelegate;

@interface PBActivityView : UIView
@property (nonatomic, assign) CGFloat strokeThickness;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) id<PBActivityViewDelegate> activityDelegate;
-(void)setCloseButtonToView:(BOOL)value;
@end

@protocol PBActivityViewDelegate <NSObject>

@optional
- (void)didSelectCloseKeyboard;
@end
