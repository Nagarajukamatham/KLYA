//
//  PBCoinSwipeView.m
//  PiggyBank
//
//  Created by Nagaraju on 22/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBCoinSwipeView.h"
#import "PBConstants.h"
@interface PBCoinSwipeView ()

@property (assign, nonatomic) CGSize lastCollectionViewSize;
@end

@implementation PBCoinSwipeView

#pragma mark - Configuration

+ (PBCoinSwipeView *)layoutConfiguredWithCollectionView:(UICollectionView *)collectionView
                                                            itemSize:(CGSize)itemSize
                                                  minimumLineSpacing:(CGFloat)minimumLineSpacing {
    PBCoinSwipeView *layout = [PBCoinSwipeView new];
    collectionView.collectionViewLayout = layout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = minimumLineSpacing;
    layout.itemSize = itemSize;
    layout.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    
    return layout;
}

#pragma mark - Init/Defaults

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureDefaults];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureDefaults];
}

- (void)configureDefaults {
    self.scalingOffset = 200;
    self.minimumScaleFactor = 0.7;
    self.scaleItems = YES;
    // iphone 8 --- 65, se---- 0.0
    self.padding=[self paddingToMakeItemCenter];
}

-(CGFloat)paddingToMakeItemCenter{
    CGFloat padding=0.0;
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
        NSLog(@"IS_IPHONE_5");
        padding=0.0; //70.0;
    }
    else if (IS_IPHONE_6){
        NSLog(@"IS_IPHONE_6");
        // i8
        padding=70.0; //0.0
    }
    else if(IS_IPHONE_6P){
        NSLog(@"IS_IPHONE_6P");
        padding=0.0;
    }
    else if (IS_IPHONE_X){
        NSLog(@"IS_IPHONE_X");
        padding=70.0; //0.0
    }
    else if (IS_IPAD) {
        NSLog(@"IS_IPAD");
        padding=0;
    }
    return padding;
}

#pragma mark - Invalidation

- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context {
    [super invalidateLayoutWithContext:context];
    
    CGSize currentCollectionViewSize = self.collectionView.bounds.size;
    if (!CGSizeEqualToSize(currentCollectionViewSize, self.lastCollectionViewSize)) {
        [self configureInset];
        self.lastCollectionViewSize = currentCollectionViewSize;
    }
}

- (void)configureInset {
    CGFloat inset = (self.collectionView.bounds.size.width/2) - (self.itemSize.width/2) -_padding ;
    NSLog(@"coin inset ---->> %f",inset);
    self.collectionView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
    self.collectionView.contentOffset = CGPointMake(-inset, 0);
}

#pragma mark - UICollectionViewLayout (UISubclassingHooks)

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGSize collectionViewSize = self.collectionView.bounds.size;
    CGFloat proposedContentOffsetCenterX = proposedContentOffset.x + collectionViewSize.width / 2;
    CGRect proposedRect = CGRectMake(proposedContentOffset.x, 0, collectionViewSize.width, collectionViewSize.height);
    
    UICollectionViewLayoutAttributes *candidateAttributes;
    for (UICollectionViewLayoutAttributes *attributes in [self layoutAttributesForElementsInRect:proposedRect]) {
        if (attributes.representedElementCategory != UICollectionElementCategoryCell) continue;
        
        if (!candidateAttributes) {
            candidateAttributes = attributes;
            continue;
        }
        
        if (fabs(attributes.center.x - proposedContentOffsetCenterX) < fabs(candidateAttributes.center.x - proposedContentOffsetCenterX)) {
            candidateAttributes = attributes;
        }
    }
    
    proposedContentOffset.x = candidateAttributes.center.x - self.collectionView.bounds.size.width / 2;
    
    CGFloat offset = proposedContentOffset.x - self.collectionView.contentOffset.x;
    
    if ((velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0)) {
        CGFloat pageWidth = self.itemSize.width + self.minimumLineSpacing;
        proposedContentOffset.x += velocity.x > 0 ? pageWidth : -pageWidth;
    }
    
    return proposedContentOffset;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    if (!self.scaleItems) return [super layoutAttributesForElementsInRect:rect];
    
    NSArray *attributesArray = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect]
                                                    copyItems:YES];
    
    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
    CGFloat visibleCenterX = CGRectGetMidX(visibleRect);
    
    [attributesArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        CGFloat distanceFromCenter = visibleCenterX - attributes.center.x;
        CGFloat absDistanceFromCenter = MIN(ABS(distanceFromCenter), self.scalingOffset);
        CGFloat scale = absDistanceFromCenter * (self.minimumScaleFactor - 1) / self.scalingOffset + 1;
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1);
    }];
    
    return attributesArray;
}

#pragma mark -

@end
