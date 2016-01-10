//
//  UserListViewController.h
//  ShotCity
//
//  Created by dev on 13. 8. 22..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate>{
    IBOutlet UITableView *myTableView;
    
    NSURLConnection *connection;
    NSMutableData* data;
    
    NSMutableArray *dataList;
    
    IBOutlet UILabel *lbTitle;
}
@property (nonatomic, retain) NSString *reqString;
@property (nonatomic, retain) NSString *reqType;

- (IBAction)toggleBack:(id)sender;
@end
