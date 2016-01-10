//
//  NotifyCell.h
//  ShotCity
//
//  Created by dev on 13. 10. 3..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NOTIFY_CELL_TWEET_WIDTH 200
#define NOTIFY_CELL_TWEET_FONT_SIZE 10

@class Image;
@class STTweetLabel;

@interface NotifyCell : UITableViewCell<NSURLConnectionDelegate>{
    
    NSURLConnection *connection;
    NSMutableData* data;
    UIActivityIndicatorView *ai;
    
    IBOutlet Image *imgProfile;
    UIButton *btnProfileImage;
    IBOutlet UILabel *lbUpdatedTime;
    IBOutlet Image *imgShot;
    IBOutlet UITextView *lbText;
    
    UIButton *btnDetail;
    
    UIActionSheet *actionSheet;
}
+ (id)cellWithNib;   ///< 이를 통해서 CustomCell을 반환하게 할 것입니다.
+ (id)cellWithNib:(NSDictionary*)cellInfo;
+ (id)cellWithReuseIdentifier:(NSString*)reuseIdenti;

- (void) initWithShotData:(NSDictionary*)itemData;

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) UIActivityIndicatorView *ai;
@property (nonatomic, retain) NSDictionary *cellData;

@property (nonatomic, retain) IBOutlet Image *imgProfile;
@property (nonatomic, retain) IBOutlet UILabel *lbUpdatedTime;
@property (nonatomic, retain) IBOutlet Image *imgShot;
@property (strong, nonatomic) IBOutlet STTweetLabel *tweetLabel;

@property (nonatomic, retain) UIViewController *parentViewController;

- (IBAction)toggleProfile:(id)sender;
- (IBAction)toggleDetail:(id)sender;

+ (NSInteger)getCellHeight:(NSDictionary*)itemData;

@end
