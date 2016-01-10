//
//  EditProfileViewController.h
//  ShotCity
//
//  Created by dev on 13. 8. 24..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Image;

@interface EditProfileViewController : UIViewController<UITabBarControllerDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate>{
    IBOutlet UITextField *txtUserName;
    IBOutlet UILabel *lbName;
    IBOutlet Image *ivProfile;
    IBOutlet UILabel *lbGender;
    
    IBOutlet UIButton *btnFollowers;
    IBOutlet UIButton *btnFollowings;
    
    UIImage *myImage;
	IBOutlet UIImageView *theimageView;
    
    UIImagePickerController * imagePickerController;
    UIActionSheet * actionSheet;
    BOOL isChangeProfileImage;
}
@property (nonatomic, retain) NSDictionary *userData;

- (IBAction)toggleBack:(id)sender;

- (IBAction)toggleSave:(id)sender;
@end
