//
//  EditPhotoViewController.h
//  ShotCity
//
//  Created by dev on 13. 8. 23..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPhotoViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate>{
    UIImage *myImage;
	IBOutlet UIImageView *theimageView;
    
    UIImagePickerController * imagePickerController;
    UIActionSheet * actionSheet;
    
    UIImage *maskImage;
    NSInteger nRotateIndex;
}
@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIImage *myImage;

- (IBAction)toggleCancel:(id)sender;
- (IBAction)toggleNext:(id)sender;

- (IBAction)toggleFrame:(id)sender;
- (IBAction)toggleBlur:(id)sender;
- (IBAction)toggleGrayscale:(id)sender;
- (IBAction)toggleRotate:(id)sender;

- (IBAction)toggleFrame1:(id)sender;
- (IBAction)toggleFrame2:(id)sender;
- (IBAction)toggleFrame3:(id)sender;
- (IBAction)toggleFrame4:(id)sender;
- (IBAction)toggleFrame5:(id)sender;
- (IBAction)toggleFrame6:(id)sender;

- (IBAction)toggleFrame21:(id)sender;
- (IBAction)toggleFrame22:(id)sender;
- (IBAction)toggleFrame23:(id)sender;
- (IBAction)toggleFrame24:(id)sender;

- (IBAction)toggleFrame31:(id)sender;
- (IBAction)toggleFrame32:(id)sender;

- (IBAction)toggleFrame41:(id)sender;
- (IBAction)toggleFrame42:(id)sender;
- (IBAction)toggleFrame43:(id)sender;

- (IBAction)toggleFrame51:(id)sender;
- (IBAction)toggleFrame52:(id)sender;
- (IBAction)toggleFrame53:(id)sender;
- (IBAction)toggleFrame54:(id)sender;
- (IBAction)toggleFrame55:(id)sender;
- (IBAction)toggleFrame56:(id)sender;

@end
