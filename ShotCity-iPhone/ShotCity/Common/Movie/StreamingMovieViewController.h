/*
 

 */

#import <UIKit/UIKit.h>
#import "MovieViewController.h"

@interface MNetStreamingMovieViewController : MyMovieViewController {
@private
	IBOutlet UITextField *movieURLTextField;
@public
//    BOOL bPlaying;
    BOOL bMovieFullMode;
    CGRect rtViewNormalFrame;
    CGRect rtMovieNormalFrame;
    
    NSString *strMovieUrl;
}
//@property BOOL bPlaying;
@property BOOL bMovieFullMode;
@property (nonatomic, retain) IBOutlet UITextField *movieURLTextField;
@property (nonatomic, retain) NSString *strMovieUrl;

-(IBAction)playStreamingMovieButtonPressed:(id)sender;
-(IBAction)playLocalMovieButtonPressed:(id)sender;
-(IBAction)onClickPlayCloseButton:(id)sender;
-(IBAction)onClickPauseButton:(id)sender;
-(IBAction)onClickFullButton:(id)sender;

- (void)startPlay;
- (void)stopPlay;

@end
