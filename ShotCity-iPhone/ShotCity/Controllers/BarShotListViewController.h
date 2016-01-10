//
//  BarShotListViewController.h
//  ShotCity
//
//  Created by dev on 13. 9. 5..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarShotListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, UIAlertViewDelegate>{
    
    NSURLConnection *connection;
    NSMutableData* data;
    
    IBOutlet UITableView *myTableView;
    NSMutableArray *dataList;
    
    IBOutlet UILabel *lbTitle;
    
    IBOutlet UIView *loadingView;
    IBOutlet UIActivityIndicatorView *activityLoading;
    
}
@property (nonatomic, retain) NSDictionary *barItem;

- (IBAction)toggleBack:(id)sender;

@end
