//
//  NotifyListViewController.h
//  ShotCity
//
//  Created by dev on 13. 10. 3..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifyListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate>{
    IBOutlet UITableView *myTableView;
    
    NSMutableArray *dataList;
    
    NSURLConnection *connection;
    NSMutableData* data;
    
    IBOutlet UIView *loadingView;
    IBOutlet UIActivityIndicatorView *activityLoading;
    
}

- (IBAction)toggleBack:(id)sender;
- (IBAction)toggleReload:(id)sender;
@end
