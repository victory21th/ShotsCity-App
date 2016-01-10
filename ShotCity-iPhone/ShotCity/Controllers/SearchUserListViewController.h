//
//  SearchUserListViewController.h
//  ShotCity
//
//  Created by dev on 13. 9. 6..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SharePhotoViewController;

@interface SearchUserListViewController : UITableViewController<NSURLConnectionDelegate>{
    
    NSURLConnection *connection;
    NSMutableData* data;
    
    NSMutableArray *dataList;
    NSMutableArray *tempList;
}
@property (nonatomic, retain) SharePhotoViewController *sharePhotoViewController;
@property (nonatomic, retain) NSString *searchString;

- (void) updateSearchList:(NSString*) username;

@end
