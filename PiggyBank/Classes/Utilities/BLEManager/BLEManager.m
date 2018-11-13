//
//  BLEManager.m
//  PiggyBank
//
//  Created by Nagaraju on 16/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "BLEManager.h"
#import "PBConstants.h"

@interface BLEManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>{
    
}


@end

@implementation BLEManager
@synthesize centralManager;

- (id)init
{
    self = [super init];
    if (self) {
        NSDictionary *options = @{CBCentralManagerOptionShowPowerAlertKey: @false};
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:options];
    }
    return self;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
//    if (central.state == CBManagerStatePoweredOff) {
//        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isBluetoothOn"];
//        NSLog(@"+++++++++ble-OFF++++++++++");
//    }else if(central.state == CBManagerStatePoweredOn){
//        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isBluetoothOn"];
//        NSLog(@"+++++++++ble-ON++++++++++");
//    }else{
//       NSLog(@"+++++++++ble-UNKNOWN++++++++++");
//    }
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.serialDelegate serialDidUpdateState];
}

-(void)startScan{
    // @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]
    NSArray *connectedBeanPeripherals = [centralManager retrieveConnectedPeripheralsWithServices:[NSArray arrayWithObjects:[CBUUID UUIDWithString:serviceUUID], nil]];
    NSLog(@"connectedBeanPeripherals -------------->>>> %@",connectedBeanPeripherals);
    
    for (CBPeripheral *peripheral in connectedBeanPeripherals) {
        [self.serialDelegate serialDidDiscover:peripheral RSSI:nil];
    }
    
    //@[[CBUUID UUIDWithString:serviceUUID]]
    [centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:serviceUUID]]
                                           options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    NSLog(@"Scanning started -------------- >>>>");
}

-(void)stopScan{
    [centralManager stopScan];
}

-(void)connectToPeropheral:(CBPeripheral *)peripheral{
    
    [centralManager connectPeripheral:peripheral options:nil];
}

-(void)disConnectPeripheral
{
    if (self.discoveredPeripheral) {
         NSLog(@"<<<<-------------- Kamatham Disconnected -------------->>>>");
        [centralManager cancelPeripheralConnection:self.discoveredPeripheral];
    }else{
        NSLog(@"<<<<-------------- Kamatham Not Avilable -------------->>>>");
    }
}

-(void)disConnectPeripheral:(CBPeripheral*)iPeripheral{
    if (iPeripheral) {
        NSLog(@"<<<<-------------- Kamatham Disconnected -------------->>>>");
        [centralManager cancelPeripheralConnection:iPeripheral];
    }else{
        NSLog(@"<<<<-------------- Kamatham Not Avilable -------------->>>>");
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)iPeripheral advertisementData:(NSDictionary *)iAdvertisementData RSSI:(NSNumber *)iRSSI
{
    //NSLog(@"iPeripheral Discovered ------->>>> %@",iPeripheral);
    [self.serialDelegate serialDidDiscover:iPeripheral RSSI:iRSSI];
}

- (void)centralManager:(CBCentralManager *)iCentral didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"********* iPeripheral Connected *********");
    self.discoveredPeripheral = peripheral;
    self.discoveredPeripheral.delegate=self;
    [self.serialDelegate serialDidConnect:peripheral];
    NSArray *services = [NSArray arrayWithObjects:[CBUUID UUIDWithString:serviceUUID], nil];
    [peripheral discoverServices:services];
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    [self.serialDelegate serialDidFailToConnect:peripheral error:error];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error{
    NSLog(@"********* iPeripheral Dis-connected *********");
    if (error) {
        NSLog(@"errorrr --------->>>> %@",error.localizedDescription);
    }
    [self.serialDelegate serialDiddisConnect:peripheral error:error];
}

// MARK: CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)iPeripheral didDiscoverServices:(NSError *)iError {
    if (iError) {
        NSLog(@"Error DiscoverServices ------>>> %@",iError.localizedDescription);
        return;
    }
    // Loop through the newly filled peripheral.services array, just in case there's more than one.
    for (CBService *service in iPeripheral.services) {
        NSArray *characteristics = [NSArray arrayWithObjects:[CBUUID UUIDWithString:characteristicUUID], nil];
        [iPeripheral discoverCharacteristics:characteristics forService:service];
    }
}

// Write the data into peripheral's characterstics
- (void)peripheral:(CBPeripheral *)iPeripheral didDiscoverCharacteristicsForService:(CBService *)iService error:(NSError *)iError {
    if (iError) {
        NSLog(@"Error DiscoverCharacteristics ------>>> %@",iError.localizedDescription);
        return;
    }
    

    
    // Find out the writable characterstics
    for (CBCharacteristic *characteristic in iService.characteristics) {
         NSLog(@"CBcharacteristic description --------->>>> %@",characteristic.UUID);
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:characteristicUUID]]) {
             NSLog(@"____________DEVICE READY___________");
            self.writeCharacteristics = characteristic;
            [self.serialDelegate serialDidDiscoverCharacteristic:characteristic peripheral:iPeripheral];
        }

    }
}

- (void)peripheral:(CBPeripheral *)peripheral
 didModifyServices:(NSArray<CBService *> *)invalidatedServices{
    NSLog(@"didModifyServices ------>>>>> %@",[invalidatedServices objectAtIndex:0]);
}

-(void)sendMessage:(NSString*)msg toPiggy:(CBPeripheral*)piggy withCharacteristics:(CBCharacteristic*)characteristics
{
    NSData *dataToSend = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"sent message ---->>> %@",msg);
    NSLog(@"data length ------>>>> %lu",(unsigned long)dataToSend.length);
    NSLog(@"discovered Peripheral ---->>> %@",piggy);
    NSLog(@"writeCharacteristics ---->>> %@",characteristics);
    [piggy writeValue:dataToSend forCharacteristic:characteristics type:CBCharacteristicWriteWithResponse];
    
    // [self.centralManager cancelPeripheralConnection:piggy];
}

//-(void)disConnectDevice:(CBPeripheral*)peripheral withCharacteristics:(CBCharacteristic*)characteristics {
//    
//    [peripheral writeValue:nil forCharacteristic:characteristics type:CBCharacteristicWriteWithoutResponse];
//}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        NSLog(@"Error reading characteristics: %@", [error localizedDescription]);
        return;
    }
    NSString *myString = [[NSString alloc] initWithData:characteristic.value encoding:NSASCIIStringEncoding];
    NSLog(@"RECIVED STRING ------>>>> %@",myString);
    if (characteristic.value != nil) {
        //value here.
       // [self.serialDelegate serialDidRecivedString:characteristic.value];
    }
}
@end
