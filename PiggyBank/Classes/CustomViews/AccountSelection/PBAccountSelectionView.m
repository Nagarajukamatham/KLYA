//
//  PBAccountSelectionView.m
//  PiggyBank
//
//  Created by Nagaraju on 21/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBAccountSelectionView.h"
#import "PBAccountCellTableViewCell.h"
#import "PBConstants.h"
#import "PBUtility.h"
@implementation PBAccountSelectionView

- (id)init
{
    if(self = [super init]) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame])
    {
        [self setupXIB];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self setupXIB];
    }
    return self;
}

- (void)setupXIB {
    
    self.accountSelectionView = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"PBAccountSelectionView" owner:self options:nil]objectAtIndex:0];
    
    self.accountSelectionView.frame =  self.bounds;
    self.accountSelectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    [self.accountSelectionView setBackgroundColor:[UIColor clearColor]];
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.accountSelectionView];
    UINib *nib = [UINib nibWithNibName:@"PBAccountCellTableViewCell" bundle:nil];
    [self.accountsTableView registerNib:nib forCellReuseIdentifier:@"PBAccountCell"];
    self.accountsTableView.layer.borderColor = [UIColor clearColor].CGColor;
    self.accountsTableView.layer.cornerRadius = 6.0f;
    
    self.contianerView.layer.borderColor = [UIColor clearColor].CGColor;
    self.contianerView.layer.cornerRadius = 6.0f;
    
    self.accountsTableView.tableFooterView = [[UIView alloc] init];
    self.accountsTableView.layer.borderWidth=1;
    self.accountsTableView.layer.borderColor = [PBUtility colorFromHexString:APP_COLOR].CGColor;
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.contianerView.layer.borderColor = [UIColor clearColor].CGColor;
    self.contianerView.layer.cornerRadius = 6.0f;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.contianerView.bounds];
    self.contianerView.layer.masksToBounds = NO;
    self.contianerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contianerView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.contianerView.layer.shadowOpacity = 0.5f;
    self.contianerView.layer.shadowPath = shadowPath.CGPath;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.accountsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    PBAccountCellTableViewCell *accountCell = (PBAccountCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PBAccountCell"];
    //[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    if (indexPath.row == 0) {
        accountCell.backgroundColor = UIColorFromRGB(0xB8D028);
    }
    else{
        accountCell.backgroundColor = [UIColor whiteColor];
    }
    NSDictionary *account = [self.accountsArray objectAtIndex:indexPath.row];
    accountCell.accountNumber.text = [account objectForKey:@"account"];
    accountCell.balance.text = [account objectForKey:@"balance"];
    //[NSString stringWithFormat:@"%@ %@",[HDUtility formattedStringWithDecimal:account.amount], account.currency];
    
    cell = accountCell;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *account = [self.accountsArray objectAtIndex:indexPath.row];
    [self.accountSelectionDelegate didSelectAccount:account withIndex:indexPath.row selectionView:self];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 1.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // To "clear" the footer view
    return [UIView new] ;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<=0) {
        scrollView.contentOffset = CGPointZero;
    }
}

@end
