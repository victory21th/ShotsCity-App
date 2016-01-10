//
//  AppDelegate.h
//  ShotCity
//
//  Created by dev on 13. 8. 18..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TabBar_Height 51

@class UserModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>{
    UIImage *tempImage;
    
    NSString *notifiable_id;
    NSString *notifiable_type;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UserModel *userInfo;
@property (nonatomic, retain) UIImage *tempImage;

- (void)showLoginViewController;
- (void) loginPro;

- (void)goUserSearchView:(NSString*)userName viewController:(UIViewController*)viewController;
- (void)goHashTagView:(NSString *)hashTag viewController:(UIViewController*)viewController;
- (void)goShotView:(NSString*)shotid;

+ (void)setNotificationBadge:(NSString*)badgeValue;

+ (UIStoryboard*) getStoryboard;
@end
