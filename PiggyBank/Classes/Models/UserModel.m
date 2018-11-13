//
//  UserModel.m
//  PiggyBank
//
//  Created by Nagaraju on 29/01/1940 Saka.
//  Copyright © 1940 Saka Nagaraju. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.accounts forKey:@"accounts"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.mobileNumber forKey:@"mobileNumber"];
    [encoder encodeObject:self.transactionPin forKey:@"transactionPin"];
    [encoder encodeObject:self.loginPin forKey:@"loginPin"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _accounts = [decoder decodeObjectForKey:@"accounts"];
        _name = [decoder decodeObjectForKey:@"name"];
        _mobileNumber = [decoder decodeObjectForKey:@"mobileNumber"];
        _transactionPin = [decoder decodeObjectForKey:@"transactionPin"];
        _loginPin = [decoder decodeObjectForKey:@"loginPin"];
    }
    return self;
}

@end
