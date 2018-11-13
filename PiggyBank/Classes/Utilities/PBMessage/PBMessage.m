//
//  PBMessage.m
//  PiggyBank
//
//  Created by Nagaraju on 27/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBMessage.h"
#import "PBUtility.h"
@implementation PBMessage

+(NSString*)passAccountNumber:(NSString*)number piggyName:(NSString*)pname{
    NSString *s=[NSString stringWithFormat:@"(%@,%@@%@)",number,pname,[PBUtility getDateTimeWithFormat:@"dd/MM/yy HH:mm"]];
    return s;
}

+(NSString*)passBalance:(NSString*)balance currencyName:(NSString*)cname{
    balance = [NSString stringWithFormat:@"%ld",(long)[balance integerValue]];
    NSLog(@"AMOUNT ----->>> %@",balance);
    cname = @"\u20AC";
    NSString *s=[NSString stringWithFormat:@"[%@,%@@%@]",balance,cname,[PBUtility getDateTimeWithFormat:@"dd/MM/yy HH:mm"]];
    return s;
}
+(NSString*)transferMoney:(NSString*)money{
    money = [NSString stringWithFormat:@"%ld",(long)[money integerValue]];
    NSLog(@"AMOUNT transfer ----->>> %@",money);
    NSString *s=[NSString stringWithFormat:@"{%@@%@}",money,[PBUtility getDateTimeWithFormat:@"dd/MM/yy HH:mm"]];
    return s;
}
+(NSString*)passGoal:(NSString*)goal amount:(NSString*)amount{
    amount = [NSString stringWithFormat:@"%ld",(long)[amount integerValue]];
    NSLog(@"AMOUNT ----->>> %@",amount);
    NSString *s=[NSString stringWithFormat:@"<%@,%@@%@>",goal,amount,[PBUtility getDateTimeWithFormat:@"dd/MM/yy HH:mm"]];
    
    return s;
}

+(NSString*)transferSpecialCharacter:(NSString*)character{
    NSString *s=[NSString stringWithFormat:@"%@",character];
    return s;
}



@end
