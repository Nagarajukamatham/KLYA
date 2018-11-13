//
//  PBConfirmationViewController.h
//  PiggyBank
//
//  Created by Nagaraju on 21/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBBaseViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface PBConfirmationViewController : PBBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *piggyNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *linkAccountLbl;
@property (weak, nonatomic) IBOutlet UILabel *balanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *connectedKLYALbl;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) CBPeripheral *selectedToy;
@property (weak, nonatomic) CBCharacteristic *writeCharacteristic;
@property (weak, nonatomic) NSString *selectedAccountNumber;
@property (weak, nonatomic) NSString *enteredPiggyName;
@property (weak, nonatomic) NSString *toyManualName;
@end
