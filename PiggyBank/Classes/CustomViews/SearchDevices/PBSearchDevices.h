//
//  PBSearchDevices.h
//  PiggyBank
//
//  Created by Nagaraju on 02/05/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBSearchDevices : UICollectionViewFlowLayout

@property (assign, nonatomic) CGFloat scalingOffset; //default is 200; for offsets >= scalingOffset scale factor is minimumScaleFactor
@property (assign, nonatomic) CGFloat minimumScaleFactor; //default is 0.7
@property (assign, nonatomic) BOOL scaleItems; //default is YES

+ (PBSearchDevices *)layoutConfiguredWithCollectionView:(UICollectionView *)collectionView
                                               itemSize:(CGSize)itemSize
                                     minimumLineSpacing:(CGFloat)minimumLineSpacing;
@property (assign, nonatomic) CGFloat padding;

@end
