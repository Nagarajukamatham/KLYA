//
//  PBConstants.h
//  PiggyBank
//
//  Created by Nagaraju on 16/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBConstants : NSObject


#define Euro @"\u20AC"

#define serviceUUID @"FFE0"
#define characteristicUUID @"FFE1"
#define GLOBAL_SERIAL_PASS_SERVICE_UUID                    PUNCHTHROUGHDESIGN_128_UUID(@"FFE0")
#define GLOBAL_SERIAL_PASS_CHARACTERISTIC_UUID             PUNCHTHROUGHDESIGN_128_UUID(@"FFE1")
#define PUNCHTHROUGHDESIGN_128_UUID(uuid16) @"A495" uuid16 @"-C5B1-4B44-B512-1370F02D74DE"

#define APP_COLOR @"#B8D028"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
#define IS_IPAD_PRO_1366 (IS_IPAD && SCREEN_MAX_LENGTH == 1366.0)
#define IS_IPAD_PRO_1024 (IS_IPAD && SCREEN_MAX_LENGTH == 1024.0)
#define IS_IPAD_PRO_1112 (IS_IPAD && SCREEN_MAX_LENGTH == 1112.0)

#define NBKEYBOARDHEIGHT_PORTRAIT_IPHONE_4  320
#define NBKEYBOARDHEIGHT_PORTRAIT_IPHONE_5  340
#define NBKEYBOARDHEIGHT_PORTRAIT_IPHONE_6 350
#define NBKEYBOARDHEIGHT_PORTRAIT_IPHONE_6P 375
#define NBKEYBOARDHEIGHT_PORTRAIT_IPAD 435
#define NBKEYBOARDHEIGHT_Lansacpe_IPHONE_4 290
#define NBKEYBOARDHEIGHT_Lansacpe_IPHONE_5 305
#define NBKEYBOARDHEIGHT_Lansacpe_IPHONE_6 325
#define NBKEYBOARDHEIGHT_Lansacpe_IPHONE_6P 325
#define NBKEYBOARDHEIGHT_Lansacpe_IPHONE 325
#define NBKEYBOARDHEIGHT_Lansacpe_IPAD 435

#define KEYBOARDHEIGHT_PORTRAIT_IPAD 320
#define KEYBOARDHEIGHT_PORTRAIT_IPHONE_6 260

#define krupees @"Rupees"
#define kdollars @"Dollars"
#define keuros @"Euros"

#define REGEX_PIGGY_NAME_LIMIT @"^[a-zA-Z0-9 ]{3,10}$"//@"^.{1,12}$"
#define REGEX_USER_NAME_LIMIT @"^.{3,20}$"
#define REGEX_AMOUNT_LIMIT @"([1-9]|[1-8][0-9]|9[0-9]|[1-8][0-9]{2}|9[0-8][0-9]|99[0-9]|[1-8][0-9]{3}|9[0-8][0-9]{2}|99[0-8][0-9]|999[0-9])"//@"^.{1,9}$"
#define REGEX_PHONE_DEFAULT @"^[0-9]{10}$"
#define REGEX_PIN_LENGTH @"^[0-9]{4}$"
#define REGEX_UPI_LENGTH @"^[0-9]{6}$"
#define REGEX_DESCRIPTION_LIMIT @"^.{3,30}$"
#define REGEX_GOALNAME_LIMIT @"^.{3,7}$"

#define ERROR_MSG_USERNAME_LENGTH @"Please enter name with minimum 3 characters"
#define ERROR_MSG_PHONENO_LENGTH @"Please enter 10 digit mobile number"
#define ERROR_MSG_PIN_LENGTH @"Please enter 4 digit login Pin"
#define ERROR_MSG_CONFIRMPIN_MATCH @"Confirmation pin is not matched with login pin"
#define ERROR_MSG_UPI_LENGTH @"Please enter 6 digit transaction pin"
#define ERROR_MSG_CONFIRMUPI_MATCH @"Confirmation transaction pin is not matched with transaction Pin"

#define ERROR_MSG_PIGGYNAME_LENGTH @"Please enter name minimum 3 characters & maximum 10 characters and also no special characters except space"
#define ERROR_MSG_AMOUNT @"Amount shouldn't be more than 9999 & Amount shouldn't be 0"
#define ERROR_MSG_DESCRIPTION @"Please enter description with minimum 3 characters"
#define ERROR_MSG_GOALAMOUNT @"Goal amount shouldn't be more than 9999"
#define ERROR_MSG_GOALNAME @"Please enter goal name minimum 3 characters & maximum 7 characters"

#define kmain_url_prefix @"https://hdchatpay.firebaseio.com/PiggyBank/NBPiggybankDemo/users/"
#define kmain_url_postfix @"/.json"
@end
