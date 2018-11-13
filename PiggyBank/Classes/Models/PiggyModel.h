//
//  PiggyModel.h
//  PiggyBank
//
//  Created by Nagaraju on 29/01/1940 Saka.
//  Copyright © 1940 Saka Nagaraju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PiggyModel : NSObject

@property(nonatomic,retain) NSString  *deviceId;
@property(nonatomic,retain) NSString  *deviceName;
@property(nonatomic,assign) BOOL piggyAttached;
@property(nonatomic,retain) NSString  *piggyLastConnectedDateAndTime;
@property(nonatomic,retain) NSString  *piggyName;


@property(nonatomic,assign) NSString  *goalAmount;
@property(nonatomic,assign) BOOL goalCreated;
@property(nonatomic,retain) NSString  *goalCreatedDate;
@property(nonatomic,retain) NSString  *goalDate;
@property(nonatomic,retain) NSString  *goalName;
@property(nonatomic,retain) NSString  *goalStatus;

/*
 "deviceId": "2ACE51CB-D4D6-8F7A-B182-2BA3D73731F0",
 "deviceName": "MLT-BT05",
 "piggyAttached": true,
 "piggyLastConnectedDateAndTime": "04/04/2018 14:46",
 "piggyName": "Leroy2"
 
 "goalAmount": "25",
 "goalCreated": true,
 "goalCreatedDate": "04/04/2018 14:46",
 "goalDate": "05/04/2018 14:46",
 "goalName": "Video game",
 "goalStatus": "0",
 
 */
@end
