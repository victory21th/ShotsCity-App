//
//  MainTabBarController.m
//  ShotCity
//
//  Created by dev on 13. 8. 18..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "MainTabBarController.h"
#import "UserModel.h"
#import "AppDelegate.h"
#import "EditPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppSharedData.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

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
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    
    if (userId == nil || [userId isEqual:@""]) {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] performSelector:@selector(showLoginViewController) withObject:nil afterDelay:0.01f];
    }else
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] loginPro];
    
    imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = YES;
	
	
	myImage = [[UIImage alloc] init];
    
    NSString *badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"notification_count"];
    UITabBarItem *tbi = (UITabBarItem*)[[[self tabBar] items] objectAtIndex:1];
    
    [tbi setBadgeValue:badgeValue];
    
    if ([AppSharedData frontCamera] == nil && [AppSharedData backCamera] == nil) {
        UITabBarItem *tbi = (UITabBarItem*)[[[self tabBar] items] objectAtIndex:2];
        tbi.enabled = FALSE;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    self.selectedIndex = beforTabIndex > 0 ? beforTabIndex - 1 : 0;
    
    NSNumber *val = [NSNumber numberWithInteger:beforTabIndex];
    [self.tabBarController performSelector:@selector(setSelectedIndex:) withObject:val afterDelay:0.1f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"Tabbar selected itm %d",item.tag);
    NSNumber *val;
    if (item.tag == 3) {
        //third selected
        [self performSelector:@selector(goCamera) withObject:nil afterDelay:0.01f];
        val = [NSNumber numberWithInteger:beforTabIndex];
        [self.tabBarController performSelector:@selector(setSelectedIndex:) withObject:val afterDelay:0.1f];
        
        //[self showTakePhotoView];
        
    }else{
    
        
        beforTabIndex = item.tag;
        
    }
        
}



- (void)goCamera{
    [self loadPhoto:nil];
}

- (void)showTakePhotoView{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setTempImage:myImage];
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    UINavigationController *NC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kTakePhotoNavigationController"];
    
//    [self presentModalViewController:NC animated:NO];
    [self presentViewController:NC animated:NO
                     completion:nil];
    /*
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [delegate.window addSubview:NC.view];*/
}

- (void)showTakeVideoView{
    
    if ([AppSharedData frontCamera] == nil && [AppSharedData backCamera] == nil) {
        [self setSelectedIndex:beforTabIndex];
        return;
    }
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setTempImage:myImage];
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    UINavigationController *NC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kTakeVideoNavigationController"];
    
    //    [self presentModalViewController:NC animated:NO];
    [self presentViewController:NC animated:NO
                     completion:nil];
}

- (IBAction)loadPhoto:(id)sender
{
    //self.selectedIndex = beforTabIndex > 0 ? beforTabIndex - 1 : 0;
    [self showTakeVideoView];
    /*
    actionSheet = [[UIActionSheet alloc]
                        initWithTitle:nil
                        delegate:self
                        cancelButtonTitle:@"Cancel"
                        destructiveButtonTitle:nil
                        otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
    [actionSheet showInView:self.view];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    */
    /*
     UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Upload Photo" message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Camera", @"Photoalbum", nil];
     [errorAlert show];*/
}


- (void)actionSheet:(UIActionSheet *)theActionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        NSLog(@"cancel clicked");
        [self toggleCancel:nil];
        self.selectedIndex = beforTabIndex > 0 ? beforTabIndex - 1 : 0;
        return;
    }
    
    
	
	//[self presentViewController:picker2 animated:YES completion:nil];
    if (buttonIndex == 0) {
        //send mail
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    if(buttonIndex == 1){
        //send cock call
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
	[self presentViewController:imagePickerController animated:YES completion:nil];
    //[self.navigationController pushViewController:imagePickerController animated:NO];
/*    CGRect f = imagePickerController.view.frame;
    f.origin.y -= 20;
    imagePickerController.view.frame = f;
    [self.view addSubview:imagePickerController.view];*/
}

- (void)toggleCancel:(id)sender{
//    [imagePickerController dismissModalViewControllerAnimated:NO];
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController.view removeFromSuperview];
}

- (void)saveImage:(UIImage *)image withName:(NSString *)name {
	NSData *data = UIImageJPEGRepresentation(image, 1.0);
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:name];
	
	[fileManager createFileAtPath:fullPath contents:data attributes:nil];
}
/*
 -(IBAction) getPhoto:(id) sender {
 UIImagePickerController * picker2 = [[UIImagePickerController alloc] init];
 picker2.delegate = self;
 picker2.allowsEditing = YES;
 
 if((UIButton *) sender == choosePhoto) {
 picker2.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
 } else {
 picker2.sourceType = UIImagePickerControllerSourceTypeCamera;
 }
 myImage = [[UIImage alloc] init];
 
 [self presentViewController:picker2 animated:YES completion:nil];
 }*/
/*
 - (void)imagePickerController:(UIImagePickerController *)picker2 didFinishPickingMediaWithInfo:(NSDictionary *)info {
 
 theimageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
 //theimageView.image = [myImage retain];
 [picker2 dismissModalViewControllerAnimated:YES];
 
 
 UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
 // Dismis the image picker first which causes the UIViewController to reload it's view (and therefore also imageView)
 [self dismissModalViewControllerAnimated:YES];
 [theimageView setImage:image];
 
 }
 */

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
	
	//myImage = [img retain];
	//theimageView.image = myImage;
	
	//[[picker parentViewController] dismissModalViewControllerAnimated:YES];
	
	// need to show the upload image button now
	//upload.hidden = NO;
	
	//UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // Dismis the image picker first which causes the UIViewController to reload it's view (and therefore also imageView)
    
    //[imagePickerController.view removeFromSuperview];
	[imagePickerController dismissModalViewControllerAnimated:NO];
    
    //theimageView = [[UIImageView alloc] init];
    //[theimageView setImage:img];
    
    myImage = img;
	
    [self showTakePhotoView];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self toggleCancel:nil];
}
@end
