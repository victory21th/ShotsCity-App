//
//  TakeVideoCommentViewController.m
//  ShotsCity
//
//  Created by dev on 13. 12. 5..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import "TakeVideoCommentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "AppSharedData.h"
#import "CommitVideoCommentViewController.h"

#import "PBJVision.h"
#import "PBJVisionUtilities.h"

#import <AssetsLibrary/AssetsLibrary.h>

static inline double radians (double degrees) { return degrees * (M_PI / 180); }

@interface TakeVideoCommentViewController () <PBJVisionDelegate> {
    
    UIView *_previewView;
    AVCaptureVideoPreviewLayer *_previewLayer;
    
    BOOL _recording;
    
    ALAssetsLibrary *_assetLibrary;
    __block NSDictionary *_currentVideo;
}

@end

@implementation TakeVideoCommentViewController

@synthesize recordButton;

- (void)dealloc
{
    [super dealloc];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}


- (void)viewDidLoad
{
	[super viewDidLoad];
    
    
    if ([AppSharedData frontCamera] != nil && [AppSharedData backCamera] != nil) {
        btnChangeCamera.enabled = TRUE;
    }else{
        btnChangeCamera.enabled = FALSE;
        [btnChangeCamera removeFromSuperview];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    _assetLibrary = [[ALAssetsLibrary alloc] init];
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    _previewView = [[UIView alloc] initWithFrame:CGRectZero];
    _previewView.backgroundColor = [UIColor blackColor];
    CGRect previewFrame = CGRectMake(0, 65.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 180);
    _previewView.frame = previewFrame;
    _previewLayer = [[PBJVision sharedInstance] previewLayer];
    _previewLayer.frame = _previewView.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_previewView.layer addSublayer:_previewLayer];
    
    [[PBJVision sharedInstance] setPresentationFrame:_previewView.frame];
    
    [self _resetCapture];
    [[PBJVision sharedInstance] startPreview];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    [[PBJVision sharedInstance] stopPreview];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}


#pragma mark - private start/stop helper methods

- (void)_startCapture

{
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    
    
    [[PBJVision sharedInstance] startVideoCapture];
    
}

- (void)_pauseCapture

{
    
    [[PBJVision sharedInstance] pauseVideoCapture];
    
}



- (void)_resumeCapture

{
    
    [[PBJVision sharedInstance] resumeVideoCapture];
    
}

- (void)_endCapture

{
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    [[PBJVision sharedInstance] endVideoCapture];
    
}



- (void)_resetCapture

{
    
    
    
    PBJVision *vision = [PBJVision sharedInstance];
    
    vision.delegate = self;
    
    
    
    if ([vision isCameraDeviceAvailable:PBJCameraDeviceBack]) {
        
        [vision setCameraDevice:PBJCameraDeviceBack];
        
    } else {
        
        [vision setCameraDevice:PBJCameraDeviceFront];
        
    }
    
    
    
    [vision setCameraMode:PBJCameraModeVideo];
    
    [vision setCameraOrientation:PBJCameraOrientationPortrait];
    
    [vision setFocusMode:PBJFocusModeContinuousAutoFocus];
    
    [vision setOutputFormat:PBJOutputFormatSquare];
    
    [vision setVideoRenderingEnabled:YES];
    
}


- (IBAction)toggleRecording:(id)sender
{
	// Wait for the recording to start/stop before re-enabling the record button.
    if (!_recording) {
        [btnRecord setImage:[UIImage imageNamed:@"btn_stop.png"] forState:UIControlStateNormal];
        [self _startCapture];
    }else {
        [btnRecord setImage:[UIImage imageNamed:@"btn_record.png"] forState:UIControlStateNormal];
        [self _endCapture];
    }
}


- (void)toggleCancel:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController.view removeFromSuperview];
}

- (void)toggleChangeCamera:(id)sender{
    
    PBJVision *vision = [PBJVision sharedInstance];
    
    if (vision.cameraDevice == PBJCameraDeviceBack) {
        
        [vision setCameraDevice:PBJCameraDeviceFront];
        
    } else {
        
        [vision setCameraDevice:PBJCameraDeviceBack];
        
    }
}

- (void)startLoading{
    [self.view bringSubviewToFront:loadingView];
    
    [loadingView setHidden:FALSE];
    [activityLoading startAnimating];
}

- (void)stopLoading{
    
    [loadingView setHidden:TRUE];
    [activityLoading stopAnimating];
}


#pragma mark - PBJVisionDelegate



- (void)visionSessionWillStart:(PBJVision *)vision

{
    
}



- (void)visionSessionDidStart:(PBJVision *)vision

{
    
    if (![_previewView superview]) {
        
        [self.view addSubview:_previewView];
        
    }
    
}



- (void)visionSessionDidStop:(PBJVision *)vision

{
    
    [_previewView removeFromSuperview];
    
}



- (void)visionModeWillChange:(PBJVision *)vision

{
    
}



- (void)visionModeDidChange:(PBJVision *)vision

{
    
}



- (void)vision:(PBJVision *)vision didChangeCleanAperture:(CGRect)cleanAperture

{
    
}



- (void)visionWillStartFocus:(PBJVision *)vision

{
    
}



- (void)visionDidStopFocus:(PBJVision *)vision

{
    
    
    
}





// video capture



- (void)visionDidStartVideoCapture:(PBJVision *)vision

{
    
    _recording = YES;
    
}



- (void)visionDidPauseVideoCapture:(PBJVision *)vision

{
    
}



- (void)visionDidResumeVideoCapture:(PBJVision *)vision

{
    
    
    
}



- (void)vision:(PBJVision *)vision capturedVideo:(NSDictionary *)videoDict error:(NSError *)error

{
    
    _recording = NO;
    
    
    
    if (error) {
        
        NSLog(@"encounted an error in video capture (%@)", error);
        
        return;
        
    }
    
    
    
    _currentVideo = videoDict;
    
    
    
    NSString *videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
    
    [[AppSharedData sharedInstance] setCapturedMovieUrl:[NSURL URLWithString:videoPath]];
    
    
    
    [_assetLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:videoPath] completionBlock:^(NSURL *assetURL, NSError *error1) {
        
        UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
        
        CommitVideoCommentViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kCommitVideoCommentViewController"];
        [self.navigationController pushViewController:VC animated:YES];
        
    }];
    
}



// progress



- (void)visionDidCaptureAudioSample:(PBJVision *)vision

{
    
    //    NSLog(@"captured audio (%f) seconds", vision.capturedAudioSeconds);
    
}



- (void)visionDidCaptureVideoSample:(PBJVision *)vision

{
    
    //    NSLog(@"captured video (%f) seconds", vision.capturedVideoSeconds);
    
}


@end
