//
//  TextFieldValidator.h
//  NBKeyboardExtMock
//
//  Created by Sujan Reddy on 23/02/18.
//  Copyright © 2018 Innovation Makers. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Image name for showing error on textfield.
 */
#define IconImageName @"error.png"

/**
 Background color of message popup.
 */
// ------------- light yellow ---------------
//#define ColorPopUpBg [UIColor colorWithRed:0.89 green:0.83 blue:0.65 alpha:1.0]

// ------------- thick yellow ---------------
#define ColorPopUpBg [UIColor blackColor]//[UIColor colorWithRed:0.73 green:0.57 blue:0.13 alpha:1.0]

#define alertErrorColor  [UIColor redColor] // [UIColor colorWithRed:.64 green:.33 blue:.41 alpha:1.0]
/**
 Font color of the message.
 */
#define ColorFont [UIColor whiteColor]

/**
 Font size of the message.
 */
#define FontSize 10

/**
 Font style name of the message.
 */
#define FontName @"Helvetica-Bold"

/**
 Padding in pixels for the popup.
 */
#define PaddingInErrorPopUp 5

/**
 Default message for validating length, you can also assign message separately using method 'updateLengthValidationMsg:' for textfields.
 */
#define MsgValidateLength @"Required field"

@interface TextFieldValidator : UITextField<UITextFieldDelegate>{
    
}

@property (nonatomic,assign) BOOL isMandatory;   /**< Default is YES*/

@property (nonatomic,retain) IBOutlet UIView *presentInView;    /**< Assign view on which you want to show popup and it would be good if you provide controller's view*/

@property (nonatomic,retain) UIColor *popUpColor;   /**< Assign popup background color, you can also assign default popup color from macro "ColorPopUpBg" at the top*/

@property (nonatomic,assign) BOOL validateOnCharacterChanged; /**< Default is YES, Use it whether you want to validate text on character change or not.*/

@property (nonatomic,assign) BOOL validateOnResign; /**< Default is YES, Use it whether you want to validate text on resign or not.*/

/**
 Use to add regex for validating textfield text, you need to specify all your regex in queue that you want to validate and their messages respectively that will show when any regex validation will fail.
 @param strRegx Regex string
 @param msg Message string to be displayed when given regex will fail.
 */
-(void)addRegx:(NSString *)strRegx withMsg:(NSString *)msg;

/**
 By deafult the message will be shown which is given in the macro "MsgValidateLength", but you can change message for each textfield as well.
 @param msg Message string to be displayed when length validation will fail.
 */
-(void)updateLengthValidationMsg:(NSString *)msg;

/**
 Use to add validation for validating confirm password
 @param txtPassword Hold reference of password textfield from which they will check text equality.
 */
-(void)addConfirmValidationTo:(TextFieldValidator *)txtPassword withMsg:(NSString *)msg;

/**
 Use to perform validation
 @return Bool It will return YES if all provided regex validation will pass else return NO
 
 Eg: If you want to apply validation on all fields simultaneously then refer below code which will be make it easy to handle validations
 if([txtField1 validate] & [txtField2 validate]){
 // Success operation
 }
 */
-(BOOL)validate;

/**
 Use to dismiss error popup.
 */
-(void)dismissPopup;

@end
