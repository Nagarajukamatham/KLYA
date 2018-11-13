//
//  BLEManager.h
//  PiggyBank
//
//  Created by Nagaraju on 16/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BLESerialDelegate;

@interface BLEManager : NSObject

@property (strong, nonatomic) CBCentralManager      *centralManager;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic      *writeCharacteristics;

@property (nonatomic, assign) id<BLESerialDelegate> serialDelegate;

-(void)startScan;
-(void)stopScan;
-(void)connectToPeropheral:(CBPeripheral *)peripheral;
-(void)disConnectPeripheral;
-(void)disConnectPeripheral:(CBPeripheral*)iPeripheral;
-(void)sendMessage:(NSString*)msg toPiggy:(CBPeripheral*)piggy withCharacteristics:(CBCharacteristic*)characteristics;
@end

@protocol BLESerialDelegate <NSObject>

@optional
-(void)serialDidUpdateState;
-(void)serialDidDiscover:(CBPeripheral *)peripheral RSSI:(NSNumber *)iRSSI;
-(void)serialDidConnect:(CBPeripheral *)peripheral;
-(void)serialDidFailToConnect:(CBPeripheral *)peripheral error:(NSError*)error;
-(void)serialDiddisConnect:(CBPeripheral *)peripheral error:(NSError*)error;
-(void)serialDidDiscoverCharacteristic:(CBCharacteristic *)iCharacteristic peripheral:(CBPeripheral *)peripheral;
//-(void)serialDidRecivedString:(NSString*)string;
@end
