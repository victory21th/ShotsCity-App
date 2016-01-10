//
//  TagUserGetController.m
//  ShotCity
//
//  Created by dev on 13. 9. 5..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import "TagUserGetController.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"

@interface TagUserGetController ()

@end

@implementation TagUserGetController

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)goTagUserProfileView:(NSString *)username viewController:(UIViewController*)viewControloler{
    self.viewController = viewControloler;
    self.userName = username;
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users?auth_token=%@&username=%@"
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
                     , username];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    
    data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    NSLog(@"%@", url);
    
}

- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    if (data==nil) data = [[NSMutableData alloc] initWithCapacity:2048];
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection
{
    if(!data) {
        
        
    }else {
        NSString *aStr = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        
        NSLog(@"%@", aStr);
        
        NSError *error = nil;
        NSData *jsonData = [aStr dataUsingEncoding:NSUTF8StringEncoding];
                
        if (jsonData) {
            
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            if (error) {
                NSLog(@"error is %@", [error localizedDescription]);
            }
            
            if (![aStr isEqualToString:@"{ \"error\":\"No User!\"}"]) {
                //userdata = jsonObjects;
                NSArray *users = [jsonObjects objectForKey:@"users"];
                if (users == nil || [users count] == 0) {
                    return;
                }
                UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
                
                ProfileViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kProfileViewController"];
                [VC setUserId:[[users objectAtIndex:0] objectForKey:@"id"]];
                [self.viewController.navigationController pushViewController:VC animated:YES];
            }
        }
    }
}

@end
