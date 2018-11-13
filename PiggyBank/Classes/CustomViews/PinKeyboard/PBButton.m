//
//  PBButton.m
//  PiggyBank
//
//  Created by Nagaraju on 19/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBButton.h"

@implementation PBButton

- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
}

- (void) setHighlighted:(BOOL)highlighted {
    
    if (highlighted) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
    }
    else {
       self.backgroundColor = [UIColor clearColor];
        
    }
}

@end
