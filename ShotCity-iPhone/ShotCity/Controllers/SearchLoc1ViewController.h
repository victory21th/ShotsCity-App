//
//  SearchLoc1ViewController.h
//  ShotsCity
//
//  Created by dev on 13. 10. 30..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SearchLoc1ViewController : UIViewController<NSURLConnectionDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>{
    
    NSURLConnection *connection;
    NSMutableData* data;
    
    IBOutlet UITableView *myTableView;
    
    NSMutableArray *dataList;
    
    
    IBOutlet UIView *loadingView;
    IBOutlet UIActivityIndicatorView *activityLoading;
    
    CLLocationManager *locationManager;
	CLLocation *currentLocation;
	
	BOOL isSendingRequest;
    
    BOOL isReloading;
    BOOL isNewUpdate;//
    NSString *lastItemId;
   
    IBOutlet UIView *viewList;
    
    //search section
    IBOutlet UIView *viewSearchSection;
    IBOutlet UIButton *btnHashtag;
    IBOutlet UIButton *btnBar;
    IBOutlet UITextField *txtSearch;
    IBOutlet UIButton *btnSearch;
    NSInteger searchType;//0 : nearby, 1 : bar, 2 : hashtag
    
    BOOL isNotFirstRequest;
}

- (IBAction)toggleReload:(id)sender;
- (IBAction)toggleSearch:(id)sender;
- (IBAction)toggleNearby:(id)sender;

- (IBAction)toggleHashtag:(id)sender;
- (IBAction)toggleBar:(id)sender;

- (void) requestNearby;
- (void) requestSearchShots;
@end
