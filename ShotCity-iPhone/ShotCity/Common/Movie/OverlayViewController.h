/*
 
  
 
 */

#import <UIKit/UIKit.h>


@interface MyOverlayViewController : UIViewController 
{
@private
	IBOutlet UILabel *moviePlaybackStateText;
	IBOutlet UILabel *movieLoadStateText;
    IBOutlet UIButton *playCloseButton;
    IBOutlet UIButton *playPauseButton;
    IBOutlet UIButton *playFullButton;
    IBOutlet UIButton *btnCloseMovie;
}

@property (nonatomic, retain) IBOutlet UILabel *moviePlaybackStateText;
@property (nonatomic, retain) IBOutlet UILabel *movieLoadStateText;
@property (nonatomic, retain) IBOutlet UIButton *playCloseButton;
@property (nonatomic, retain) IBOutlet UIButton *playPauseButton;
@property (nonatomic, retain) IBOutlet UIButton *playFullButton;

@property (nonatomic, retain) IBOutlet UIButton *btnCloseMovie;

- (void)setPlaybackStateDisplayString:(NSString *)playBackText;
- (void)setLoadStateDisplayString:(NSString *)loadStateText;

- (void)updateView;

@end
