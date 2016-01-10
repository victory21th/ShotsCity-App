//
//  BarViewController.h
//  ShotCity
//
//  Created by dev on 13. 8. 21..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BarViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, CLLocationManagerDelegate>{
    
    NSURLConnection *connection;
    NSMutableData* data;
    
    IBOutlet UITableView *myTableView;
    NSMutableArray *dataList;
    
    IBOutlet UIView *loadingView;
    IBOutlet UIActivityIndicatorView *activityLoading;
    
    CLLocationManager *locationManager;
	CLLocation *currentLocation;
	
	BOOL isSendingRequest;
}


@end
