/*
 
 
 
 */

#import "StreamingMovieViewController.h"

@implementation MNetStreamingMovieViewController

//@synthesize bPlaying;
@synthesize bMovieFullMode;
@synthesize movieURLTextField;
@synthesize strMovieUrl;

-(id)init{
    self = [super init];
    if (self) {
        [[self view] setFrame:CGRectMake(0, 0, 320, 240)];
        [[self view] setBackgroundColor:[UIColor colorWithWhite:1 
                                                          alpha:0.0f]];
        self.overlayController = [[MyOverlayViewController alloc] initWithNibName:@"MNetOverlayViewController"
                                                                      bundle:nil];
        [self.overlayController updateView];
     //   [self.overlayController.btnCloseMovie addTarget:self action:@selector(onClickPlayCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
/*
- (void)dealloc{
    [strMovieUrl release];
    [movieURLTextField release];
    
    [super dealloc];
}*/

/* Handle touches to the 'Play Movie' button. */
-(IBAction)playStreamingMovieButtonPressed:(id)sender
{
	/* Has the user entered a movie URL? */
	if (![self.strMovieUrl isEqual:nil] && ![self.strMovieUrl isEqualToString:@""])
	{
		//NSURL *theMovieURL = [NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];
		NSURL *theMovieURL = [NSURL URLWithString:self.strMovieUrl];
		if (theMovieURL)
		{
			if ([theMovieURL scheme])	// sanity check on the URL
			{
				/* Play the movie with the specified URL. */
                [self playMovieStream:theMovieURL];
			}
		}
        
        [self.overlayController.playCloseButton addTarget:self
                                                   action:@selector(onClickPlayCloseButton:)
                                         forControlEvents:UIControlEventTouchUpInside];
        
        [self.overlayController.playFullButton addTarget:self
                                                   action:@selector(onClickFullButton:)
                                         forControlEvents:UIControlEventTouchUpInside];
	}
}

-(void)startPlay{
    bPlaying = TRUE;
    [self playStreamingMovieButtonPressed:nil];
//    [self playLocalMovieButtonPressed:nil];
}

- (void)stopPlay{
    bPlaying = FALSE;
    
    [self overlayViewCloseButtonPress:nil];
    
    [[self view] removeFromSuperview];
}

-(void)onClickPlayCloseButton:(id)sender{
    bPlaying = FALSE;
    [self overlayViewCloseButtonPress:sender];
    
    [[self view] removeFromSuperview];
}

-(IBAction)onClickPauseButton:(id)sender{
    
}

-(IBAction)onClickFullButton:(id)sender{
    if (bPlaying) {
        if (bMovieFullMode) {
            [[[self moviePlayerController] view] setFrame:rtMovieNormalFrame];
            [[self view] setFrame:rtViewNormalFrame];
            bMovieFullMode = FALSE;
        }else{
            rtViewNormalFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height); 
            rtMovieNormalFrame = CGRectMake(self.moviePlayerController.view.frame.origin.x, self.moviePlayerController.view.frame.origin.y, self.moviePlayerController.view.frame.size.width, self.moviePlayerController.view.frame.size.height); 
            [[[self moviePlayerController] view] setFrame:CGRectMake(0, 0, 320, 480)];
            [[self view] setFrame:CGRectMake(0, 0, 320, 480)];
            bMovieFullMode = TRUE;
        }
        
    }
}

-(void)playLocalMovieButtonPressed:(id)sender{
    /* Returns a URL to a local movie in the app bundle. */
   
    NSURL *theMovieURL = nil;
    NSBundle *bundle = [NSBundle mainBundle];
    if (bundle) 
    {
        NSString *moviePath = [bundle pathForResource:@"Movie" ofType:@"m4v"];
        if (moviePath)
        {
            theMovieURL = [NSURL fileURLWithPath:moviePath];
        }
    }
    /* Play the movie at the specified URL. */
    [self playMovieFile:theMovieURL];
}

@end
