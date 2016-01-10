//
//  SearchBarViewController.h
//  ShotCity
//
//  Created by dev on 13. 9. 6..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SearchBarViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>{
    
    NSURLConnection *connection;
    NSMutableData* data;
    
    IBOutlet UITableView *myTableView;
    NSMutableArray *dataList;
    
    IBOutlet UIView *loadingView;
    IBOutlet UIActivityIndicatorView *activityLoading;
    
    CLLocationManager *locationManager;
	//CLLocation *currentLocation;
	
	BOOL isSendingRequest;
}
@property (nonatomic, retain) UIViewController *targetViewController;
@property (nonatomic, retain) 	CLLocation *currentLocation;

- (IBAction)toggleReload:(id)sender;
- (IBAction)toggleBack:(id)sender;

@end
