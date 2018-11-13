//
//  PBInterfaceOrientation.m
//  PiggyBank
//
//  Created by Nagaraju on 17/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBInterfaceOrientation.h"

@implementation PBInterfaceOrientation

+ (InterfaceOrientationType)orientation{
    
    CGSize sizeInPoints = [UIScreen mainScreen].bounds.size;
    InterfaceOrientationType result = (sizeInPoints.width < sizeInPoints.height) ? InterfaceOrientationTypePortrait : InterfaceOrientationTypeLandscape;
    
    return result;
}


@end
