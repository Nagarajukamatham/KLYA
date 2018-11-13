//
//  PBAccountCellTableViewCell.h
//  PiggyBank
//
//  Created by Nagaraju on 21/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBAccountCellTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *accountNumber;
@property (nonatomic, weak) IBOutlet UILabel *balance;
@end
