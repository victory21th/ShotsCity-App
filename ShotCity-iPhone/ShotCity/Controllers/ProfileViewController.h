//
//  ProfileViewController.h
//  ShotCity
//
//  Created by dev on 13. 8. 18..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"

@interface ProfileViewController : UIViewController<NSURLConnectionDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSURLConnection *connection;
    NSMutableData* data;
    
    IBOutlet UILabel *lbUserId;
    IBOutlet UILabel *lbUserName;
    IBOutlet UILabel *lbGender;
    IBOutlet Image *ivProfile;
    
    IBOutlet UIButton *btnPhotos;
    IBOutlet UIButton *btnFollowers;
    IBOutlet UIButton *btnFollowings;
    
    IBOutlet UIButton *btnLogout;
    IBOutlet UIButton *btnFollow;
    IBOutlet UIButton *btnUnfollow;
    
    IBOutlet UIButton *btnNotify;
    
    NSDictionary *userData;
    
    IBOutlet UICollectionView *myCollectionView;
    IBOutlet UITableView *myTableView;
    
    NSInteger currentMenuIndex;
    
    NSMutableDictionary *imageDownloadsInProgress;
    
    NSMutableArray *dataList;
    
    IBOutlet UIButton *btnCollection;
    IBOutlet UIButton *btnList;
    IBOutlet UIButton *btnMap;
    IBOutlet UIButton *btnFourth;
    
    IBOutlet UIView *loadingView;
    IBOutlet UIActivityIndicatorView *activityLoading;
    
    BOOL isShotListReq;
    
    BOOL isReloading;
    BOOL isNewUpdate;//
    NSString *lastItemId;
    
}
@property (nonatomic, retain) NSString* userId;

- (IBAction)toggleReload:(id)sender;
- (IBAction)toggleBack:(id)sender;
- (IBAction)toggleLogOut:(id)sender;
- (IBAction)toggleFollow:(id)sender;
- (IBAction)toggleUnfollow:(id)sender;

- (IBAction)toggleNotify:(id)sender;

- (IBAction)toggleFollowers:(id)sender;
- (IBAction)toggleFollowings:(id)sender;

- (IBAction)toggleCollectionView:(id)sender;
- (IBAction)toggleListView:(id)sender;
- (IBAction)toggleMapView:(id)sender;
- (IBAction)toggleFourth:(id)sender;

@end