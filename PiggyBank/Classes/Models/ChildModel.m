//
//  ChildModel.m
//  PiggyBank
//
//  Created by Nagaraju on 29/01/1940 Saka.
//  Copyright © 1940 Saka Nagaraju. All rights reserved.
//

#import "ChildModel.h"

@implementation ChildModel
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.accountId forKey:@"accountId"];
    [encoder encodeObject:self.accountName forKey:@"accountName"];
    [encoder encodeObject:self.accountType forKey:@"accountType"];
    [encoder encodeObject:self.accountNumber forKey:@"accountNumber"];
    [encoder encodeDouble:self.balance forKey:@"balance"];
    [encoder encodeObject:self.piggyDetails forKey:@"piggyDetails"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _accountId = [decoder decodeObjectForKey:@"accountId"];
        _accountName = [decoder decodeObjectForKey:@"accountName"];
        _accountType = [decoder decodeObjectForKey:@"accountType"];
        _accountNumber = [decoder decodeObjectForKey:@"accountNumber"];
        _balance = [decoder decodeDoubleForKey:@"balance"];
        _piggyDetails = [decoder decodeObjectForKey:@"piggyDetails"];
    }
    return self;
}
@end
