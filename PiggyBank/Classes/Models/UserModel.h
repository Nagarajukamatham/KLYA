//
//  UserModel.h
//  PiggyBank
//
//  Created by Nagaraju on 29/01/1940 Saka.
//  Copyright © 1940 Saka Nagaraju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountsModel.h"

@interface UserModel : NSObject

@property (nonatomic, strong) NSString *loginPin;
@property (nonatomic, strong) NSString *mobileNumber;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *transactionPin;
@property (nonatomic, strong) AccountsModel *accounts;

@end
