//
//  PBBaseViewController.h
//  PiggyBank
//
//  Created by Nagaraju on 16/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBBaseViewController : UIViewController

@end

@interface PBBaseViewController (PBActivityIndicatorHelper)

/** Returns YES if the activity indicator is being shown
 */
- (BOOL)isShowingActivityIndicator;

/** Starts the activity indicator
 */
- (void)startActivityIndicator:(BOOL)animated;

/** Stops the activity indicator
 */
- (void)stopActivityIndicator;

@end
