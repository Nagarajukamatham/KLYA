//
//  PBMoneySwipeViewController.m
//  PiggyBank
//
//  Created by Nagaraju on 22/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBMoneySwipeViewController.h"
#import "PBCoinSwipeView.h"
#import "CoinCell.h"
#import "PBUtility.h"
#import "BLEManager.h"
#import "PBMessage.h"
#import "PBHomeViewController.h"
#import "PBSuccessViewController.h"
#import "AudioController.h"
#import "UserModel.h"
#import "PBConstants.h"

@interface PBMoneySwipeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,BLESerialDelegate>{
    BLEManager *bleManager;
    NSMutableArray *dataSource;
    NSMutableArray *amountArr;
    NSDictionary *removedObject;
    NSTimer *arrowTimer;
    NSInteger swipedIndx;
    UserModel *userObj;
    NSUserDefaults *defaults;
    
    CFTimeInterval progressStart;
    int progressCount,count;
    UILabel *timerrLbl;
    UIProgressView *progressBar;
    UIView *bgProgressView;
}

@property (strong, nonatomic) PBCoinSwipeView *collectionViewLayout;
@property (strong, nonatomic) AudioController *audioController;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (readonly, nonatomic) CGFloat pageWidth;
@property (readonly, nonatomic) CGFloat contentOffset;

@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;
@property (assign, nonatomic) NSUInteger animationsCount;
@property (nonatomic, strong) NSTimer *myTimer;

@end

@implementation PBMoneySwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSData *loginData = [defaults objectForKey:@"loginResp"];
    userObj = [NSKeyedUnarchiver unarchiveObjectWithData:loginData];
    
    self.audioController = [[AudioController alloc] init];
    bleManager = [[BLEManager alloc] init];
    bleManager.serialDelegate = self;
    
    //[self updatesCoins:self.transferedAmount];
    dataSource = [[NSMutableArray alloc] init];
    NSString *transferedAmt = [NSString stringWithFormat:@"%ld",(long)[self.transferedAmount integerValue]];
    dataSource = [PBUtility getDenominations:transferedAmt];
    [self configureCollectionView];
    [self configurePageControl];
    
    UIColor *arrowColor = [[PBUtility colorFromHexString:@"#686868"] colorWithAlphaComponent:0.6];
    self.arrowImgView.image = [PBUtility filledImageFrom:[UIImage imageNamed:@"arrowUp"] withColor:arrowColor];
    
    self.animateUpImag.hidden=YES;
    CGFloat coinWidth = self.animateUpImag.frame.size.width;
    CGFloat coinHeight = self.animateUpImag.frame.size.height;
    self.centerX = self.view.frame.size.width/2 - coinWidth/2;
    self.centerY = self.view.frame.size.height/2 - coinHeight/2;

    [self animatedFrameChange:CGRectMake(self.centerX,self.centerY,coinWidth,coinHeight)];
   // self.swipeView.userInteractionEnabled=YES;
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpcall:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.collectionView addGestureRecognizer:swipeGesture];
    
    self.totalSwipedAmount.text = [PBUtility amountWithRupee:@"0"];
    self.amountToswipe.text =[PBUtility amountWithRupee:self.transferedAmount];
    
    self.arrowView.frame = CGRectMake((self.view.frame.size.width/2 - 30),(self.view.frame.size.height/2 -40), 60, 80);
    // For arrow move up
    [self refreshArrowUp];
    arrowTimer = [NSTimer scheduledTimerWithTimeInterval:1.1 target:self selector:@selector(refreshArrowUp) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:arrowTimer forMode:NSRunLoopCommonModes];
    
}

-(void)updatesCoins:(NSString*)amtStr{
    dataSource = [[NSMutableArray alloc] init];
    NSString *transferedAmt = [NSString stringWithFormat:@"%ld",(long)[amtStr integerValue]];
    dataSource = [PBUtility getDenominations:transferedAmt];
    NSLog(@"dataSource ---->>> %@",dataSource);
    [self configurePageControl];
    [self.collectionView reloadData];
    
}

-(void)refreshArrowUp{
    CGFloat arrowCenterX = self.view.frame.size.width/2 - 30;
    CGFloat arrowCenterY = self.view.frame.size.height/2 - 40;
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.arrowView.frame = CGRectMake(arrowCenterX, 20, 60, 44);
                         self.arrowView.hidden=NO;
                     }
                     completion:^(BOOL finished){
                         self.arrowView.frame = CGRectMake(arrowCenterX, arrowCenterY, 60, 80);
                         self.arrowView.hidden=YES;
                     }];
}


-(void)serialDidUpdateState{
    NSLog(@"state chng ------------->>>");
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"sent '#' ------------->>>");
    [bleManager sendMessage:[PBMessage transferSpecialCharacter:@"#"] toPiggy:self.selectedPiggy withCharacteristics:self.writeCharacteristic];
}

-(void)swipeUpcall:(id)tap {
   // NSLog(@"swipeUpcall ------>>");
    CGPoint tapLocation = [tap locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath)
    {
        // Yay! Tapped on center item!
        if (swipedIndx == indexPath.row || swipedIndx == dataSource.count || dataSource.count == 1) {
            self.pageControl.currentPage = indexPath.row;
            self.animateUpImag.image = [UIImage imageNamed:[dataSource[indexPath.row] objectForKey:@"image"]];
            [self performSelector:@selector(animateUp) withObject:self afterDelay:0.01];
        }
        
        
//        CoinCell *cell = (CoinCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//        CGRect mySubviewRectInCollectionViewCoorSys = [self.collectionView convertRect:cell.coinImg.frame fromView:cell];
//        
//        if (CGRectContainsPoint(mySubviewRectInCollectionViewCoorSys, tapLocation) && (swipedIndx == indexPath.row))
//        {
//            // Yay! My subview was tapped!
//            self.pageControl.currentPage = indexPath.row;
//            self.animateUpImag.image = [UIImage imageNamed:[dataSource[indexPath.row] objectForKey:@"image"]];
//            [self performSelector:@selector(animateUp) withObject:self afterDelay:0.01];
//        }
//        else if (swipedIndx == dataSource.count || dataSource.count==1){
//            NSLog(@"swipedIndx ----------->>>> %ld",swipedIndx);
//            NSLog(@"dataSource.count ----->>>> %ld",dataSource.count);
//            NSLog(@"<<<<=========== Excused center  ============>>>>");
//            self.pageControl.currentPage = indexPath.row;
//            self.animateUpImag.image = [UIImage imageNamed:[dataSource[indexPath.row] objectForKey:@"image"]];
//            [self performSelector:@selector(animateUp) withObject:self afterDelay:0.01];
//        }
    }
}

#pragma mark - Configuration
- (void)configureCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:@"CoinCell" bundle:nil]
          forCellWithReuseIdentifier:@"CoinCell"];
    
    self.collectionViewLayout = [PBCoinSwipeView layoutConfiguredWithCollectionView:self.collectionView
                                                                                        itemSize:CGSizeMake(190, 180)
                                                                              minimumLineSpacing:0];
}

- (void)configurePageControl {
    self.pageControl.numberOfPages = dataSource.count;
}

#pragma mark - Actions
- (IBAction)pageControlValueChanged:(id)sender {
    [self scrollToPage:self.pageControl.currentPage animated:YES];
}

- (void)scrollToPage:(NSUInteger)page animated:(BOOL)animated {
    self.collectionView.userInteractionEnabled = NO;
    self.animationsCount++;
    CGFloat pageOffset = page * self.pageWidth - self.collectionView.contentInset.left;
    [self.collectionView setContentOffset:CGPointMake(pageOffset, 0) animated:animated];
    self.pageControl.currentPage = page;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CoinCell *cell =
    (CoinCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CoinCell"
                                                                    forIndexPath:indexPath];
    cell.coinImg.image = [UIImage imageNamed:[dataSource[indexPath.row] objectForKey:@"image"]];
    //cell.coinImg.contentMode = UIViewContentModeScaleAspectFit;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.isDragging || collectionView.isDecelerating || collectionView.isTracking)
        return;

//    NSUInteger selectedPage = indexPath.row;
//    if (selectedPage == self.pageControl.currentPage) {
//        NSLog(@"Did select center item--->>> ");
//        //NSLog(@"Did select center item--->>> %@",[self.dataSource objectAtIndex:selectedPage]);
//       // [self animateUp];
//
//    }
//    else {
//        [self scrollToPage:selectedPage animated:YES];
//    }
}



-(void)hideErrorMessage{
    self.errorLbl.hidden=YES;
}

-(void)animateUp{
    double presentSwipedCoin = [[dataSource[self.pageControl.currentPage] objectForKey:@"amount"] doubleValue];
    if (presentSwipedCoin<=2) {
        [self.audioController playSystemSound:@"coin_sound"];
    }else{
        [self.audioController playSystemSound:@"note_sound"];
    }
    double needToSwipe = [[PBUtility toRupeeString:self.amountToswipe.text] doubleValue];
    if (presentSwipedCoin>needToSwipe) {
        //error message
        self.errorLbl.hidden=NO;
        [self performSelector:@selector(hideErrorMessage) withObject:self afterDelay:0.5];
    }
    else{
        removedObject=[dataSource objectAtIndex:self.pageControl.currentPage];
        NSInteger amt = [[removedObject objectForKey:@"amount"] integerValue];
        NSDictionary *temp = @{@"image":@"abcd",@"amount":[NSNumber numberWithInteger:amt]};
        [dataSource replaceObjectAtIndex:self.pageControl.currentPage withObject:temp];
        [self.collectionView reloadData];
        
        self.animateUpImag.hidden=NO;
        self.collectionView.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.7 animations:^{
            self.animateUpImag.frame = CGRectMake(self.view.frame.size.width/2 - 22,20,44,44);
        }];
        [self performSelector:@selector(normalState) withObject:self afterDelay:0.75];
    }
}

-(void)normalState{
    
    double present = [[dataSource[self.pageControl.currentPage] objectForKey:@"amount"] doubleValue];
    double total = [[PBUtility toRupeeString:self.totalSwipedAmount.text] doubleValue]+present;
    self.totalSwipedAmount.text = [PBUtility amountWithRupee:[NSString stringWithFormat:@"%.2f",total]];
    double needToSwipe = [[PBUtility toRupeeString:self.amountToswipe.text] doubleValue];
    double remainingAmount = needToSwipe-present;
    self.amountToswipe.text = [PBUtility amountWithRupee:[NSString stringWithFormat:@"%.2f",remainingAmount]];
    self.animateUpImag.hidden=YES;
    self.collectionView.userInteractionEnabled = YES;
    [self animatedFrameChange:CGRectMake(self.centerX,self.centerY,190,120)];
    [dataSource replaceObjectAtIndex:self.pageControl.currentPage withObject:removedObject];
    [self.collectionView reloadData];
    
    NSString *tot = [NSString stringWithFormat:@"%.2f",total];
    NSString *needTo = [NSString stringWithFormat:@"%.2f",[self.transferedAmount doubleValue]];
    if ([tot doubleValue] == [needTo doubleValue]) {
        NSLog(@"transfer completed go to sent '*' --------------------------------->>>");
        [arrowTimer invalidate];
        arrowTimer=nil;
        
        [self startActivityIndicator:YES];
        [self performSelector:@selector(gotoConfirmation) withObject:self afterDelay:1];
    }else{
        // updating the money denomination after swipe the coin
        if (dataSource.count > 1) {
            [self updatesCoins:[NSString stringWithFormat:@"%.2f",remainingAmount]];
            //NSInteger index = [dataSource count]-1;

        }
    }
}

-(void)gotoConfirmation{
    [self updatePiggyWithBalance];
}

-(void)updatePiggyWithBalance{
    NSString *childAcBalance=[NSString stringWithFormat:@"%.2f",userObj.accounts.child.balance];
    [bleManager sendMessage:[PBMessage passBalance:childAcBalance currencyName:keuros] toPiggy:self.selectedPiggy withCharacteristics:self.writeCharacteristic];
    
    [self showProgressViewWithTimer];
    [self performSelector:@selector(Delay_TransferBalance) withObject:self afterDelay:8.0];
    
}

/////////////////////////////


//-(void)Delay_YashSend{
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        [bleManager sendMessage:[PBMessage transferSpecialCharacter:@"#"] toPiggy:self.selectedPiggy withCharacteristics:self.writeCharacteristic];
//
//        [self performSelector:@selector(Delay_StarSend) withObject:self afterDelay:3.0];
//
//    });
//}

-(void)Delay_TransferBalance{
    [bleManager sendMessage:[PBMessage transferMoney:[NSString stringWithFormat:@"0"]] toPiggy:self.selectedPiggy withCharacteristics:self.writeCharacteristic];
    
    [self performSelector:@selector(Delay_StarSend) withObject:self afterDelay:5.0];
}

-(void)Delay_StarSend{
    [self stopActivityIndicator];
    [bleManager sendMessage:[PBMessage transferSpecialCharacter:@"*"] toPiggy:self.selectedPiggy withCharacteristics:self.writeCharacteristic];
    [bgProgressView removeFromSuperview];
    
    PBSuccessViewController *success = [self.storyboard instantiateViewControllerWithIdentifier:@"PBSuccessViewController"];
    [self.navigationController pushViewController:success animated:YES];
}


////////////////////////////
-(void)animatedFrameChange:(CGRect)frame{
    self.animateUpImag.frame = frame;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (--self.animationsCount > 0) return;
    self.collectionView.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //self.pageControl.currentPage = self.contentOffset / self.pageWidth;
    //NSInteger index = self.pageControl.currentPage;
    //NSLog(@"index =====>>> %ld",(long)index);
   // self.animateUpImag.image = [UIImage imageNamed:[dataSource[index] objectForKey:@"image"]];
    swipedIndx = self.contentOffset / self.pageWidth;
}

#pragma mark - Convenience

- (CGFloat)pageWidth {
    return self.collectionViewLayout.itemSize.width + self.collectionViewLayout.minimumLineSpacing;
}

- (CGFloat)contentOffset {
    return self.collectionView.contentOffset.x + self.collectionView.contentInset.left;
}


-(IBAction)skipBtnClicked:(id)sender{
    [self showAlertmsgStr:@"Are you sure want to skip"];
}

#pragma mark -
-(void)showAlertmsgStr:(NSString*)msgStr{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:msgStr
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    //Add Buttons
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"One Click Update"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [arrowTimer invalidate];
                                    arrowTimer=nil;
                                    
                                    [self startActivityIndicator:YES];
                                    [self performSelector:@selector(gotoConfirmation) withObject:self afterDelay:1];
                                }];
    [alert addAction:yesButton];
    
    UIAlertAction* noButton = [UIAlertAction
                                actionWithTitle:@"Update later"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    
                                [bleManager sendMessage:[PBMessage transferSpecialCharacter:@"*"] toPiggy:self.selectedPiggy withCharacteristics:self.writeCharacteristic];
                                    
                                PBHomeViewController *search = [self.storyboard instantiateViewControllerWithIdentifier:@"PBHomeViewController"];
                                    [self.navigationController pushViewController:search animated:YES];
                                    
                                }];
    [alert addAction:noButton];
    
    UIAlertAction* cancelButton = [UIAlertAction
                                actionWithTitle:@"Cancel"
                                style:UIAlertActionStyleDestructive
                                handler:^(UIAlertAction * action) {
                                    
                                }];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
    
}


-(void)viewDidDisappear:(BOOL)animated{
    if (arrowTimer) {
        [arrowTimer invalidate];
        arrowTimer=nil;
    }
}

- (void)showProgressViewWithTimer
{
    //self.progressView.progress = 1.0;
    progressBar.progress = 1.0;
    progressStart = CACurrentMediaTime();
    progressCount = 13;

    bgProgressView =[[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, (self.view.frame.size.height/2)-130, 200, 60)];
    bgProgressView.backgroundColor = [UIColor whiteColor];//[[PBUtility colorFromHexString:APP_COLOR] colorWithAlphaComponent:0.5];
    bgProgressView.layer.cornerRadius = 5.0;
    [self.view addSubview:bgProgressView];
    
    timerrLbl = [[UILabel alloc] initWithFrame:CGRectMake((bgProgressView.frame.size.width/2)-60, 10, 120, 25)];
    timerrLbl.textAlignment = NSTextAlignmentCenter;
    timerrLbl.text = [NSString stringWithFormat:@"Updating KLYA 0%%"];
    timerrLbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
   // timerrLbl.textColor = [UIColor darkGrayColor];
    //timerrLbl.backgroundColor = [UIColor greenColor];
    [bgProgressView addSubview:timerrLbl];
    
    progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressBar.frame = CGRectMake((bgProgressView.frame.size.width/2)-70, 40, 140, 10);
    [progressBar setTintColor:[PBUtility colorFromHexString:APP_COLOR]];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 2.0f);
    progressBar.transform = transform;
    [bgProgressView addSubview:progressBar];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];
    
}

- (void)updateUI:(NSTimer *)timer
{
   // NSLog(@"updateUI --->>>");
     count++;
    // int progressTime = 14;
    float totalTime = (float)progressCount;
    if (count <= progressCount)
    {
        float current = (float)count;
        timerrLbl.text = [NSString stringWithFormat:@"Updating KLYA %.f%%",(current/totalTime)*100];
         NSLog(@"val ---->>> %.f",[[NSString stringWithFormat:@"%.f",(current/totalTime)*100] floatValue]);
        progressBar.progress = [[NSString stringWithFormat:@"%.f",(current/totalTime)*100] floatValue]/100;
    } else
    {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
