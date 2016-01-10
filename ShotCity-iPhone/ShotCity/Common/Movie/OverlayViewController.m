/*
 
   
 
 */

#import "OverlayViewController.h"

@implementation MyOverlayViewController

@synthesize moviePlaybackStateText, movieLoadStateText;
@synthesize playCloseButton;
@synthesize playPauseButton;
@synthesize playFullButton;
@synthesize btnCloseMovie;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        /*
        if (btnCloseMovie == nil) {
            self.btnCloseMovie = [[UIButton alloc] initWithFrame:CGRectMake(127, 1, 25, 25)];
            //[btnCloseMovie setTitle:@"CloseMovie" forState:UIControlStateNormal];
            //[btnCloseMovie setFont:[UIFont systemFontOfSize:10]];
            [btnCloseMovie setImage:[UIImage imageNamed:@"btn_x.png"] forState:UIControlStateNormal];
            
            [self.view addSubview:btnCloseMovie];    
        }     */   
    }
    return self;
}
#pragma mark -
#pragma mark Display Movie Status Strings

/* Movie playback state display string. */
-(void)setPlaybackStateDisplayString:(NSString *)playBackText
{
	self.moviePlaybackStateText.text = playBackText;
//    NSLog(playBackText);
    [self updateView];
}

/* Movie load state display string. */
-(void)setLoadStateDisplayString:(NSString *)loadStateText;
{
	self.movieLoadStateText.text = loadStateText;
//    NSLog(loadStateText);
    [self updateView];
}

- (void)updateView{
    [self.view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
    UIView *superview = [self.view superview];
    
    [self.view setFrame:CGRectMake(0, 0, superview.frame.size.width - 50, 30)];
    
    [self.btnCloseMovie setFrame:CGRectMake(superview.frame.size.width - 30, 2, btnCloseMovie.frame.size.width, btnCloseMovie.frame.size.height)];
    
    [superview bringSubviewToFront:self.view];
    /*
    if (btnCloseMovie == nil) {
        self.btnCloseMovie = [[UIButton alloc] initWithFrame:CGRectMake(127, 1, 25, 25)];
        //[btnCloseMovie setTitle:@"CloseMovie" forState:UIControlStateNormal];
        //[btnCloseMovie setFont:[UIFont systemFontOfSize:10]];
        [btnCloseMovie setImage:[UIImage imageNamed:@"btn_x.png"] forState:UIControlStateNormal];
        
        [self.view addSubview:btnCloseMovie];    
    } 
    
    [self.btnCloseMovie setHidden:FALSE];
    [self.view bringSubviewToFront:btnCloseMovie];*/
}
@end
