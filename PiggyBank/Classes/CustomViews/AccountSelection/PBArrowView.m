//
//  PBArrowView.m
//  PiggyBank
//
//  Created by Nagaraju on 21/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBArrowView.h"
#import "PBConstants.h"

@implementation PBArrowView

-(void)drawRect:(CGRect)rect
{
    
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat height = self.bounds.size.height;
    UIBezierPath *fillPath = [UIBezierPath bezierPath];
    [fillPath moveToPoint:CGPointMake(0, self.bounds.origin.y+height)];
    [fillPath addLineToPoint:CGPointMake(0, height)];
    [fillPath addLineToPoint:CGPointMake(self.bounds.size.width/2, 0)];
    [fillPath addLineToPoint:CGPointMake(self.bounds.size.width, height)];
    [fillPath closePath];
    
    CGContextAddPath(context, fillPath.CGPath);
    //CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetFillColorWithColor(context, UIColorFromRGB(0xB8D028).CGColor);
    CGContextFillPath(context);
    
    
}

@end
