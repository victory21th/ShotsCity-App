//
//  EditVideoViewController.m
//  ShotsCity
//
//  Created by dev on 13. 11. 20..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import "EditVideoViewController.h"
#import "AppDelegate.h"
#import "ShareMovieViewController.h"
#import "AppSharedData.h"
#import "SelectSoundViewController.h"

@interface EditVideoViewController ()

@end

@implementation EditVideoViewController

@synthesize actionSheet, myImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"foo" ofType:@"mov"];
    NSURL *movieURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"video.mp4"]];//[NSURL fileURLWithPath:moviePath];
    moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    [moviePlayerController.view setFrame:CGRectMake(0, 60, CGRectGetWidth(theimageView.frame), CGRectGetWidth(theimageView.frame))];  // player's frame must match parent's
    [theimageView addSubview:moviePlayerController.view];
    
    // Configure the movie player controller
    moviePlayerController.controlStyle = MPMovieControlStyleNone;
    [moviePlayerController prepareToPlay];
    
    //NSLog(@"duration : %d", moviePlayerController.duration);
    UIImage *imageSel = [moviePlayerController thumbnailImageAtTime:5  timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    CGRect cropRect = CGRectMake(0, 0, 320, 320);
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageSel CGImage], cropRect);
    UIImage *image320 = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    [theimageView setImage:image320];
    
    //moviePlayerController.view.hidden = TRUE;
    
    [[AppSharedData sharedInstance] setSelectedSoundUrl:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinished:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayerController];
    [moviePlayerController play];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController];
    [moviePlayerController stop];
}

-(void)moviePlayBackDidFinished:(NSNotification*)theNotification
{
    MPMoviePlayerController *moviePlayer=[theNotification object];
    /*[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    
    */
    [moviePlayer play];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleCancel:(id)sender{
    [self.navigationController dismissModalViewControllerAnimated:NO];
    //[self.navigationController.view removeFromSuperview];
}

- (void)toggleNext:(id)sender{
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setTempImage:theimageView.image];
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    ShareMovieViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kShareMovieViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}



- (IBAction)toggleRhythm:(id)sender{
/*    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setTempImage:theimageView.image];
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    SelectSoundViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kSelectSoundViewController"];
    [self.navigationController pushViewController:VC animated:YES];*/
    
    [self pickSong];
}

#pragma mark - Media Picker

/*
 * This method is called when the user presses the magnifier button (because this selector was used
 * to create the button in configureBars, defined earlier in this file). It displays a media picker
 * screen to the user configured to show only audio files.
 */
- (void)pickSong {
    
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    [picker setDelegate:self];
    [picker setAllowsPickingMultipleItems: NO];
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Media Picker Delegate

/*
 * This method is called when the user chooses something from the media picker screen. It dismisses the media picker screen
 * and plays the selected song.
 */
- (void)mediaPicker:(MPMediaPickerController *) mediaPicker didPickMediaItems:(MPMediaItemCollection *) collection {
    
    // remove the media picker screen
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    // grab the first selection (media picker is capable of returning more than one selected item,
    // but this app only deals with one song at a time)
    MPMediaItem *item = [[collection items] objectAtIndex:0];
    NSString *title = [item valueForProperty:MPMediaItemPropertyTitle];
    //[_navBar.topItem setTitle:title];
    
    // get a URL reference to the selected item
    NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
    
    [[AppSharedData sharedInstance] setSelectedSoundUrl:url];
    [lbSelectedSong setText:title];
    // pass the URL to playURL:, defined earlier in this file
    //[self playURL:url];
}

/*
 * This method is called when the user cancels out of the media picker. It just dismisses the media picker screen.
 */
- (void)mediaPickerDidCancel:(MPMediaPickerController *) mediaPicker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
