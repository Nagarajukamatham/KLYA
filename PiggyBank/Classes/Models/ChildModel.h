//
//  ChildModel.h
//  PiggyBank
//
//  Created by Nagaraju on 29/01/1940 Saka.
//  Copyright © 1940 Saka Nagaraju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PiggyModel.h"

@interface ChildModel : NSObject

@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, strong) NSString *accountNumber;
@property (nonatomic, strong) NSString *accountType;
@property (nonatomic, assign) double balance;
@property (nonatomic, strong) PiggyModel *piggyDetails;

@end
