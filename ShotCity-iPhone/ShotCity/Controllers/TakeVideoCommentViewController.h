//
//  TakeVideoCommentViewController.h
//  ShotsCity
//
//  Created by dev on 13. 12. 5..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TakeVideoCommentViewController : UIViewController
{
    
    UIBarButtonItem *recordButton;
	UILabel *frameRateLabel;
	UILabel *dimensionsLabel;
	UILabel *typeLabel;
    
    NSTimer *timer;
    
	BOOL shouldShowStats;
	
	UIBackgroundTaskIdentifier backgroundRecordingID;
    
    IBOutlet UIButton *btnRecord;
    IBOutlet UIButton *btnChangeCamera;
    
    AVCaptureDevicePosition captureDevicePosition;
    
    IBOutlet UIView *loadingView;
    IBOutlet UIActivityIndicatorView *activityLoading;
    
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *recordButton;

- (IBAction)toggleRecording:(id)sender;
- (IBAction)toggleCancel:(id)sender;

- (IBAction)toggleChangeCamera:(id)sender;

@end
