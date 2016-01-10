//
//  LoginViewController.m
//  ShotCity
//
//  Created by dev on 13. 8. 18..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "LoginViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "UserModel.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [myWebView setHidden:TRUE];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

///
- (void)toggleLoginViaFacebook:(id)sender{
    /*    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users/%@?auth_token=%@"
     , [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]
     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
     */
    NSString *url = @"http://shots-city-api-staging.herokuapp.com/auth/facebook";
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:20.0];
    //[myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [myWebView loadRequest:req];
    
    [myWebView setHidden:FALSE];
}

- (void) loginPro{
    /*[[NSUserDefaults standardUserDefaults] setObject:@"5201f029bd4a82d094000002" forKey:@"user_id"];
     [[NSUserDefaults standardUserDefaults] setObject:@"1d0fd787a589865c2af5ab00bb7e4981bf6f69a6" forKey:@"auth_token"];
     */
    /*[[NSUserDefaults standardUserDefaults] setObject:self.loggedInUser.id forKey:@"user_id"];
     [[NSUserDefaults standardUserDefaults] setObject:[[[FBSession activeSession] accessTokenData] accessToken] forKey:@"auth_token"];
     */
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users/%@?auth_token=%@"
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    // NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding//NSISOLatin1StringEncoding
    //                       allowLossyConversion:NO];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSData *urlData;
    NSURLResponse *theString;
    NSError *error;
    
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&theString error:&error];
    
    if(!urlData) {
        NSString *errorString = @"Can not connect Internet";
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Faild Reuestion" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        
        
    }else {
        NSString *aStr = [[NSString alloc] initWithData:urlData encoding:NSISOLatin1StringEncoding];
        
        NSLog(@"%@", url);
        NSLog(@"%@", aStr);
        
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"location_id"]);
        NSError *error = nil;
        NSData *jsonData = [aStr dataUsingEncoding:NSUTF8StringEncoding];
        
        
        if (jsonData) {
            
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            if (error) {
                NSLog(@"error is %@", [error localizedDescription]);
            }
            
            if (![aStr isEqualToString:@"{ \"error\":\"No User!\"}"]) {
                //userdata = jsonObjects;
                NSDictionary *user = [jsonObjects objectForKey:@"user"];
                
                if (user == nil || [user isEqual:nil]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@""
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [[delegate userInfo] setUserDataWithUserID:[user objectForKey:@"id"]
                                                  userName:[user objectForKey:@"username"]
                                                      Name:[user objectForKey:@"name"]
                                                  imageUrl:[user objectForKey:@"image_url"]
                                                    Gender:[user objectForKey:@"gender"]];
                
                [[NSUserDefaults standardUserDefaults] setObject:[user objectForKey:@"id"] forKey:@"user_id"];
                [[NSUserDefaults standardUserDefaults] setObject:[user objectForKey:@"auth_token"] forKey:@"auth_token"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
                
                ProfileViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kProfileViewController"];
                
                [self.navigationController pushViewController:VC animated:YES];
            }
        }
        // setup the page control
        /// [self setupPageControl];
        ///[gridView reloadData];
        
        //[myTable reloadData];
    }
    
}


///////////////
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [indicationView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [indicationView stopAnimating];
    
    NSString *aStr = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
    
    NSLog(@"%@", aStr);
    NSData *jsonData = [aStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    if (jsonData) {
        
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        if (error) {
            //NSLog(@"error is %@", [error localizedDescription]);
            [myWebView setHidden:FALSE];
            [indicationView stopAnimating];
            
            return;
        }
        
        if (![aStr isEqualToString:@"{ \"error\":\"No User!\"}"]) {
            //userdata = jsonObjects;
            NSDictionary *user = [jsonObjects objectForKey:@"user"];
            
            if (user == nil || [user isEqual:nil]) {
                
                return;
            }
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [[delegate userInfo] setUserDataWithUserID:[user objectForKey:@"id"]
                                              userName:[user objectForKey:@"username"]
                                                  Name:[user objectForKey:@"name"]
                                              imageUrl:[user objectForKey:@"image_url"]
                                                Gender:[user objectForKey:@"gender"]];
            
            [[NSUserDefaults standardUserDefaults] setObject:[user objectForKey:@"id"] forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] setObject:[user objectForKey:@"auth_token"] forKey:@"auth_token"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"update_list"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [myWebView setHidden:TRUE];
            
//            [self dismissModalViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES
                                     completion:nil];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [indicationView stopAnimating];
    
    [myWebView setHidden:TRUE];
    
    NSLog(@"%@", error);
}
@end

