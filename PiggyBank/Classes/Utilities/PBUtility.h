//
//  PBUtility.h
//  PiggyBank
//
//  Created by Nagaraju on 17/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserModel.h"
@protocol alertDelegate;

@interface PBUtility : NSObject

@property (nonatomic, assign) id<alertDelegate> alertdelegate;


+(UIColor *)colorFromHexString:(NSString *)hexString;
+(UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color;
+(void)showAlertWithMessage:(NSString*)msgStr title:(NSString*)title;
+(NSMutableAttributedString*)AttributtedStr_Pname:(NSString*)pname desc:(NSString*)str1;
+(NSString *)spaceBetweenAcNo:(NSString*)acNoString;
+(NSString *)getRandomPINString:(NSInteger)length;
+(NSString *)getRandomAlphabetString:(NSInteger)length;
+(CGFloat)getGoalViewX;
+(CGFloat)getKeyboardHeight;
+(NSString *)dateChangeFormate:(NSString*)fromFormate fromDateStr:(NSString*)dateStr toFormate:(NSString*)toFormate;
+(NSString*)getDateTimeWithFormat:(NSString*)dateFormat;

+(NSString*)amountWithRupee:(NSString*)amount;
+(NSString*)amountWithDollar:(NSString*)amount;
+(NSString*)amountWithEuro:(NSString*)amount;
+(NSString*)toRupeeString:(NSString*)rawString;

+(NSString*)removeWhiteNSpecialCharacters:(NSString*)rawString;
+(NSString *)getMacAddress;
+ (NSString *)formattedStringWithString:(NSString *)string;
+ (NSString *)formattedStringWithDecimal:(NSDecimalNumber *)decimalNumber;
+ (NSDecimalNumber *)formattedDecimalWithString:(NSString *)string;
+(NSDictionary*)transferPayload:(UserModel*)user amount:(double)amount desc:(NSString*)description;
+(NSMutableArray*)getDenominations:(NSString*)transferedAmt;
+(void)loginResponseSetToDefaults:(id)response;
@end


@protocol alertDelegate <NSObject>

@optional
-(void)alertViewOkbuttonClicked;
@end
