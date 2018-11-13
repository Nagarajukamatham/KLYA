//
//  PBNetworkCall.m
//  PiggyBank
//
//  Created by Nagaraju on 19/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "PBNetworkCall.h"
#import "PBConstants.h"

@interface PBNetworkCall ()

@end

@implementation PBNetworkCall
@synthesize delegate;

-(void)getserviceCallurlStr:(NSString*)urlStr{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",kmain_url_prefix,urlStr,kmain_url_postfix];
    NSLog(@"urlString ---->> %@",urlString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [delegate failure_error:[error localizedDescription]];
        }else{
            NSInteger respCode = [(NSHTTPURLResponse*)response statusCode];
            NSLog(@"respCode ---->>>> %ld",(long)respCode);
            if (respCode==200) {
                NSError *parserErr;
                id respDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parserErr];
                NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                if (respDict) {
                    [delegate success_getresponse:respDict];
                }else if ([responseStr isEqual:[NSNull null]] || [responseStr isEqualToString:@"null"]){
                    // NSLog(@"null ------>>> ");
                    [delegate isExistedUserCheck_response:@"null"];
                }
                else{
                    [delegate failure_geterror:[parserErr localizedDescription]];
                }
            }
            else if(respCode==503){
                [delegate failure_error:[NSString stringWithFormat:@"Server is under constructing, Please try again after sometime"]];
            }
            else{
                [delegate failure_error:[NSString stringWithFormat:@"Server not working, with response code : %ld",(long)respCode]];
            }
        }
    }];
    [task resume];
}

-(void)patchServiceurlStr:(NSString*)urlStr withParamas:(NSDictionary*)params{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",kmain_url_prefix,urlStr,kmain_url_postfix];
    NSLog(@"urlString ---->> %@",urlString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    if (params != NULL) {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
        [request setHTTPBody:postData];
    }
    [request setHTTPMethod:@"PATCH"];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [delegate failure_error:[error localizedDescription]];
        }else{
            NSInteger respCode = [(NSHTTPURLResponse*)response statusCode];
            NSLog(@"respCode ---->>>> %ld",(long)respCode);
            if (respCode==200) {
                NSError *parserErr;
                id respDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parserErr];
                if (respDict) {
                    [delegate success_response:respDict];
                }else{
                    [delegate failure_error:[parserErr localizedDescription]];
                }
            }
            else if(respCode==503){
                [delegate failure_error:[NSString stringWithFormat:@"Server is under constructing, Please try again after sometime"]];
            }
            else{
                [delegate failure_error:[NSString stringWithFormat:@"Server not working, with response code : %ld",(long)respCode]];
            }
        }
    }];
    [task resume];
}

-(void)checkExistedUserUrlStr:(NSString*)urlStr{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",kmain_url_prefix,urlStr,kmain_url_postfix];
    NSLog(@"urlString ---->> %@",urlString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [request setHTTPMethod:@"GET"];
    //[self startActivityIndicator:YES];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //[self stopActivityIndicator];
        NSInteger respCode = [(NSHTTPURLResponse*)response statusCode];
        NSLog(@"respCode ---->>>> %ld",(long)respCode);
        if (respCode==200) {
            NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            if ([responseStr isEqual:[NSNull null]] || [responseStr isEqualToString:@"null"]){
                // NSLog(@"null ------>>> ");
                [delegate isExistedUserCheck_response:@"null"];
            }else{
                // NSLog(@"data------>>> ");
                [delegate isExistedUserCheck_response:responseStr];
            }
        }else{
            [delegate failure_error:[error localizedDescription]];
        }

    }];
    [task resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
