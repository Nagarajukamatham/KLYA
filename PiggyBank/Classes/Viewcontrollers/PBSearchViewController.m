//
//  PBSearchViewController.m
//  PiggyBank
//
//  Created by Nagaraju on 21/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBSearchViewController.h"
#import "LNBRippleEffect.h"
#import "PBUtility.h"
#import "PBConstants.h"
#import "BLEManager.h"
#import "PBSetupToyViewController.h"
#import "PBSearchDevices.h"
#import "CollectionViewCell.h"
#import "PBMoneySwipeViewController.h"
#import "PBMessage.h"
#import "PBSuccessViewController.h"
#import "PBHomeViewController.h"
#import "UserModel.h"
#import "HDLocalizeHelper.h"
#import "PBCheckBLEViewController.h"


@interface PBSearchViewController ()<BLESerialDelegate,UICollectionViewDataSource, UICollectionViewDelegate>{
    LNBRippleEffect *rippleEffect;
    BLEManager *bleManager;
    NSMutableArray *peripheralsArr;
   
    UserModel *user;
    NSUserDefaults *defaults;
    NSInteger alertChk;
    UserModel *userObj;
    BOOL isScanStopped;
    CBPeripheral *selectedPeripheral;
    
    
    CFTimeInterval progressStart;
    int progressCount,count;
    UILabel *timerrLbl;
    UIProgressView *progressBar;
    UIView *bgProgressView;
}

@property (strong, nonatomic) NSArray *dataSource;

@property (strong, nonatomic) PBSearchDevices *collectionViewLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (readonly, nonatomic) CGFloat pageWidth;
@property (readonly, nonatomic) CGFloat contentOffset;
@property (assign, nonatomic) NSUInteger animationsCount;
@property (nonatomic,retain) CBCharacteristic *writeCharacteristic;
@property (nonatomic, strong) NSTimer *myTimer;
@end

@implementation PBSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSData *loginData = [defaults objectForKey:@"loginResp"];
    userObj = [NSKeyedUnarchiver unarchiveObjectWithData:loginData];
    
    peripheralsArr=[[NSMutableArray alloc] init];
    bleManager = [[BLEManager alloc] init];
    bleManager.serialDelegate = self;

    NSString *barButtonImgName;
    [self performSelector:@selector(startScan) withObject:self afterDelay:0.1];
    
    if ([self.cameFrom isEqualToString:@"transfer"]||[self.cameFrom isEqualToString:@"goal"] || [self.cameFrom isEqualToString:@"update"] || [self.cameFrom isEqualToString:@"disconnect"]) {
        NSString *pname = userObj.accounts.child.piggyDetails.piggyName;
        NSString *str1 = LocalizedString(@"Searching for");
        NSString *str2 = LocalizedString(@"KLYA");
        NSString *fullText = [NSString stringWithFormat:@"%@ %@ %@",str1,pname,str2];
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: [UIColor darkGrayColor],
                                  NSFontAttributeName: [UIFont systemFontOfSize:15]
                                  };
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:fullText
                                               attributes:attribs];
        UIColor *gColor = [PBUtility colorFromHexString:APP_COLOR];
        NSRange greenTextRange = [fullText rangeOfString:pname];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:gColor}
                                range:greenTextRange];
        self.piggyNameLbl.attributedText = attributedText;
        if ([self.cameFrom isEqualToString:@"update"] || [self.cameFrom isEqualToString:@"disconnect"]) {
            barButtonImgName=@"";
            self.tapLbl.hidden=YES;
            [self.backBtn setEnabled:NO];
        }else{
            barButtonImgName=@"home";
            self.tapLbl.hidden=NO;
            [self.backBtn setEnabled:YES];
        }
        
    }else{
        self.piggyNameLbl.text = LocalizedString(@"Searching for KLYA");
        barButtonImgName=@"back";
    }
    UIImage* backgroundImage = [UIImage imageNamed:barButtonImgName];
    [self.backBtn setImage:backgroundImage];

    [self.refreshBtn setEnabled:NO];
    [self.refreshBtn setTintColor: [UIColor clearColor]];
}

-(void)serialDidUpdateState{
//    NSLog(@"serialDidUpdateState --------------->>>>");
    if (bleManager.centralManager.state != CBManagerStatePoweredOn) {
        NSLog(@"bluetooth off search===--====>>>>");
    }else{
        NSLog(@"bluetooth on search===--====>>>>");
    }
}

-(void)startScan{

        self.navigationBar.topItem.title= LocalizedString(@"Searching..");
        [self setRippleEffect];
        isScanStopped=NO;
        [bleManager startScan];
        [self performSelector:@selector(stopScan) withObject:nil afterDelay:30.0];
    
}

-(void)serialDidDiscover:(CBPeripheral *)peripheral RSSI:(NSNumber *)iRSSI{
    if (![peripheralsArr containsObject:peripheral] && peripheral.name.length!=0 ) {
        NSLog(@"iPeripheral  ------->>>> %@",peripheral.name);
        if ([self.cameFrom isEqualToString:@"home"]) {
            NSLog(@"iPeripheral Discovered ------->>>> %@",peripheral.name);
            [peripheralsArr addObject:peripheral];
            [self performSelector:@selector(stopScan) withObject:nil afterDelay:3.2];
            isScanStopped=NO;
        }
        else{
            if ([userObj.accounts.child.piggyDetails.deviceId isEqualToString:peripheral.identifier.UUIDString]) {
                selectedPeripheral = peripheral;
                NSLog(@"selectedtoy ---->>> %@",selectedPeripheral.name);
                [self performSelector:@selector(stopScan) withObject:nil afterDelay:2.0];
                isScanStopped=NO;
            }
        }
    }
}

-(void)stopScan{
    if (!isScanStopped) {
        NSLog(@"scan stopped ---->>>");
        if ([self.cameFrom isEqualToString:@"update"]||[self.cameFrom isEqualToString:@"disconnect"]||[self.cameFrom isEqualToString:@"reset"]) {
            [rippleEffect setRippleColor:[UIColor clearColor]];
            [rippleEffect setRippleTrailColor:[UIColor clearColor]];
        }else{
            [rippleEffect removeFromSuperview];
        }
        
        self.scanView.hidden=YES;
        [bleManager stopScan];
        if ([self.cameFrom isEqualToString:@"home"]) {
            if (peripheralsArr.count==0) {
                self.collectionView.hidden=YES;
                self.tryagainView.hidden=NO;
                self.navigationBar.topItem.title=@"";
                [rippleEffect removeFromSuperview];
            }else{
                self.collectionView.hidden=NO;
                self.tryagainView.hidden=YES;
                self.navigationBar.topItem.title = LocalizedString(@"Choose a KLYA");
                [self.refreshBtn setEnabled:YES];
                [self.refreshBtn setTintColor:[UIColor whiteColor]];
            }
            [self refreshCarsoualView];
        }else{
            //transfer/Goal/update
            if (selectedPeripheral) {
                self.collectionView.hidden=YES;
                self.tryagainView.hidden=YES;
                self.pageControl.hidden=YES;
                if ([self.cameFrom isEqualToString:@"update"]) {
                    self.navigationBar.topItem.title= @"Syncing KLYA";
                }else if ([self.cameFrom isEqualToString:@"disconnect"]){
                    self.navigationBar.topItem.title= @"Disconnecting KLYA";
                }else{
                    self.navigationBar.topItem.title=@"";
                }
                [self startActivityIndicator:YES];
                [bleManager connectToPeropheral:selectedPeripheral];
            }else{
                self.collectionView.hidden=YES;
                self.tryagainView.hidden=NO;
                self.navigationBar.topItem.title=@"";
                [self.backBtn setEnabled:YES];
                UIImage* backgroundImage = [UIImage imageNamed:@"back"];
                [self.backBtn setImage:backgroundImage];
                [rippleEffect removeFromSuperview];
            }
        }
        isScanStopped=YES;
    }else{
        NSLog(@"SCAN ALREADY stopped ---->>>");
    }
}

-(void)refreshCarsoualView{
    [self configureDataSource];
    [self configureCollectionView];
    [self configurePageControl];
}

-(IBAction)tryAgainBtnClicked:(id)sender{
    [self reScanAgain];
}

-(void)reScanAgain{
    self.tryagainView.hidden=YES;
    self.scanView.hidden=NO;
    [self startScan];
}

-(IBAction)refreshBtnClicked:(id)sender{
    [rippleEffect removeFromSuperview];
    [self reScanAgain];
}


-(void)serialDidConnect:(CBPeripheral *)peripheral{
    NSLog(@"************* serial connected **************");

}

-(void)serialDidDiscoverCharacteristic:(CBCharacteristic *)iCharacteristic peripheral:(CBPeripheral *)peripheral{
    NSLog(@"serialDidDiscoverCharacteristic----->>");
    if ([self.cameFrom isEqualToString:@"home"]) {
        self.writeCharacteristic=iCharacteristic;
        
        [bleManager sendMessage:[PBMessage transferSpecialCharacter:@"&"] toPiggy:peripheral withCharacteristics:iCharacteristic];
        [self performSelector:@selector(gotoSetup) withObject:self afterDelay:1.0];
        
    }
    else if ([self.cameFrom isEqualToString:@"transfer"]){
        [self stopActivityIndicator];
        
        PBMoneySwipeViewController *swipe = [self.storyboard instantiateViewControllerWithIdentifier:@"PBMoneySwipeViewController"];
        swipe.transferedAmount= self.amountToTransfer;
        swipe.selectedPiggy=peripheral;
        swipe.writeCharacteristic=iCharacteristic;
        [self.navigationController pushViewController:swipe animated:YES];
    }
    else if ([self.cameFrom isEqualToString:@"goal"]) {
        _amountToTransfer=[NSString stringWithFormat:@"%.2f",[_amountToTransfer doubleValue]];
        [bleManager sendMessage:[PBMessage passGoal:_goalName amount:_amountToTransfer] toPiggy:peripheral withCharacteristics:iCharacteristic];
        [self performSelector:@selector(gotoConfirmation) withObject:self afterDelay:1.0];
    }
    else if ([self.cameFrom isEqualToString:@"update"]) {
        self.writeCharacteristic=iCharacteristic;
        selectedPeripheral = peripheral;
        [self startActivityIndicator:YES];
        [self showProgressViewWithTitle:@"Syncing KLYA"];
        [self performSelector:@selector(Delay_YashSend) withObject:self afterDelay:0.0];
    }
    else if ([self.cameFrom isEqualToString:@"disconnect"]) {
        self.writeCharacteristic=iCharacteristic;
        selectedPeripheral = peripheral;
        [self showProgressViewWithTitle:@"Disconnecting KLYA"];
        [bleManager sendMessage:[PBMessage passAccountNumber:userObj.accounts.child.accountNumber piggyName:@"KLYA"] toPiggy:peripheral withCharacteristics:iCharacteristic];
        [self performSelector:@selector(Delay_goalSend) withObject:self afterDelay:5.0];
    }
    else if ([self.cameFrom isEqualToString:@"reset"]) {
        self.writeCharacteristic=iCharacteristic;
        selectedPeripheral = peripheral;
        [self showProgressViewWithTitle:@"Resetting KLYA"];
        [bleManager sendMessage:[PBMessage passAccountNumber:userObj.accounts.child.accountNumber piggyName:userObj.accounts.child.piggyDetails.piggyName] toPiggy:peripheral withCharacteristics:iCharacteristic];
        
        [self performSelector:@selector(Delay_goalSend) withObject:self afterDelay:5.0];
    }
}

-(void)Delay_goalSend{
    NSLog(@"Delay_goalSend ======>>>");
    [bleManager sendMessage:[PBMessage passGoal:@"Goal" amount:@"9999"] toPiggy:selectedPeripheral withCharacteristics:self.writeCharacteristic];
    [self performSelector:@selector(Delay_YashSend) withObject:self afterDelay:5.0];
}

-(void)Delay_YashSend{
    [bleManager sendMessage:[PBMessage transferSpecialCharacter:@"#"] toPiggy:selectedPeripheral withCharacteristics:self.writeCharacteristic];
    [self performSelector:@selector(Delay_BalanceSend) withObject:self afterDelay:5.0];
}

-(void)Delay_BalanceSend{
    NSLog(@"Delay_BalanceSend ======>>>");
    NSString *childAcBalance;
    if ([self.cameFrom isEqualToString:@"update"]) {
      childAcBalance=[NSString stringWithFormat:@"%.2f",userObj.accounts.child.balance];
    }else{
        childAcBalance=@"0";
    }
    
    [bleManager sendMessage:[PBMessage passBalance:childAcBalance currencyName:keuros] toPiggy:selectedPeripheral withCharacteristics:self.writeCharacteristic];
    
    [self performSelector:@selector(Delay_TransferBalance) withObject:self afterDelay:8.0];
}

-(void)Delay_TransferBalance{
    [bleManager sendMessage:[PBMessage transferMoney:[NSString stringWithFormat:@"0"]] toPiggy:selectedPeripheral withCharacteristics:self.writeCharacteristic];
    
    [self performSelector:@selector(Delay_StarSend) withObject:self afterDelay:5.0];
}

-(void)Delay_goal1Send{
    NSLog(@"Delay_goalSend ======>>>");
    [self stopActivityIndicator];
    [bleManager sendMessage:[PBMessage passGoal:userObj.accounts.child.piggyDetails.goalName amount:userObj.accounts.child.piggyDetails.goalAmount] toPiggy:selectedPeripheral withCharacteristics:self.writeCharacteristic];
    
    [bgProgressView removeFromSuperview];
    [rippleEffect removeFromSuperview];
    alertChk=2;
    [self showAlertmsgStr:[PBUtility AttributtedStr_Pname:userObj.accounts.child.piggyDetails.piggyName desc:@"is updated successfully"]];
}

-(void)Delay_StarSend{
    if ([self.cameFrom isEqualToString:@"update"]) {
        [bleManager sendMessage:[PBMessage transferSpecialCharacter:@"*"] toPiggy:selectedPeripheral withCharacteristics:self.writeCharacteristic];
        [self performSelector:@selector(Delay_goal1Send) withObject:self afterDelay:8.0];
    }
    else if ([self.cameFrom isEqualToString:@"reset"]){
        [self stopActivityIndicator];
        [bleManager sendMessage:[PBMessage transferSpecialCharacter:@"*"] toPiggy:selectedPeripheral withCharacteristics:self.writeCharacteristic];
    
        [bgProgressView removeFromSuperview];
        [rippleEffect removeFromSuperview];
        alertChk=2;
        [self showAlertmsgStr:[PBUtility AttributtedStr_Pname:userObj.accounts.child.piggyDetails.piggyName desc:@"is Reset successfully"]];
    }
    else{
        [self stopActivityIndicator];
        [bleManager sendMessage:[PBMessage transferSpecialCharacter:@"*"] toPiggy:selectedPeripheral withCharacteristics:self.writeCharacteristic];
        
        
        [bgProgressView removeFromSuperview];
        [rippleEffect removeFromSuperview];
        alertChk=2;
        if (self.disconnectChk==1) {
            [defaults setBool:YES forKey:@"isDisconnected"];
            [defaults synchronize];
        }

        [self showAlertmsgStr:[PBUtility AttributtedStr_Pname:userObj.accounts.child.piggyDetails.piggyName desc:@"is disconnected successfully"]];
    }

}

////////////////////////////

-(void)gotoSetup{
    [self stopActivityIndicator];
    PBSetupToyViewController *setup = [self.storyboard instantiateViewControllerWithIdentifier:@"PBSetupToyViewController"];
    setup.selectedToy= selectedPeripheral;
    setup.writeCharacteristic=self.writeCharacteristic;
    [self.navigationController pushViewController:setup animated:YES];
}

-(void)gotoConfirmation{
    [self stopActivityIndicator];
    PBSuccessViewController *success = [self.storyboard instantiateViewControllerWithIdentifier:@"PBSuccessViewController"];
    [self.navigationController pushViewController:success animated:YES];
}

-(void)serialDidFailToConnect:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"Did FailToConnect ---->>> %@",error.localizedDescription);
}

-(void)serialDiddisConnect:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"Did disConnect ---->>> %@",error.localizedDescription);
   // [peripheralsArr removeObject:peripheral];
}

//Here Show Ripple View
-(void)setRippleEffect{
    
    CGFloat startX=0.0;
    CGFloat startY=0.0;
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
        startX=100;
        startY=250;
    }
    else if (IS_IPHONE_6){
        startX=125;
        startY=250;
        
    }
    else if(IS_IPHONE_6P){
        startX=150;
        startY=300;
    }
    else if (IS_IPHONE_X){
        startX=125;
        startY=350;
    }
    else if (IS_IPAD) {
        startX=320;
        startY=450;
    }
    
    rippleEffect = [[LNBRippleEffect alloc]initWithImage:[UIImage imageNamed:@"piggy_icon"] Frame:CGRectMake(startX, startY, 130, 130) Color:[PBUtility colorFromHexString:APP_COLOR] Target:nil ID:self];
    [rippleEffect setRippleColor:[PBUtility colorFromHexString:APP_COLOR]];
    UIColor *clr = [[PBUtility colorFromHexString:APP_COLOR] colorWithAlphaComponent:0.5];
    [rippleEffect setRippleTrailColor:clr];
    [self.view addSubview:rippleEffect];
}

#pragma mark - View Pager

- (void)configureCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    self.collectionViewLayout = [PBSearchDevices layoutConfiguredWithCollectionView:self.collectionView
                                                                                        itemSize:CGSizeMake(180, 180)
                                                                              minimumLineSpacing:0];
}
/*

 */

- (void)configureDataSource {
    self.dataSource = peripheralsArr;
}

- (void)configurePageControl {
    self.pageControl.numberOfPages = self.dataSource.count;
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
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell =
    (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell"
                                                                    forIndexPath:indexPath];
    cell.layer.cornerRadius=90;
    cell.layer.borderWidth= 5.0;
    cell.layer.borderColor = [PBUtility colorFromHexString:APP_COLOR].CGColor;
    
    CBPeripheral *toy = self.dataSource[indexPath.row];
    if ([toy.name isEqualToString:@"MLT-BT05"]) {
        cell.pageLabel.text = @"KLYA-WHITE";
    }else if([toy.name isEqualToString:@"BT05"]){
      cell.pageLabel.text = @"KLYA-PINK";
    }else{
      cell.pageLabel.text = toy.name;
    }
   // cell.pageLabel.text = toy.name;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.isDragging || collectionView.isDecelerating || collectionView.isTracking) return;
    
    NSUInteger selectedPage = indexPath.row;
    
    if (selectedPage == self.pageControl.currentPage) { 
        selectedPeripheral = [self.dataSource objectAtIndex:indexPath.row];
        NSLog(@"selected Piggy ---->>> %@",selectedPeripheral.name);
        [self startActivityIndicator:YES];
        [bleManager connectToPeropheral:selectedPeripheral];
    }
    else {
        [self scrollToPage:selectedPage animated:YES];
    }
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (--self.animationsCount > 0) return;
    self.collectionView.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = self.contentOffset / self.pageWidth;
}

#pragma mark - Convenience

- (CGFloat)pageWidth {
    return self.collectionViewLayout.itemSize.width + self.collectionViewLayout.minimumLineSpacing;
}

- (CGFloat)contentOffset {
    return self.collectionView.contentOffset.x + self.collectionView.contentInset.left;
}


- (void)showProgressViewWithTitle:(NSString*)title
{
    //self.progressView.progress = 1.0;
    progressBar.progress = 1.0;
    progressStart = CACurrentMediaTime();
    if ([self.cameFrom isEqualToString:@"update"]) {
        progressCount = 26;
    }
//    else if ([self.cameFrom isEqualToString:@"disconnect"]) {
//        progressCount = 28;
//    }
    else{
        progressCount = 28;
    }
    
    
    bgProgressView =[[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, (self.view.frame.size.height/2)-130, 200, 60)];
    bgProgressView.backgroundColor = [UIColor whiteColor];
    //[[PBUtility colorFromHexString:APP_COLOR] colorWithAlphaComponent:0.5];
    bgProgressView.layer.cornerRadius = 5.0;
    [self.view addSubview:bgProgressView];
    
    timerrLbl = [[UILabel alloc] initWithFrame:CGRectMake((bgProgressView.frame.size.width/2)-90, 10, 180, 25)];
    timerrLbl.textAlignment = NSTextAlignmentCenter;
    timerrLbl.text = [NSString stringWithFormat:@"%@ 0%%",title];
    timerrLbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
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
    count++;
    // int progressTime = 14;
    float totalTime = (float)progressCount;
    if (count <= progressCount)
    {
        float current = (float)count;
        if ([self.cameFrom isEqualToString:@"update"]) {
            timerrLbl.text = [NSString stringWithFormat:@"Syncing KLYA %.f%%",(current/totalTime)*100];
        }else if ([self.cameFrom isEqualToString:@"reset"]){
           timerrLbl.text = [NSString stringWithFormat:@"Resetting KLYA %.f%%",(current/totalTime)*100];
        }
        else{
            timerrLbl.text = [NSString stringWithFormat:@"Disconnecting KLYA %.f%%",(current/totalTime)*100];
        }
        
        progressBar.progress = [[NSString stringWithFormat:@"%.f",(current/totalTime)*100] floatValue]/100;
    } else
    {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}

-(IBAction)backBtnClicked:(id)sender{
    if ([self.cameFrom isEqualToString:@"home"]||[self.cameFrom isEqualToString:@"update"]) {
        [rippleEffect removeFromSuperview];
        //[bleManager disConnectPeripheral];
        [bleManager stopScan];
        // [self stopScan];
        if (selectedPeripheral && self.writeCharacteristic) {
            [self stopActivityIndicator];
            [bleManager sendMessage:[PBMessage transferSpecialCharacter:@"*"] toPiggy:selectedPeripheral withCharacteristics:self.writeCharacteristic];
        }
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [bleManager stopScan];;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        PBHomeViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"PBHomeViewController"];
        [self.navigationController pushViewController:home animated:YES];
    }
}

-(void)showAlertmsgStr:(NSMutableAttributedString*)msgStr{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alert setValue:msgStr forKey:@"attributedTitle"];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   if (alertChk==2) {
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }
                                   
                               }];
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
