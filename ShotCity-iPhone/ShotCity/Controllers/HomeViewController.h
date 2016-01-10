//
//  HomeViewController.h
//  ShotCity
//
//  Created by dev on 13. 8. 20..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate>{
    
    NSURLConnection *connection;
    NSMutableData* data;
    
    IBOutlet UITableView *myTableView;
    NSMutableArray *dataList;
    
    IBOutlet UIView *loadingView;
    IBOutlet UIActivityIndicatorView *activityLoading;
    
    BOOL isReloading;
    BOOL isNewUpdate;//
    NSString *lastItemId;
    
}
- (IBAction)toggleReload:(id)sender;

@end
