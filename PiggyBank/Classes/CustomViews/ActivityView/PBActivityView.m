//
//  PBActivityView.m
//  PiggyBank
//
//  Created by Nagaraju on 17/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBActivityView.h"
#import "PBInterfaceOrientation.h"
#import "PBConstants.h"

@interface PBActivityView ()
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIButton *closeBtn;
@property (nonatomic, strong) CAShapeLayer *indefiniteAnimatedLayer;

@end

@implementation PBActivityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = 987;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.0f;
        
        UIView *bgView = [[UIView alloc]initWithFrame:self.bounds];
        bgView.alpha = .4f;
        [bgView setBackgroundColor:[UIColor grayColor]];
        [self addSubview:bgView];
        self.backgroundView = bgView;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return self;
}
-(void)closeBtnAction {
    if (self.activityDelegate && [self.activityDelegate respondsToSelector:@selector(didSelectCloseKeyboard)]) {
        
        [self.activityDelegate didSelectCloseKeyboard];
    }
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGFloat gradLocs[] = {0, 1};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    struct CGColor *color1 = [[UIColor whiteColor] colorWithAlphaComponent:0.0].CGColor;
    struct CGColor *color2 = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
    struct CGColor *color3 = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    CFArrayRef arr = (__bridge CFArrayRef)@[(__bridge id)color1, (__bridge id)color2, (__bridge id)color3];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, arr, gradLocs);
    
    CGContextDrawLinearGradient(context,
                                gradient,
                                CGPointMake(CGRectGetMidX(self.backgroundView.bounds), CGRectGetMinY(self.backgroundView.bounds)),
                                CGPointMake(CGRectGetMidX(self.backgroundView.bounds), CGRectGetMaxY(self.backgroundView.bounds)),
                                0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(context);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateActivityLayout];
}

- (void)updateActivityLayout {
    
    CGRect bounds = self.superview.bounds;
    CGRect barFrame = bounds;
    barFrame.size.width = CGRectGetWidth(bounds);
    barFrame.origin.y = 0;
    if ([PBInterfaceOrientation orientation] == InterfaceOrientationTypePortrait) {
        if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
            barFrame.size.height = NBKEYBOARDHEIGHT_PORTRAIT_IPHONE_5;
        }
        else if (IS_IPHONE_6){
            
            barFrame.size.height = NBKEYBOARDHEIGHT_PORTRAIT_IPHONE_6;
        }
        else if(IS_IPHONE_6P || IS_IPHONE_X){
            
            barFrame.size.height = NBKEYBOARDHEIGHT_PORTRAIT_IPHONE_6P;
        }
        else if (IS_IPAD) {
            barFrame.size.height = NBKEYBOARDHEIGHT_PORTRAIT_IPAD;
        }
    }
    else{
        if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
            barFrame.size.height = NBKEYBOARDHEIGHT_Lansacpe_IPHONE_5;
        }
        else if (IS_IPHONE_6){
            
            barFrame.size.height = NBKEYBOARDHEIGHT_Lansacpe_IPHONE_6;
        }
        else if(IS_IPHONE_6P || IS_IPHONE_X){
            
            barFrame.size.height = NBKEYBOARDHEIGHT_Lansacpe_IPHONE_6P;
        }
        else if (IS_IPAD) {
            barFrame.size.height = NBKEYBOARDHEIGHT_Lansacpe_IPAD;
        }
        else{
            barFrame.size.height = NBKEYBOARDHEIGHT_Lansacpe_IPHONE;
        }
    }
    
    self.backgroundView.frame = self.frame;
    CALayer *layer = self.indefiniteAnimatedLayer;
    layer.position = self.backgroundView.center;
    
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self layoutAnimatedLayer];
    } else {
        [_indefiniteAnimatedLayer removeFromSuperlayer];
        _indefiniteAnimatedLayer = nil;
    }
}

- (void)layoutAnimatedLayer {
    CALayer *layer = self.indefiniteAnimatedLayer;
    
    [self.layer addSublayer:layer];
    layer.position = CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(layer.bounds) / 2, CGRectGetHeight(self.bounds) - CGRectGetHeight(layer.bounds) / 2);
}

- (CAShapeLayer*)indefiniteAnimatedLayer {
    if(!_indefiniteAnimatedLayer) {
        CGPoint arcCenter = CGPointMake(self.radius+self.strokeThickness/2+5, self.radius+self.strokeThickness/2+5);
        CGRect rect = CGRectMake(0.0f, 0.0f, arcCenter.x*2, arcCenter.y*2);
        
        UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                                    radius:self.radius
                                                                startAngle:M_PI*3/2
                                                                  endAngle:M_PI/2+M_PI*5
                                                                 clockwise:YES];
        
        _indefiniteAnimatedLayer = [CAShapeLayer layer];
        _indefiniteAnimatedLayer.contentsScale = [[UIScreen mainScreen] scale];
        _indefiniteAnimatedLayer.frame = rect;
        _indefiniteAnimatedLayer.fillColor = [UIColor clearColor].CGColor;
        _indefiniteAnimatedLayer.strokeColor = self.strokeColor.CGColor;
        _indefiniteAnimatedLayer.lineWidth = self.strokeThickness;
        _indefiniteAnimatedLayer.lineCap = kCALineCapRound;
        _indefiniteAnimatedLayer.lineJoin = kCALineJoinBevel;
        _indefiniteAnimatedLayer.path = smoothedPath.CGPath;
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.contents = (id)[[UIImage imageNamed:@"angle-mask_HD"] CGImage];
        maskLayer.frame = _indefiniteAnimatedLayer.bounds;
        _indefiniteAnimatedLayer.mask = maskLayer;
        
        NSTimeInterval animationDuration = 1;
        CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.fromValue = 0;
        animation.toValue = [NSNumber numberWithFloat:M_PI*2];
        animation.duration = animationDuration;
        animation.timingFunction = linearCurve;
        animation.removedOnCompletion = NO;
        animation.repeatCount = INFINITY;
        animation.fillMode = kCAFillModeForwards;
        animation.autoreverses = NO;
        [_indefiniteAnimatedLayer.mask addAnimation:animation forKey:@"rotate"];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = INFINITY;
        animationGroup.removedOnCompletion = NO;
        animationGroup.timingFunction = linearCurve;
        
        CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeStartAnimation.fromValue = @0.015;
        strokeStartAnimation.toValue = @0.515;
        
        CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeEndAnimation.fromValue = @0.485;
        strokeEndAnimation.toValue = @0.985;
        
        animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
        [_indefiniteAnimatedLayer addAnimation:animationGroup forKey:@"progress"];
        
    }
    return _indefiniteAnimatedLayer;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (self.superview) {
        [self layoutAnimatedLayer];
    }
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    
    [_indefiniteAnimatedLayer removeFromSuperlayer];
    _indefiniteAnimatedLayer = nil;
    
    if (self.superview) {
        [self layoutAnimatedLayer];
    }
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    _indefiniteAnimatedLayer.strokeColor = strokeColor.CGColor;
}

- (void)setStrokeThickness:(CGFloat)strokeThickness {
    _strokeThickness = strokeThickness;
    _indefiniteAnimatedLayer.lineWidth = _strokeThickness;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake((self.radius+self.strokeThickness/2+5)*2, (self.radius+self.strokeThickness/2+5)*2);
}
-(void)setCloseButtonToView:(BOOL)value {
    if (value) {
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [self.closeBtn setImage:[UIImage imageNamed:@"closebutton_white_HD"] forState:UIControlStateNormal];
        [self.closeBtn setFrame:CGRectMake(0, 0, 32, 32)];
        [self.closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeBtn];
        
        [self.closeBtn bringSubviewToFront:self];
        
        NSLayoutConstraint *closeButtonRightSideConstraint = [NSLayoutConstraint constraintWithItem:self.closeBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15.0];
        
        NSLayoutConstraint *closeButtonTopConstraint = [NSLayoutConstraint constraintWithItem:self.closeBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeTop multiplier:1.0 constant:15.0];
        
        [self addConstraints:@[closeButtonRightSideConstraint, closeButtonTopConstraint]];
    }
}


@end
