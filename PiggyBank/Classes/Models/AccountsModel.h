//
//  AccountsModel.h
//  PiggyBank
//
//  Created by Nagaraju on 29/01/1940 Saka.
//  Copyright © 1940 Saka Nagaraju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChildModel.h"
#import "ParentModel.h"

@interface AccountsModel : NSObject

@property (nonatomic, strong) ChildModel *child;
@property (nonatomic, strong) ParentModel *parent;

@end
