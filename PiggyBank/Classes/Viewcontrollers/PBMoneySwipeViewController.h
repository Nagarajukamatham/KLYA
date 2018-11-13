//
//  PBMoneySwipeViewController.h
//  PiggyBank
//
//  Created by Nagaraju on 22/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBBaseViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface PBMoneySwipeViewController : PBBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *animateUpImag;
@property (weak, nonatomic) IBOutlet UILabel *totalSwipedAmount;
@property (weak, nonatomic) IBOutlet UILabel *amountToswipe;
@property (weak, nonatomic) IBOutlet UILabel *errorLbl;
@property (weak, nonatomic) IBOutlet UIView *arrowView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (nonatomic,retain) NSString *transferedAmount;
@property (nonatomic,retain) CBPeripheral *selectedPiggy;
@property (nonatomic,retain) CBCharacteristic *writeCharacteristic;
@end
