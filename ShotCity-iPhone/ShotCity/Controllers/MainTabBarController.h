//
//  MainTabBarController.h
//  ShotCity
//
//  Created by dev on 13. 8. 18..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarController : UITabBarController<UITabBarControllerDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate>{
    NSInteger beforTabIndex;
    
    UIImage *myImage;
	IBOutlet UIImageView *theimageView;
    
    UIImagePickerController * imagePickerController;
    UIActionSheet * actionSheet;
}

//- (void) navigationForShot:(NSString*)shotid;

@end
