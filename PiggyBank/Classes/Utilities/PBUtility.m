//
//  PBUtility.m
//  PiggyBank
//
//  Created by Nagaraju on 17/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBUtility.h"
#import "PBConstants.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "UserModel.h"
#import "ChildModel.h"
#import "ParentModel.h"
#import "AccountsModel.h"
#import "PiggyModel.h"

@implementation PBUtility

+(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
+(NSString *)getRandomPINString:(NSInteger)length
{
    NSMutableString *returnString = [NSMutableString stringWithCapacity:length];
    
    NSString *numbers = @"0123456789";
    
    // First number cannot be 0
    [returnString appendFormat:@"%C", [numbers characterAtIndex:(arc4random() % ([numbers length]-1))+1]];
    
    for (int i = 1; i < length; i++)
    {
        [returnString appendFormat:@"%C", [numbers characterAtIndex:arc4random() % [numbers length]]];
    }
    
    return returnString;
}

+(NSString *)spaceBetweenAcNo:(NSString*)acNoString{
    acNoString = [NSString stringWithFormat:@"%@",acNoString];
    NSMutableString *mChaildAcNum = [NSMutableString stringWithString:acNoString];
    // NSLog(@"not catch ----->>> %@",mChaildAcNum);
    [mChaildAcNum insertString:@" " atIndex:4];
    [mChaildAcNum insertString:@" " atIndex:9];
    [mChaildAcNum insertString:@" " atIndex:14];
    
    return mChaildAcNum;
}

+(NSString *)getRandomAlphabetString:(NSInteger)length
{
    NSMutableString *returnString = [NSMutableString stringWithCapacity:length];
    
    NSString *numbers = @"abcdefghijklmnopqrstuvwxyz";
    
    // First number cannot be 0
    [returnString appendFormat:@"%C", [numbers characterAtIndex:(arc4random() % ([numbers length]-1))+1]];
    
    for (int i = 1; i < length; i++)
    {
        [returnString appendFormat:@"%C", [numbers characterAtIndex:arc4random() % [numbers length]]];
    }
    
    return returnString;
}

+(NSString *)dateChangeFormate:(NSString*)fromFormate fromDateStr:(NSString*)dateStr toFormate:(NSString*)toFormate{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:fromFormate];
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:toFormate];
    dateStr = [dateFormat stringFromDate:date];
    //NSLog(@"dateStr --->>> %@",dateStr);
    return dateStr;
}

+(CGFloat)getKeyboardHeight
{
    // Do something
    
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
        return NBKEYBOARDHEIGHT_PORTRAIT_IPHONE_5;
    }
    else if (IS_IPHONE_6){
       return NBKEYBOARDHEIGHT_PORTRAIT_IPHONE_6;
    }
    else if(IS_IPHONE_6P || IS_IPHONE_X){
        return NBKEYBOARDHEIGHT_PORTRAIT_IPHONE_6P;
    }
    else if(IS_IPAD_PRO_1024 || IS_IPAD_PRO_1112){
        return NBKEYBOARDHEIGHT_PORTRAIT_IPAD;
    }
    else if(IS_IPAD_PRO_1366){
        return NBKEYBOARDHEIGHT_PORTRAIT_IPAD;
    }
    else{
        if (IS_IPAD) {
            
            return KEYBOARDHEIGHT_PORTRAIT_IPAD;
        }
        else{
            
            return KEYBOARDHEIGHT_PORTRAIT_IPHONE_6;
        }
    }
}
+(void)showAlertWithMessage:(NSString*)msgStr title:(NSString*)title;
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:msgStr
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    [alert addAction:yesButton];
    
    UIViewController *viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if ( viewController.presentedViewController && !viewController.presentedViewController.isBeingDismissed ) {
        viewController = viewController.presentedViewController;
    }
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint
                                      constraintWithItem:alert.view
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                      toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                      multiplier:1
                                      constant:viewController.view.frame.size.height*2.0f];
    
    [alert.view addConstraint:constraint];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color{
    
    // begin a new image context, to draw our colored image onto with the right scale
    UIGraphicsBeginImageContextWithOptions(source.size, NO, [UIScreen mainScreen].scale);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, source.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

+(CGFloat)getGoalViewX{
    CGFloat padding=0.0;
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
        NSLog(@"IS_IPHONE_5");
        padding=30.3;
    }
    else if (IS_IPHONE_6){
        NSLog(@"IS_IPHONE_6");
        padding=36;
    }
    else if(IS_IPHONE_6P){
        NSLog(@"IS_IPHONE_6P");
        padding=39.7;
    }
    else if (IS_IPHONE_X){
        NSLog(@"IS_IPHONE_X");
        padding=36;
    }
    else if (IS_IPAD) {
        NSLog(@"IS_IPAD");
        padding=30.4;
    }
    return padding;
}

+(NSMutableAttributedString*)AttributtedStr_Pname:(NSString*)pname desc:(NSString*)str1{
    NSString *fullText = [NSString stringWithFormat:@"%@ %@",pname,str1];
    
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: [UIColor blackColor],
                              NSFontAttributeName: [UIFont systemFontOfSize:14]
                              };
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:fullText
                                           attributes:attribs];
    UIColor *gColor = [PBUtility colorFromHexString:APP_COLOR];
    NSRange greenTextRange = [fullText rangeOfString:pname];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:gColor,
                                    NSFontAttributeName: [UIFont boldSystemFontOfSize:16]
                                    }
                            range:greenTextRange];
    
    return attributedText;
}

+(NSString *)getDateTimeWithFormat:(NSString*)dateFormat{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+(NSString*)amountWithRupee:(NSString*)amount{
   // NSString *rupee=@"\u20B9";
   // NSString *Euro = @"\u20AC";
    // Here adding decimal point to amount
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    NSString *theString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[amount doubleValue]]];
   // theString =[NSString stringWithFormat:@"%.2f",[theString floatValue]];
    
    NSString *s=[NSString stringWithFormat:@"%@ %@",theString,Euro];
    return s;
}
+(NSString*)amountWithDollar:(NSString*)amount{
    NSString *s=[NSString stringWithFormat:@"$ %@",amount];
    return s;
}

+(NSString*)removeWhiteNSpecialCharacters:(NSString*)rawString{
    NSCharacterSet *allowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789,."] invertedSet];
    return [[rawString componentsSeparatedByCharactersInSet:allowedChars] componentsJoinedByString:@""];
}

+(NSString *)getMacAddress
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    return @"Unknown";
}
+(NSString*)amountWithEuro:(NSString*)amount{
    //NSString *Euro = @"\u20AC";
    
//    NSString *amt = [NSString stringWithFormat:@"%.2f",[amount doubleValue]];
//    NSString *s=[NSString stringWithFormat:@"%@ %@",Euro,amt];
  // return s;
    amount =[NSString stringWithFormat:@"%@",amount];
    if (![amount containsString:@"."]) {
        amount =[NSString stringWithFormat:@"%.2f",[amount floatValue]];
    }
    
    NSArray *split =[amount componentsSeparatedByString:@"."];
    amount = [split objectAtIndex:0];
    if (amount.length==0) {
        amount=@"0";
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2]; //two deimal spaces
    formatter.locale = [NSLocale currentLocale];// this ensures the right separator behavior
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = YES;
    [formatter setGroupingSeparator:@"."];
    formatter.minimumFractionDigits = 2;
    [formatter setDecimalSeparator:@","];
    NSDecimalNumber *decimalNumber = (NSDecimalNumber *) [formatter numberFromString:amount];
    NSNumberFormatter *formatter1 = [[NSNumberFormatter alloc] init];
    [formatter1 setMaximumFractionDigits:2]; //two deimal spaces
    formatter1.locale = [NSLocale currentLocale];// this ensures the right separator behavior
    formatter1.numberStyle = NSNumberFormatterDecimalStyle;
    formatter1.usesGroupingSeparator = YES;
    [formatter1 setGroupingSeparator:@"."];
    
    NSString *result =[NSString stringWithString:[formatter1 stringFromNumber:decimalNumber]];
    result = [NSString stringWithFormat:@"%@ %@,%@",Euro,result,[split objectAtIndex:1]];
    return result;
    
}
//+(NSString*)toRupeeString:(NSString*)rawString{
//    // $ 15.321,48 ------->>> 15321.48
//    NSCharacterSet *allowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789,"] invertedSet];
//    NSString *dotRemovedStr=[[rawString componentsSeparatedByCharactersInSet:allowedChars] componentsJoinedByString:@""];
//
//    NSString *replacedDot = [dotRemovedStr
//                             stringByReplacingOccurrencesOfString:@"," withString:@"."];
//
//    return replacedDot;
//}

+(NSString*)toRupeeString:(NSString*)rawString{
    // $ 15,321.48 ------->>> 15,321.48
    NSCharacterSet *allowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *dotRemovedStr=[[rawString componentsSeparatedByCharactersInSet:allowedChars] componentsJoinedByString:@""];
    
    return dotRemovedStr;
}

+ (NSString *)formattedStringWithString:(NSString *)string
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2]; //two deimal spaces
    formatter.locale = [NSLocale currentLocale];// this ensures the right separator behavior
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.generatesDecimalNumbers = YES;
    formatter.usesGroupingSeparator = YES;
    [formatter setGroupingSeparator:@"."];
    formatter.minimumFractionDigits = 2;
    [formatter setDecimalSeparator:@","];
    NSDecimalNumber *decimalNumber = (NSDecimalNumber *) [formatter numberFromString:string];
    NSNumberFormatter *formatter1 = [[NSNumberFormatter alloc] init];
    [formatter1 setMaximumFractionDigits:2]; //two deimal spaces
    formatter1.locale = [NSLocale currentLocale];// this ensures the right separator behavior
    formatter1.numberStyle = NSNumberFormatterDecimalStyle;
    formatter1.usesGroupingSeparator = YES;
    [formatter1 setGroupingSeparator:@"."];
    [formatter1 setDecimalSeparator:@","];
    formatter1.minimumFractionDigits = 2;
    
    
    NSString *result =[NSString stringWithString:[formatter1 stringFromNumber:decimalNumber]];
    
    return [self amountWithEuro:result];
}

+ (NSString *)formattedStringWithDecimal:(NSDecimalNumber *)decimalNumber
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2]; //two deimal spaces
    formatter.locale = [NSLocale currentLocale];// this ensures the right separator behavior
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = YES;
    [formatter setGroupingSeparator:@"."];
    [formatter setDecimalSeparator:@","];
    formatter.minimumFractionDigits = 2;
    
    
    NSString *result =[NSString stringWithString:[formatter stringFromNumber:decimalNumber]];
    
    return result;
}

+ (NSDecimalNumber *)formattedDecimalWithString:(NSString *)string
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2]; //two deimal spaces
    formatter.locale = [NSLocale currentLocale];// this ensures the right separator behavior
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.generatesDecimalNumbers = YES;
    formatter.usesGroupingSeparator = YES;
    [formatter setGroupingSeparator:@"."];
    formatter.minimumFractionDigits = 2;
    [formatter setDecimalSeparator:@","];
    
    NSDecimalNumber *decimalNumber = (NSDecimalNumber *) [formatter numberFromString:string];
    
    return decimalNumber;
}

+(NSDictionary*)transferPayload:(UserModel*)user amount:(double)amount desc:(NSString*)description{

    NSString *childBalancePath =[NSString stringWithFormat:@"accounts/%@/balance",user.accounts.child.accountId];
    NSString *goalStatuPath=[NSString stringWithFormat:@"accounts/%@/piggyDetails/goalStatus",user.accounts.child.accountId];
    NSString *mainBalancePath =[NSString stringWithFormat:@"accounts/%@/balance",user.accounts.parent.accountId];
    
    NSString *transactionId_rand = [NSString stringWithFormat:@"tr%@%@_%@",[self getRandomAlphabetString:4],[self getRandomPINString:5],[self getRandomPINString:9]];
    NSDictionary *transactions = @{
                                   @"amount":[NSNumber numberWithDouble:amount],
                                   @"description":description,
                                   @"transactionId":transactionId_rand,
                                   @"dateAndTime":[self getDateTimeWithFormat:@"dd/MM/yyyy HH:mm"],
                                   @"dateAndTimeAsNumber":[self getDateTimeWithFormat:@"yyyyMMddHHmm"],
                                   @"fromAccountId":user.accounts.parent.accountId,
                                   @"fromAccountName":user.name,
                                   @"fromAccountNumber":user.accounts.parent.accountNumber,
                                   @"isUpdatedOnPiggy":[NSNumber numberWithBool:YES],
                                   @"toAccountId":user.accounts.child.accountId,
                                   @"toAccountName":user.accounts.child.piggyDetails.piggyName,
                                   @"toAccountNumber":user.accounts.child.accountNumber,
                                   };
    NSString *transcationIdDict =[NSString stringWithFormat:@"transactions/%@",transactionId_rand];
    double childBal = user.accounts.child.balance + amount;
    double mainBal = user.accounts.parent.balance - amount;
    NSDictionary *payload = @{
                              childBalancePath:[NSNumber numberWithDouble:childBal],
                              goalStatuPath:@"50",
                              mainBalancePath:[NSNumber numberWithDouble:mainBal],
                              transcationIdDict:transactions
                              };
    NSLog(@"tarnsfer payload ------>>>> %@",payload);
    return payload;
}

+(NSMutableArray*)getDenominations:(NSString*)transferedAmt{
    
//    NSInteger note500, note200, note100, note50, note20, note10, note5, note2, note1;
//    note500 = note200 = note100 = note50 = note20 = note10 = note5 = note2 = note1 = 0;
//    NSInteger amount = [transferedAmt integerValue];
//    NSMutableArray *tempNotes = [[NSMutableArray alloc] init];
//
//    if(amount > 500)
//    {
//        note500 = amount/500;
//        amount -= note500 * 500;
//        [tempNotes addObject:@{@"image" : @"500euro",@"amount":@500}];
//    }
//
//    if(amount > 200)
//    {
//        note200 = amount/200;
//        amount -= note200 * 200;
//        [tempNotes addObject:@{@"image" : @"200euro",@"amount":@200}];
//    }
//
//    if(amount > 100)
//    {
//        note100 = amount/100;
//        amount -= note100 * 100;
//        [tempNotes addObject:@{@"image" : @"100euro",@"amount":@100}];
//    }
//    if(amount > 50)
//    {
//        note50 = amount/50;
//        amount -= note50 * 50;
//        [tempNotes addObject:@{@"image" : @"50euro",@"amount":@50}];
//    }
//    if(amount > 20)
//    {
//        note20 = amount/20;
//        amount -= note20 * 20;
//        [tempNotes addObject:@{@"image" : @"20euro",@"amount":@20}];
//    }
//    if(amount > 10)
//    {
//        note10 = amount/10;
//        amount -= note10 * 10;
//        [tempNotes addObject:@{@"image" : @"10euro",@"amount":@10}];
//    }
//    if(amount > 5)
//    {
//        note5 = amount/5;
//        amount -= note5 * 5;
//        [tempNotes addObject:@{@"image" : @"5euro",@"amount":@5}];
//    }
//    if(amount > 2)
//    {
//        note2 = amount /2;
//        amount -= note2 * 2;
//        [tempNotes addObject:@{@"image" : @"2euro",@"amount":@2}];
//    }
//    if(amount >= 1)
//    {
//        note1 = amount;
//        [tempNotes addObject:@{@"image" : @"1euro",@"amount":@1}];
//    }
//
//    NSLog(@"temp notes ----->>>> %@",tempNotes);
//    if (tempNotes.count == 2) {
//        for (int i=0;i<tempNotes.count;i++) {
//            if (tempNotes.count < 4) {
//                NSDictionary *firstObj = [tempNotes objectAtIndex:i];
//                NSInteger amt = [[firstObj objectForKey:@"amount"] integerValue];
//                if (amt==500) {
//                    if (![tempNotes containsObject:@{@"image" : @"200euro",@"amount":@200}]) {
//                        [tempNotes addObject:@{@"image" : @"200euro",@"amount":@200}];
//                    }
//                }else if (amt==200){
//                    if (![tempNotes containsObject:@{@"image" : @"100euro",@"amount":@100}]) {
//                        [tempNotes addObject:@{@"image" : @"100euro",@"amount":@100}];
//                    }
//                }else if (amt==100){
//                    if (![tempNotes containsObject:@{@"image" : @"50euro",@"amount":@50}]) {
//                        [tempNotes addObject:@{@"image" : @"50euro",@"amount":@50}];
//                    }
//                }else if (amt==50){
//                    if (![tempNotes containsObject:@{@"image" : @"20euro",@"amount":@20}]) {
//                        [tempNotes addObject:@{@"image" : @"20euro",@"amount":@20}];
//                    }
//                }else if (amt==20){
//                    if (![tempNotes containsObject:@{@"image" : @"10euro",@"amount":@10}]) {
//                        [tempNotes addObject:@{@"image" : @"10euro",@"amount":@10}];
//                    }
//                }else if (amt==10){
//                    if (![tempNotes containsObject:@{@"image" : @"5euro",@"amount":@5}]) {
//                        [tempNotes addObject:@{@"image" : @"5euro",@"amount":@5}];
//                    }
//                }else if (amt==5){
//                    if (![tempNotes containsObject:@{@"image" : @"2euro",@"amount":@2}]) {
//                        [tempNotes addObject:@{@"image" : @"2euro",@"amount":@2}];
//                    }
//                }
//                else if (amt==2){
//                    if (![tempNotes containsObject:@{@"image" : @"1euro",@"amount":@1}]) {
//                        [tempNotes addObject:@{@"image" : @"1euro",@"amount":@1}];
//                    }
//                }
//            }
//        }
//    }
//    else if (tempNotes.count == 1) {
//        for (int i=0;i<tempNotes.count;i++) {
//            if (tempNotes.count < 4) {
//                NSDictionary *firstObj = [tempNotes objectAtIndex:i];
//                NSInteger amt = [[firstObj objectForKey:@"amount"] integerValue];
//                if (amt==500) {
//                    if (![tempNotes containsObject:@{@"image" : @"200euro",@"amount":@200}]) {
//                        [tempNotes addObject:@{@"image" : @"200euro",@"amount":@200}];
//                    }
//                    if (![tempNotes containsObject:@{@"image" : @"100euro",@"amount":@100}]) {
//                        [tempNotes addObject:@{@"image" : @"100euro",@"amount":@100}];
//                    }
//                }else if (amt==200){
//                    if (![tempNotes containsObject:@{@"image" : @"100euro",@"amount":@100}]) {
//                        [tempNotes addObject:@{@"image" : @"100euro",@"amount":@100}];
//                    }
//                    if (![tempNotes containsObject:@{@"image" : @"50euro",@"amount":@50}]) {
//                        [tempNotes addObject:@{@"image" : @"50euro",@"amount":@50}];
//                    }
//                }else if (amt==100){
//                    if (![tempNotes containsObject:@{@"image" : @"50euro",@"amount":@50}]) {
//                        [tempNotes addObject:@{@"image" : @"50euro",@"amount":@50}];
//                    }
//                    if (![tempNotes containsObject:@{@"image" : @"20euro",@"amount":@20}]) {
//                        [tempNotes addObject:@{@"image" : @"20euro",@"amount":@20}];
//                    }
//                }else if (amt==50){
//                    if (![tempNotes containsObject:@{@"image" : @"20euro",@"amount":@20}]) {
//                        [tempNotes addObject:@{@"image" : @"20euro",@"amount":@20}];
//                    }
//                    if (![tempNotes containsObject:@{@"image" : @"10euro",@"amount":@10}]) {
//                        [tempNotes addObject:@{@"image" : @"10euro",@"amount":@10}];
//                    }
//                }else if (amt==20){
//                    if (![tempNotes containsObject:@{@"image" : @"10euro",@"amount":@10}]) {
//                        [tempNotes addObject:@{@"image" : @"10euro",@"amount":@10}];
//                    }
//                    if (![tempNotes containsObject:@{@"image" : @"5euro",@"amount":@5}]) {
//                        [tempNotes addObject:@{@"image" : @"5euro",@"amount":@5}];
//                    }
//                }else if (amt==10){
//                    if (![tempNotes containsObject:@{@"image" : @"5euro",@"amount":@5}]) {
//                        [tempNotes addObject:@{@"image" : @"5euro",@"amount":@5}];
//                    }
//                    if (![tempNotes containsObject:@{@"image" : @"2euro",@"amount":@2}]) {
//                        [tempNotes addObject:@{@"image" : @"2euro",@"amount":@2}];
//                    }
//                }else if (amt==5){
//                    if (![tempNotes containsObject:@{@"image" : @"2euro",@"amount":@2}]) {
//                        [tempNotes addObject:@{@"image" : @"2euro",@"amount":@2}];
//                    }
//                    if (![tempNotes containsObject:@{@"image" : @"1euro",@"amount":@1}]) {
//                        [tempNotes addObject:@{@"image" : @"1euro",@"amount":@1}];
//                    }
//                }
//                else if (amt==2){
//                        if (![tempNotes containsObject:@{@"image" : @"1euro",@"amount":@1}]) {
//                            [tempNotes addObject:@{@"image" : @"1euro",@"amount":@1}];
//                        }
//                }
//        }
//    }
//    }
//
//    NSSortDescriptor *sortDescriptor;
//    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"amount" ascending:YES];
//    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//    [tempNotes sortUsingDescriptors:sortDescriptors];
  //  NSLog(@"ascending notes ----->>> %@",tempNotes);
  
    NSMutableArray *tempNotes = [[NSMutableArray alloc] init];
    NSArray *onesArr =@[
                        @{@"image" : @"1euro",@"amount":@1},
                        @{@"image" : @"2euro",@"amount":@2},
                        @{@"image" : @"5euro",@"amount":@5}
                        ];
    NSArray *tensArr =@[
                        @{@"image" : @"10euro",@"amount":@10},
                        @{@"image" : @"20euro",@"amount":@20},
                        @{@"image" : @"50euro",@"amount":@50}
                        ];
    if (transferedAmt.length == 1) {
        NSInteger ta = [transferedAmt integerValue];
        if (ta==1) {
            [tempNotes addObject:@{@"image" : @"1euro",@"amount":@1}];
        }else if (ta == 2 || ta == 3 || ta == 4) {
            [tempNotes addObject:@{@"image" : @"1euro",@"amount":@1}];
            [tempNotes addObject:@{@"image" : @"2euro",@"amount":@2}];
        }else{
            [tempNotes addObjectsFromArray:onesArr];
        }
    }
    else if (transferedAmt.length == 2) {  // 11 12 13
        NSInteger onces = [[transferedAmt substringWithRange:NSMakeRange(1, 1)] integerValue];
        if (onces == 1) {
            [tempNotes addObject:@{@"image" : @"1euro",@"amount":@1}];
            [tempNotes addObject:@{@"image" : @"5euro",@"amount":@5}];
        }else if (onces == 2 || onces == 3 || onces == 4) {
            [tempNotes addObject:@{@"image" : @"1euro",@"amount":@1}];
            [tempNotes addObject:@{@"image" : @"2euro",@"amount":@2}];
        }
        else if(onces != 0 && onces >= 5 ){
            [tempNotes addObjectsFromArray:onesArr];
        }
        
        if ([transferedAmt integerValue] < 20 ) {
            if (![tempNotes containsObject:@{@"image" : @"5euro",@"amount":@5}]) {
                [tempNotes addObject:@{@"image" : @"5euro",@"amount":@5}];
            }
            [tempNotes addObject:@{@"image" : @"10euro",@"amount":@10}];
        }else if ([transferedAmt integerValue] < 50){
            if (![tempNotes containsObject:@{@"image" : @"5euro",@"amount":@5}] && tempNotes.count <=2) {
                [tempNotes addObject:@{@"image" : @"5euro",@"amount":@5}];
            }
            [tempNotes addObject:@{@"image" : @"10euro",@"amount":@10}];
            [tempNotes addObject:@{@"image" : @"20euro",@"amount":@20}];
        }else if ([transferedAmt integerValue] < 100){
            [tempNotes addObjectsFromArray:tensArr];
        }
    }
    else if (transferedAmt.length == 3){ // 100 123  456  789
        
        NSInteger onces = [[transferedAmt substringWithRange:NSMakeRange(2, 1)] integerValue];
        if( onces == 1){
            [tempNotes addObject:@{@"image" : @"1euro",@"amount":@1}];
        }else if (onces == 2 || onces == 3 || onces == 4) {
            [tempNotes addObject:@{@"image" : @"1euro",@"amount":@1}];
            [tempNotes addObject:@{@"image" : @"2euro",@"amount":@2}];
        }
        else if(onces != 0 && onces >= 5 ){
            [tempNotes addObjectsFromArray:onesArr];
        }
        
        NSInteger tens = [[transferedAmt substringWithRange:NSMakeRange(1, 1)] integerValue];
        if (tens==1) {
            if (![tempNotes containsObject:@{@"image" : @"5euro",@"amount":@5}] && tempNotes.count <=2) {
                [tempNotes addObject:@{@"image" : @"5euro",@"amount":@5}];
            }
            [tempNotes addObject:@{@"image" : @"10euro",@"amount":@10}];
        }
        else if (tens == 2 || tens == 3 || tens == 4) {
            [tempNotes addObject:@{@"image" : @"10euro",@"amount":@10}];
            [tempNotes addObject:@{@"image" : @"20euro",@"amount":@20}];
        }
        else if(tens != 0 && tens >= 5){
            [tempNotes addObjectsFromArray:tensArr]; // 121
        }
        
        if ([transferedAmt integerValue] == 100) {
            [tempNotes addObjectsFromArray:tensArr];
        }
        else if ([transferedAmt integerValue] < 200 ) {
            [tempNotes addObject:@{@"image" : @"100euro",@"amount":@100}];
        }else if ([transferedAmt integerValue] < 500){
            if (![tempNotes containsObject:@{@"image" : @"50euro",@"amount":@50}] && tempNotes.count <=2) {
                [tempNotes addObject:@{@"image" : @"50euro",@"amount":@50}];
            }
            [tempNotes addObject:@{@"image" : @"100euro",@"amount":@100}];
            [tempNotes addObject:@{@"image" : @"200euro",@"amount":@200}];
        }else if ([transferedAmt integerValue] < 1000){
            [tempNotes addObject:@{@"image" : @"100euro",@"amount":@100}];
            [tempNotes addObject:@{@"image" : @"200euro",@"amount":@200}];
            [tempNotes addObject:@{@"image" : @"500euro",@"amount":@500}];
        }
    }
    
    else if (transferedAmt.length == 4){ // 1234  4565  7898
        
        NSInteger onces = [[transferedAmt substringWithRange:NSMakeRange(3, 1)] integerValue];
        if( onces == 1){
            [tempNotes addObject:@{@"image" : @"1euro",@"amount":@1}];
        }else if (onces == 2 || onces == 3 || onces == 4) {
            [tempNotes addObject:@{@"image" : @"1euro",@"amount":@1}];
            [tempNotes addObject:@{@"image" : @"2euro",@"amount":@2}];
        }
        else if (onces == 5) {
            [tempNotes addObject:@{@"image" : @"5euro",@"amount":@5}];
        }
        else if(onces != 0 && onces >= 5 ){
            [tempNotes addObjectsFromArray:onesArr];
        }
        NSInteger tens = [[transferedAmt substringWithRange:NSMakeRange(2, 1)] integerValue];
        if (tens==1) {
            [tempNotes addObject:@{@"image" : @"10euro",@"amount":@10}];
        }
        else if (tens == 2 || tens == 3 || tens == 4) {
            [tempNotes addObject:@{@"image" : @"10euro",@"amount":@10}];
            [tempNotes addObject:@{@"image" : @"20euro",@"amount":@20}];
        }
        else if(tens != 0 && tens >= 5){
            [tempNotes addObjectsFromArray:tensArr]; // 121
        }
        
        
        if ([transferedAmt integerValue] < 200 ) {
            [tempNotes addObject:@{@"image" : @"100euro",@"amount":@100}];
        }else if ([transferedAmt integerValue] < 500){
            if (![tempNotes containsObject:@{@"image" : @"50euro",@"amount":@50}] && tempNotes.count <=2) {
                [tempNotes addObject:@{@"image" : @"50euro",@"amount":@50}];
            }
            [tempNotes addObject:@{@"image" : @"100euro",@"amount":@100}];
            [tempNotes addObject:@{@"image" : @"200euro",@"amount":@200}];
        }else if ([transferedAmt integerValue] <= 9999){
            [tempNotes addObject:@{@"image" : @"100euro",@"amount":@100}];
            [tempNotes addObject:@{@"image" : @"200euro",@"amount":@200}];
            [tempNotes addObject:@{@"image" : @"500euro",@"amount":@500}];
        }
    }
    // NSLog(@"temp notes ----->>> %@",tempNotes);
    
    
    
    return tempNotes;
}

+(void)loginResponseSetToDefaults:(id)response{
    UserModel *userObj = [[UserModel alloc] init];
    userObj.loginPin = [response objectForKey:@"loginPin"];
    userObj.mobileNumber = [response objectForKey:@"mobileNumber"];
    userObj.name = [response objectForKey:@"name"];
    userObj.transactionPin = [response objectForKey:@"transactionPin"];
    
    ChildModel *childObj = [[ChildModel alloc] init];
    ParentModel *parentObj = [[ParentModel alloc] init];
    NSDictionary *accounts = [response objectForKey:@"accounts"];
    NSArray *values = [accounts allValues];
    for (int i=0; i<values.count; i++) {
        NSDictionary *dict = [values objectAtIndex:i];
        if ([[dict objectForKey:@"accountType"] isEqualToString:@"child"]) {
            childObj.accountId = [dict objectForKey:@"accountId"];
            childObj.accountName = [dict objectForKey:@"accountName"];
            childObj.accountNumber = [dict objectForKey:@"accountNumber"];
            childObj.accountType = [dict objectForKey:@"accountType"];
            childObj.balance = [[dict objectForKey:@"balance"] doubleValue];
            
            PiggyModel *piggy = [[PiggyModel alloc] init];
            NSDictionary *pDetails = [dict objectForKey:@"piggyDetails"];
            NSArray *values = [pDetails allKeys];
            
            // Piggy Details
            piggy.piggyAttached = [[pDetails objectForKey:@"piggyAttached"] boolValue];
            if (values.count > 2) {
                piggy.deviceId = [pDetails objectForKey:@"deviceId"];
                piggy.deviceName = [pDetails objectForKey:@"deviceName"];
                piggy.piggyLastConnectedDateAndTime = [pDetails objectForKey:@"piggyLastConnectedDateAndTime"];
                piggy.piggyName = [pDetails objectForKey:@"piggyName"];
            }
            
            
            //Set up Goal
            piggy.goalCreated = [[pDetails objectForKey:@"goalCreated"] boolValue];
            if (values.count > 6) {
                piggy.goalAmount = [pDetails objectForKey:@"goalAmount"];
                piggy.goalCreatedDate = [pDetails objectForKey:@"goalCreatedDate"];
                piggy.goalDate = [pDetails objectForKey:@"goalDate"];
                piggy.goalName = [pDetails objectForKey:@"goalName"];
                piggy.goalStatus = [pDetails objectForKey:@"goalStatus"];
            }

            childObj.piggyDetails = piggy;
        }
        else if ([[dict objectForKey:@"accountType"] isEqualToString:@"parent"]) {
            parentObj.accountId = [dict objectForKey:@"accountId"];
            parentObj.accountName = [dict objectForKey:@"accountName"];
            parentObj.accountNumber = [dict objectForKey:@"accountNumber"];
            parentObj.accountType = [dict objectForKey:@"accountType"];
            parentObj.balance = [[dict objectForKey:@"balance"] doubleValue];
        }
    }
    AccountsModel *acc = [[AccountsModel alloc] init];
    acc.child = childObj;
    acc.parent = parentObj;
    userObj.accounts = acc;
    
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userObj];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"loginResp"];
    [defaults synchronize];
}

@end
