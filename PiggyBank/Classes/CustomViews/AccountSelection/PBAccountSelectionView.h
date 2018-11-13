//
//  PBAccountSelectionView.h
//  PiggyBank
//
//  Created by Nagaraju on 21/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PBAccountSelectionViewDelegate;

@interface PBAccountSelectionView : UIView
@property UIView *accountSelectionView;
@property (nonatomic, weak) IBOutlet UIView *contianerView;
@property (nonatomic, weak) IBOutlet UITableView *accountsTableView;
@property (nonatomic, assign) id<PBAccountSelectionViewDelegate> accountSelectionDelegate;
@property (nonatomic, strong) NSArray *accountsArray;
@end

@protocol PBAccountSelectionViewDelegate <NSObject>

- (void)didSelectAccount:(id)selectedAccount withIndex:(NSInteger) index selectionView:(PBAccountSelectionView *)selectionView;

@end
