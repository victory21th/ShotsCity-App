//
//  ShotDetailViewController.h
//  ShotCity
//
//  Created by dev on 13. 8. 27..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Image;
@class STTweetLabel;
@class MNetStreamingMovieViewController;

@interface ShotDetailViewController : UIViewController<NSURLConnectionDelegate>{
    
    NSURLConnection *connection;
    NSMutableData* data;
    
    IBOutlet UIScrollView *myScrollView;
    IBOutlet Image *imgProfile;
    IBOutlet UIButton *btnProfileImage;
    IBOutlet UILabel *lbName;
    IBOutlet UIButton *btnName;
    IBOutlet UIButton *lbUpdatedTime;
    IBOutlet Image *imgShot;
    IBOutlet UITextView *lbText;
    
    UIButton *btnLocation;
    UIButton *btnCheers;
    UIButton *btnComments;
    UIButton *btnAddCheer;
    UIButton *btnAddComment;
    UIButton *btnDetail;
    
    UIActionSheet *actionSheet;
    
    IBOutlet UIView *loadingView;
    IBOutlet UIActivityIndicatorView *activityLoading;
    
    //play button
    UIButton *btnPlayMovie;
    MNetStreamingMovieViewController *cvChannelViewController;
    
}
- (void) initWithShotData:(NSDictionary*)itemData;
- (void) initWithShotID:(NSString*)shotid;

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) NSDictionary *shotData;

@property (strong, nonatomic) IBOutlet STTweetLabel *tweetLabel;

- (IBAction)toggleProfile:(id)sender;
- (IBAction)toggleBack:(id)sender;

- (IBAction)toggleCheer:(id)sender;
- (IBAction)toggleComment:(id)sender;
- (IBAction)toggleAddCheer:(id)sender;
- (IBAction)toggleAddComment:(id)sender;
- (IBAction)toggleDetail:(id)sender;

@end
