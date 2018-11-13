//
//  PBMessage.h
//  PiggyBank
//
//  Created by Nagaraju on 27/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBMessage : NSObject

+(NSString*)passAccountNumber:(NSString*)number piggyName:(NSString*)pname;
+(NSString*)passBalance:(NSString*)balance currencyName:(NSString*)cname;
+(NSString*)transferMoney:(NSString*)money;
+(NSString*)passGoal:(NSString*)goal amount:(NSString*)amount;
+(NSString*)transferSpecialCharacter:(NSString*)character;
@end
