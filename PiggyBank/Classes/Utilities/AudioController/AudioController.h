//
//  AudioController.h
//  PiggyBank
//
//  Created by Nagaraju on 02/05/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioController : NSObject
- (instancetype)init;
- (void)playSystemSound:(NSString*)soundName;

@end
