
//
//  AppDelegate.m
//  ShotCity
//
//  Created by dev on 13. 8. 18..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "UserModel.h"
#import "MainTabBarController.h"
#import "ADVTheme.h"
#import "ADVFitpulseTheme.h"
#import "SearchViewController.h"
#import "TagUserGetController.h"
#import "HashTagViewController.h"
#import "AppSharedData.h"
#import "ShotDetailViewController.h"
#import "TestFlight.h"

@implementation AppDelegate
@synthesize userInfo, tempImage;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Testflight Install
    [TestFlight takeOff:@"37bc58db-ad9f-4055-a9fd-47a6f93792f0"];
    
	//어플이 시작할때 //APNS에 장치등록 부분과 //Badge개수설정 을 추가했다.
	//[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	
	// APNS에 디바이스를 등록한다.
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
	 UIRemoteNotificationTypeAlert|
	 UIRemoteNotificationTypeBadge|
	 UIRemoteNotificationTypeSound];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"update_list"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.userInfo = [[UserModel alloc] init];
    
    UIStoryboard* mainStoryBoard = [AppDelegate getStoryboard];
    //self.initialViewController = [mainStoryBoard instantiateInitialViewController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [mainStoryBoard instantiateInitialViewController];
    [self.window makeKeyAndVisible];
    
    
    [self applicationInitialize];
    
    return YES;
}
+ (UIStoryboard*) getStoryboard {
    UIStoryboard *storyBoard = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    }else{
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
            // The iOS device = iPhone or iPod Touch
            CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
            if (iOSDeviceScreenSize.height == 480){
                // iPhone 3/4x
                storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone_4" bundle:nil];
                
            }else if (iOSDeviceScreenSize.height == 568){
                // iPhone 5 etc
                storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
            }
        }
    }
    
    //ASSERT(storyBoard);
    return storyBoard;
}

-(void)initializeStoryBoardBasedOnScreenSize {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {   // iPhone 3GS, 4, and 4S and iPod Touch 3rd and 4th generation: 3.5 inch screen (diagonally measured)
            
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone35
            UIStoryboard *iPhone35Storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone_4" bundle:nil];
            
            // Instantiate the initial view controller object from the storyboard
            UIViewController *initialViewController = [iPhone35Storyboard instantiateInitialViewController];
            
            // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            // Set the initial view controller to be the root view controller of the window object
            self.window.rootViewController  = initialViewController;
            
            // Set the window object to be the key window and show it
            [self.window makeKeyAndVisible];
        }
        
        if (iOSDeviceScreenSize.height == 568)
        {   // iPhone 5 and iPod Touch 5th generation: 4 inch screen (diagonally measured)
            
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
            UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
            
            // Instantiate the initial view controller object from the storyboard
            UIViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
            
            // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            // Set the initial view controller to be the root view controller of the window object
            self.window.rootViewController  = initialViewController;
            
            // Set the window object to be the key window and show it
            [self.window makeKeyAndVisible];
        }
        
    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        
    {   // The iOS device = iPad
        
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application	{
    [AppDelegate setNotificationBadge:[NSString stringWithFormat:@"%d",[[UIApplication sharedApplication] applicationIconBadgeNumber]]];
}

- (void)showLoginViewController{
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    LoginViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kLoginViewController"];
    
    MainTabBarController *tabBarController = (MainTabBarController*)self.window.rootViewController;
    
//    [tabBarController.selectedViewController presentModalViewController:VC animated:NO];
    [tabBarController.selectedViewController presentViewController:VC animated:YES completion:nil];
}

- (void)goUserSearchView:(NSString *)userName viewController:(UIViewController*)viewController{
/*    MainTabBarController *tabBarController = (MainTabBarController*)self.window.rootViewController;
    
    [tabBarController setSelectedIndex:3];
    
    UINavigationController *NVC = [[tabBarController viewControllers] objectAtIndex:3];
    [NVC popToRootViewControllerAnimated:NO];
    SearchViewController *searchViewController = (SearchViewController*)[[NVC viewControllers] objectAtIndex:0];
    [searchViewController searchUserWithUserName:userName];*/
    
    TagUserGetController *controller = [[TagUserGetController alloc] init];
    [controller goTagUserProfileView:userName viewController:viewController];
}


- (void)goHashTagView:(NSString *)hashTag viewController:(UIViewController*)viewController{
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    HashTagViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kHashTagViewController"];
    [VC setHashTag:hashTag];
    [viewController.navigationController pushViewController:VC animated:YES];
}

- (void)applicationInitialize{
    
    [ADVThemeManager customizeAppAppearance];
    UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
    
    NSArray *items = tabVC.tabBar.items;
    for (int idx = 0; idx < items.count; idx++) {
        UITabBarItem *item = [items objectAtIndex:idx];
        [ADVThemeManager customizeTabBarItem:item forTab:((SSThemeTab)idx)];
    }
    
}

- (void) loginPro{
    [self uploadPushToken];
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users/%@?auth_token=%@"
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    
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
                    
                    return;
                }
                
                [[self userInfo] setUserDataWithUserID:[user objectForKey:@"id"]
                                                  userName:[user objectForKey:@"username"]
                                                      Name:[user objectForKey:@"name"]
                                                  imageUrl:[user objectForKey:@"image_url"]
                                                    Gender:[user objectForKey:@"gender"]];
                
                
            }
        }
        // setup the page control
        /// [self setupPageControl];
        ///[gridView reloadData];
        
        //[myTable reloadData];
    }
    
}


/******************************************************/
/******************************************************/
/*************     APNS 애플 푸시 섹션     ***************/
/******************************************************/
/******************************************************/
//push : APNS 에 장치 등록 성공시 자동실행
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	NSLog(@"deviceToken : %@", deviceToken);
	NSString *token1 = [[NSString stringWithFormat:@"%@",deviceToken] stringByReplacingOccurrencesOfString:@"<" withString:@""];
	token1 = [token1 stringByReplacingOccurrencesOfString:@">" withString:@""];
	//	[[MOADBManager sharedInstance] updatePushToken:[NSString stringWithFormat:@"%@",deviceToken]];
	[[AppSharedData sharedInstance] setPush_token:[NSString stringWithFormat:@"%@",token1]];
	[self uploadPushToken];
    
}

//push : APNS 에 장치 등록 오류시 자동실행
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	NSLog(@"deviceToken error : %@", error);
}

//push : 어플 실행중에 알림도착
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo1 {
    
	NSDictionary *aps = [userInfo1 objectForKey:@"aps"];
    
	//NSString *type = [NSString stringWithFormat:@"%@", [userInfo1 objectForKey:@"type"]];
	NSString *msgBody = [NSString stringWithFormat:@"%@", [aps objectForKey:@"alert"]];
	   
    NSString *msg = [NSString stringWithFormat:@"%@", userInfo1];

    NSLog(@"PUSH ALERT: %@, %@ \n Message : %@", [aps objectForKey:@"alert"], [aps objectForKey:@"sound"], msg);
    
    notifiable_id = [userInfo1 objectForKey:@"notifiable_id"];
    notifiable_type = [userInfo1 objectForKey:@"notifiable_type"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msgBody
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    [AppDelegate setNotificationBadge:[NSString stringWithFormat:@"%d",[[UIApplication sharedApplication] applicationIconBadgeNumber]]];
    
}

+ (void)setNotificationBadge:(NSString*)badgeValue{
    if (badgeValue == nil || badgeValue.integerValue <= 0) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        badgeValue = @"0";
        
        [[NSUserDefaults standardUserDefaults] setObject:badgeValue forKey:@"notification_count"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        badgeValue = nil;
    }
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UITabBarItem *tbi = (UITabBarItem*)[[[(MainTabBarController*)delegate.window.rootViewController tabBar] items] objectAtIndex:1];
    
    [tbi setBadgeValue:badgeValue];
    [[NSUserDefaults standardUserDefaults] setObject:badgeValue forKey:@"notification_count"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (NSString*)getNotificationBadge{
    NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"notification_count"];
    
    return data;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *badgeValue = [NSString stringWithFormat:@"%d",[[UIApplication sharedApplication] applicationIconBadgeNumber]];
    if (badgeValue.integerValue > 0) {
        badgeValue = [NSString stringWithFormat:@"%d",[[UIApplication sharedApplication] applicationIconBadgeNumber] - 1];
    }
    [AppDelegate setNotificationBadge:badgeValue];
    
    [self goShotView:notifiable_id];
}

- (void)goShotView:(NSString*)shotid{
    MainTabBarController *tabBarController = (MainTabBarController*)self.window.rootViewController;
    
    UINavigationController *NVC = [[tabBarController viewControllers] objectAtIndex:tabBarController.selectedIndex];
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    ShotDetailViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kShotDetailViewController"];
    //[VC setShotData:[dataList objectAtIndex:indexPath.row]];
    [VC initWithShotID:shotid];
    [NVC pushViewController:VC animated:YES];
    
}
/************************************************************/

- (void) uploadPushToken{
    if ([[AppSharedData sharedInstance] push_token] == nil || [[[AppSharedData sharedInstance] push_token] isEqual:@""]) {
        return;
    }
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    
    if (userId == nil || [userId isEqual:@""]) {
        return;
    }
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users/%@?auth_token=%@"
                           , [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]
                           , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
	
    NSString* requestStr = [NSString stringWithFormat:@"device_token=%@", [[AppSharedData sharedInstance] push_token]];
    
    
    NSData *myRequestData = [ NSData dataWithBytes: [ requestStr UTF8String ] length: [ requestStr length ] ];
    
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString:urlString]];
    
    [request setHTTPMethod: @"PUT" ];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: myRequestData ];
    
    
    NSURLResponse *response;
    NSError *err;
    NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    NSString *content = [NSString stringWithUTF8String:[returnData bytes]];
    NSLog(@"ServerRequestResponse::responseData: %@", content);
    
}

@end
