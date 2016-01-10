//
//  VideoCommentsViewController.h
//  ShotsCity
//
//  Created by dev on 13. 12. 3..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCommentsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate>{
    
    NSURLConnection *connection;
    NSMutableData* data;
    
    IBOutlet UITableView *myTableView;
    NSMutableArray *dataList;
    
    IBOutlet UIButton *btnAddComment;
    
    IBOutlet UIView *loadingView;
    IBOutlet UIActivityIndicatorView *activityLoading;
    
    BOOL isReloading;
    BOOL isNewUpdate;//
    NSString *lastItemId;
    
}
@property (nonatomic, retain) NSDictionary *shotData;
@property BOOL isEditing;

- (IBAction)toggleReload:(id)sender;
- (IBAction)toggleBack:(id)sender;
- (IBAction)toggleAddComment:(id)sender;

@end
