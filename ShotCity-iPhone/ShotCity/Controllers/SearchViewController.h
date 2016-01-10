//
//  SearchViewController.h
//  ShotCity
//
//  Created by dev on 13. 8. 19..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloaderPhotos.h"

@interface SearchViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, NSURLConnectionDelegate>{
    
    NSURLConnection *connection;
    NSMutableData* data;
    
    IBOutlet UICollectionView *myCollectionView;
    
    NSMutableDictionary *imageDownloadsInProgress;
    
    NSMutableArray *dataList;
    
    IBOutlet UITextField *lbSearch;
    
    IBOutlet UIView *loadingView;
    IBOutlet UIActivityIndicatorView *activityLoading;
    
    
}
@property (nonatomic, retain) NSString *searchString;

- (IBAction)searchUser:(id)sender;

- (void)searchUserWithUserName:(NSString*)username;

@end
