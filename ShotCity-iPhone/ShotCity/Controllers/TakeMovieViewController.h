//
//  TakeMovieViewController.h
//  ShotsCity
//
//  Created by dev on 13. 11. 18..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <GLKit/GLKit.h>
#import "PBJVision.h"
#import "PBJVisionUtilities.h"

@interface TakeMovieViewController : UIViewController<PBJVisionDelegate, UIAlertViewDelegate>
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
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *recordButton;

- (IBAction)toggleRecording:(id)sender;
- (IBAction)toggleCancel:(id)sender;

- (IBAction)toggleChangeCamera:(id)sender;

@end
