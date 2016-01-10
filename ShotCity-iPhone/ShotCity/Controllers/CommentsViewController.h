//
//  CommentsViewController.h
//  ShotCity
//
//  Created by dev on 13. 8. 28..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideSwipeTableViewController.h"

@class Image;
@class SearchUserListViewController;

@interface CommentsViewController : SideSwipeTableViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, UITextFieldDelegate>{
    
    NSURLConnection *connection;
    NSMutableData* data;
    
    IBOutlet UITableView *myTableView;
    
    NSMutableArray *commentList;
    
    IBOutlet UIView *viewSendArea;
    IBOutlet UITextField *txtComment;
    IBOutlet UIButton *btnSend;

    SearchUserListViewController *searchUserListViewController;
    
    IBOutlet UIView *loadingView;
    IBOutlet UIActivityIndicatorView *activityLoading;
}
@property (nonatomic, retain) NSDictionary *shotData;
@property (nonatomic, retain)    IBOutlet Image *imgShot;
@property BOOL isEditing;

- (IBAction)toggleAddComment:(id)sender;
- (IBAction)toggleDeleteComment:(id)sender;

- (IBAction)toggleBack:(id)sender;

- (void) appendUserName:(NSString*)username;
@end
