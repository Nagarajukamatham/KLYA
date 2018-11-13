//
//  PBSetupToyViewController.h
//  PiggyBank
//
//  Created by Nagaraju on 20/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBBaseViewController.h"
#import "PBAccountSelectionView.h"
#import "TextFieldValidator.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface PBSetupToyViewController : PBBaseViewController<UITextFieldDelegate>
@property (nonatomic, strong) PBAccountSelectionView *accountSelectionView;
@property (weak, nonatomic) IBOutlet UILabel *piggyToyName;
@property (weak, nonatomic) IBOutlet UIButton *accountSelectionBtn;
@property (weak, nonatomic) IBOutlet TextFieldValidator *nameTxt;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (weak, nonatomic) IBOutlet UILabel *selectedAccountLbl;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (weak, nonatomic) CBPeripheral *selectedToy;
@property (weak, nonatomic) CBCharacteristic *writeCharacteristic;
@property (weak, nonatomic) IBOutlet UIScrollView *myScroll;
@end
