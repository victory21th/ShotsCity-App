//
//  CheersViewController.h
//  ShotCity
//
//  Created by dev on 13. 8. 28..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideSwipeTableViewController.h"

@interface CheersViewController : SideSwipeTableViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, UITextFieldDelegate>{
    
    NSURLConnection *connection;
    NSMutableData* data;
    
    IBOutlet UITableView *myTableView;
    
    NSMutableArray *dataList;
    
    IBOutlet UITextField *txtComment;
    IBOutlet UIButton *btnSend;
}

@property (nonatomic, retain) NSDictionary *shotData;

- (IBAction)toggleAddCheer:(id)sender;

- (IBAction)toggleBack:(id)sender;

@end
