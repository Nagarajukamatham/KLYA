//
//  AccountsModel.m
//  PiggyBank
//
//  Created by Nagaraju on 29/01/1940 Saka.
//  Copyright © 1940 Saka Nagaraju. All rights reserved.
//

#import "AccountsModel.h"

@implementation AccountsModel
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.child forKey:@"child"];
    [encoder encodeObject:self.parent forKey:@"parent"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.child = [decoder decodeObjectForKey:@"child"];
        self.parent = [decoder decodeObjectForKey:@"parent"];
    }
    return self;
}
@end
