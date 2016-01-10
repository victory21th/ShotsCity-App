//
//  SearchLocViewController.h
//  ShotCity
//
//  Created by dev on 13. 10. 15..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SearchLocViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, NSURLConnectionDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>{
    
    NSURLConnection *connection;
    NSMutableData* data;
    
    IBOutlet UICollectionView *myCollectionView;
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
    
    //top section
    IBOutlet UIView *viewTopSection;
    IBOutlet UIButton *btnGrid;
    IBOutlet UIButton *btnList;
    IBOutlet UILabel *lbDataCount;
    IBOutlet UIView *viewGrid;
    IBOutlet UIView *viewList;
    BOOL showType;//false : list, true: grid
    
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

- (IBAction)toggleGridShow:(id)sender;
- (IBAction)toggleListShow:(id)sender;

- (IBAction)toggleHashtag:(id)sender;
- (IBAction)toggleBar:(id)sender;

- (void) requestNearby;
- (void) requestSearchShots;
@end
