//
//  PiggyModel.m
//  PiggyBank
//
//  Created by Nagaraju on 29/01/1940 Saka.
//  Copyright © 1940 Saka Nagaraju. All rights reserved.
//

#import "PiggyModel.h"

@implementation PiggyModel

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.deviceId forKey:@"deviceId"];
    [encoder encodeObject:self.deviceName forKey:@"deviceName"];
    [encoder encodeObject:self.goalAmount forKey:@"goalAmount"];
    [encoder encodeBool:self.goalCreated forKey:@"goalCreated"];
    [encoder encodeObject:self.goalCreatedDate forKey:@"goalCreatedDate"];
    
    [encoder encodeObject:self.goalDate forKey:@"goalDate"];
    [encoder encodeObject:self.goalName forKey:@"goalName"];
    [encoder encodeObject:self.goalStatus forKey:@"goalStatus"];
    [encoder encodeBool:self.piggyAttached forKey:@"piggyAttached"];
    [encoder encodeObject:self.piggyLastConnectedDateAndTime forKey:@"piggyLastConnectedDateAndTime"];
    [encoder encodeObject:self.piggyName forKey:@"piggyName"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _deviceId = [decoder decodeObjectForKey:@"deviceId"];
        _deviceName = [decoder decodeObjectForKey:@"deviceName"];
        _goalAmount = [decoder decodeObjectForKey:@"goalAmount"];
        _goalCreated = [decoder decodeBoolForKey:@"goalCreated"];
        _goalCreatedDate = [decoder decodeObjectForKey:@"goalCreatedDate"];
        
        _goalDate = [decoder decodeObjectForKey:@"goalDate"];
        _goalName = [decoder decodeObjectForKey:@"goalName"];
        _goalStatus = [decoder decodeObjectForKey:@"goalStatus"];
        _piggyAttached = [decoder decodeBoolForKey:@"piggyAttached"];
        _piggyLastConnectedDateAndTime = [decoder decodeObjectForKey:@"piggyLastConnectedDateAndTime"];
        _piggyName = [decoder decodeObjectForKey:@"piggyName"];
    }
    return self;
}

@end
