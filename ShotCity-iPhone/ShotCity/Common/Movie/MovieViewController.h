/*



*/

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "AppDelegate.h"
#import "OverlayViewController.h"

//@class MyImageView;

@interface MyMovieViewController : UIViewController 
{
@private
    MPMoviePlayerController *moviePlayerController;
    
    IBOutlet AppDelegate *appDelegate;

//	IBOutlet MyImageView *imageView;
	IBOutlet UIImageView *movieBackgroundImageView;
	IBOutlet UIView *backgroundView;	
	IBOutlet MyOverlayViewController *overlayController;   
    
    UIActivityIndicatorView *aivLoadingView;
    
    
    IBOutlet UIButton *btnCloseMovie;
    
@public
    BOOL bPlaying;

}
@property BOOL bPlaying;

//@property (nonatomic, retain) IBOutlet MyImageView *imageView;
@property (nonatomic, retain) IBOutlet UIImageView *movieBackgroundImageView;
@property (nonatomic, retain) IBOutlet UIView *backgroundView;
@property (nonatomic, retain) IBOutlet MyOverlayViewController *overlayController;

@property (nonatomic, retain) IBOutlet AppDelegate *appDelegate;

@property (retain) MPMoviePlayerController *moviePlayerController;

- (IBAction)overlayViewCloseButtonPress:(id)sender;
- (void)viewWillEnterForeground;
- (void)playMovieFile:(NSURL *)movieFileURL;
- (void)playMovieStream:(NSURL *)movieFileURL;

@end


