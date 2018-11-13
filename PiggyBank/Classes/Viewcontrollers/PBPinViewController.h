//
//  PBPinViewController.h
//  PiggyBank
//
//  Created by Nagaraju on 17/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBBaseViewController.h"
#import "PinKeyboard.h"
#import "DAInputView.h"
#import "BLEManager.h"

@interface PBPinViewController : PBBaseViewController<BLESerialDelegate>
@property (strong, nonatomic) IBOutlet DAInputView *inputView;
@property (strong, nonatomic) IBOutlet PinKeyboard *pinKeyboard;
@property (strong, nonatomic) BLEManager *bleManager;
@end
