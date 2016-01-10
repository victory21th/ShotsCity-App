//
//  HashTagViewController.h
//  ShotCity
//
//  Created by dev on 13. 9. 26..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HashTagViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate>{
    
    NSURLConnection *connection;
    NSMutableData* data;
    
    IBOutlet UITableView *myTableView;
    NSMutableArray *dataList;
    
    IBOutlet UIView *loadingView;
    IBOutlet UIActivityIndicatorView *activityLoading;
    
    IBOutlet UILabel *lbTitle;
}
- (IBAction)toggleReload:(id)sender;
@property (nonatomic, retain) NSString *hashTag;

- (IBAction)toggleBack:(id)sender;
@end
