//
//  PBNetworkCall.h
//  PiggyBank
//
//  Created by Nagaraju on 19/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBBaseViewController.h"
@protocol networkDelegate <NSObject>
@optional
-(void)success_response:(id)response;
-(void)failure_error:(NSString*)errStr;
-(void)isExistedUserCheck_response:(id)response;
-(void)success_getresponse:(id)response;
-(void)failure_geterror:(NSString*)errStr;
@end

@interface PBNetworkCall : PBBaseViewController

@property(nonatomic,retain) id <networkDelegate> delegate;
-(void)getserviceCallurlStr:(NSString*)urlStr;
-(void)patchServiceurlStr:(NSString*)urlStr withParamas:(NSDictionary*)params;
-(void)checkExistedUserUrlStr:(NSString*)urlStr;
@end
