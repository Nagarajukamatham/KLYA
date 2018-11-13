//
//  PBInterfaceOrientation.h
//  PiggyBank
//
//  Created by Nagaraju on 17/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, InterfaceOrientationType) {
    InterfaceOrientationTypePortrait,
    InterfaceOrientationTypeLandscape
};

@interface PBInterfaceOrientation : NSObject

+ (InterfaceOrientationType)orientation;

@end
