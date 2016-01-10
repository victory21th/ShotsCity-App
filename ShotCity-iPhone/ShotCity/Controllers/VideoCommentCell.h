//
//  VideoCommentCell.h
//  ShotsCity
//
//  Created by dev on 13. 12. 5..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Image;
@class STTweetLabel;
@class MNetStreamingMovieViewController;

@interface VideoCommentCell : UITableViewCell<NSURLConnectionDelegate>{
    
    NSURLConnection *connection;
    NSMutableData* data;
    UIActivityIndicatorView *ai;
    
    IBOutlet Image *imgProfile;
    UIButton *btnProfileImage;
    IBOutlet UILabel *lbName;
    IBOutlet UIButton *btnName;
    IBOutlet UIButton *lbUpdatedTime;
    IBOutlet Image *imgShot;
    
    UIButton *btnCheers;
    UIButton *btnComments;
    UIButton *btnAddCheer;
    UIButton *btnAddComment;
    UIButton *btnDetail;
    
    UIActionSheet *actionSheet;
    
    //play button
    UIButton *btnPlayMovie;
    MNetStreamingMovieViewController *cvChannelViewController;
    
}
+ (id)cellWithNib;   ///< 이를 통해서 CustomCell을 반환하게 할 것입니다.
+ (id)cellWithNib:(NSDictionary*)cellInfo;
+ (id)cellWithReuseIdentifier:(NSString*)reuseIdenti;

- (void) initWithShotData:(NSDictionary*)itemData;

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) UIActivityIndicatorView *ai;
@property (nonatomic, retain) NSDictionary *shotData;

@property (nonatomic, retain) IBOutlet Image *imgProfile;
@property (nonatomic, retain) IBOutlet UILabel *lbName;
@property (nonatomic, retain) IBOutlet UIButton *btnName;
@property (nonatomic, retain) IBOutlet UIButton *lbUpdatedTime;
@property (nonatomic, retain) IBOutlet Image *imgShot;
@property (nonatomic, retain) UIViewController *parentViewController;
@property (strong, nonatomic) IBOutlet STTweetLabel *tweetLabel;

- (IBAction)toggleProfile:(id)sender;
- (IBAction)toggleCheer:(id)sender;
- (IBAction)toggleComment:(id)sender;
- (IBAction)toggleAddCheer:(id)sender;
- (IBAction)toggleAddComment:(id)sender;
- (IBAction)toggleDetail:(id)sender;
- (IBAction)toggleDeleteComment:(id)sender;

+ (NSInteger)getCellHeight:(NSDictionary*)itemData;

@end

