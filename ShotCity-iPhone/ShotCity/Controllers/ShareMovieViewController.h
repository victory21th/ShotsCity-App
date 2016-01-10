//
//  ShareMovieViewController.h
//  ShotsCity
//
//  Created by dev on 13. 11. 20..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIPlaceHolderTextView;
@class SearchUserListViewController;
@class SearchBarViewController;

@interface ShareMovieViewController : UIViewController<NSURLConnectionDelegate>{
    NSURLConnection *connection;
    NSMutableData* data;
    
    IBOutlet UIImageView *myImageView;
    IBOutlet UIPlaceHolderTextView *commentTextView;
    
    SearchUserListViewController *searchUserListViewController;
    SearchBarViewController *searchBarViewController;
    
    IBOutlet UISwitch *mySwitch;
    IBOutlet UIView *viewBarSection;
    IBOutlet UIButton *btnSelectBar;
    NSDictionary *selectedBar;
    
    IBOutlet UIView *viewShareSection;
    
    IBOutlet UIButton *btnFacebook;
    IBOutlet UIButton *btnTwitter;
    
    BOOL isFb;
    BOOL isTw;
    IBOutlet UIWebView *myWebView;
    IBOutlet UIActivityIndicatorView *indicationView;
    
    BOOL isSendingShare;
    IBOutlet UIView *loadingView;
    IBOutlet UIActivityIndicatorView *activityLoading;
    
}

- (IBAction)toggleBack:(id)sender;
- (IBAction)toggleShare:(id)sender;

- (IBAction)toggleSelectBar:(id)sender;
- (void) toggleSelectedBar:(id)bardata;
- (IBAction)toggleChangeSwitch:(id)sender;

- (void) appendUserName:(NSString*)username;

- (IBAction)toggleFacebook:(id)sender;
- (IBAction)toggleTwitter:(id)sender;
@end
