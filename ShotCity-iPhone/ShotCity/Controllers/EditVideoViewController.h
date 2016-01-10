//
//  EditVideoViewController.h
//  ShotsCity
//
//  Created by dev on 13. 11. 20..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface EditVideoViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, MPMediaPickerControllerDelegate>{
    UIImage *myImage;
	IBOutlet UIImageView *theimageView;
    
    UIImagePickerController * imagePickerController;
    UIActionSheet * actionSheet;
    
    UIImage *maskImage;
    NSInteger nRotateIndex;
    
    MPMoviePlayerController *moviePlayerController;
    
    IBOutlet UILabel *lbSelectedSong;
}
@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIImage *myImage;

- (IBAction)toggleCancel:(id)sender;
- (IBAction)toggleNext:(id)sender;


- (IBAction)toggleRhythm:(id)sender;

@end
