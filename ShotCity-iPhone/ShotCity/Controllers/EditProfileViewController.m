//
//  EditProfileViewController.m
//  ShotCity
//
//  Created by dev on 13. 8. 24..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Image.h"
#import "AppDelegate.h"
#import "AppSharedData.h"
#import "PhotoListData.h"
#import <QuartzCore/QuartzCore.h>
#import "UserModel.h"
#import "ProfileViewController.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

@synthesize userData;


- (void)viewDidLoad{
    [super viewDidLoad];
    
    imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = YES;
	
    [self initUserProfile];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)toggleLogOut:(id)sender{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"auth_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [delegate showLoginViewController];
}

- (void)toggleBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUserProfile{
    isChangeProfileImage = FALSE;
    
    NSURL* url = [NSURL URLWithString:[self.userData objectForKey:@"image_url"]];
    [ivProfile initWithImageAtURL:url];
    
    [btnFollowers setTitle:[NSString stringWithFormat:@"%d",[[[self.userData objectForKey:@"counts"] objectForKey:@"followers"] integerValue]]
                  forState:UIControlStateNormal];
    [btnFollowings setTitle:[NSString stringWithFormat:@"%d",[[[self.userData objectForKey:@"counts"] objectForKey:@"following"] integerValue]]
                   forState:UIControlStateNormal];
    
    [txtUserName setText:[self.userData objectForKey:@"username"]==[NSNull null]?@"":[self.userData objectForKey:@"username"]];
    [lbName setText:[self.userData objectForKey:@"name"]];
    [lbGender setText:[self.userData objectForKey:@"gender"]];
    
}

/////
- (IBAction)loadPhoto:(id)sender
{
    
    actionSheet = [[UIActionSheet alloc]
                   initWithTitle:nil
                   delegate:self
                   cancelButtonTitle:@"Cancel"
                   destructiveButtonTitle:nil
                   otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
    [actionSheet showInView:self.view];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
}


- (void)actionSheet:(UIActionSheet *)theActionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d clicked", buttonIndex);
    if (buttonIndex == 2) {
        NSLog(@"cancel clicked");
        
        return;
    }
    
    if (buttonIndex == 0) {
        //send mail
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    if(buttonIndex == 1){
        //send cock call
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
	[self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (void)toggleCancel:(id)sender{
    [imagePickerController dismissModalViewControllerAnimated:NO];
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
    isChangeProfileImage = YES;
	ivProfile.image = myImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self toggleCancel:nil];
}

- (void)toggleSave:(id)sender{
    if (isChangeProfileImage) {
        [self uploadData];
        //[self uploadImage];
    }else
        [self uploadDataWithoutImage];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"update_list"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void) uploadData{
    NSString *urlString = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users/%@?auth_token=%@"
                           , [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]
                           , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
	
    //Get path to file.
//    NSArray *paths                                      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory        = [paths objectAtIndex:0];
//    NSString *imagePath                         = [documentsDirectory stringByAppendingPathComponent:@"temp.jpg"];
    
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //Set Params
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"PUT"];
    
    //Create boundary, it can be anything
    NSString *boundary = @"------WebKitFormBoundary4QuqLuM1cE5lMwCy";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    //Populate a dictionary with all the regular values you would like to send.
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:11];
    [parameters setValue:[txtUserName text] forKey:@"username"];
    
    // add params (all params are strings)
    for (NSString *param in parameters) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSString *FileParamConstant = @"image";
    
    // add image data and compress to send if needed.
    CGFloat compression         = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize             = 250*1024;
    
    //NSData *imageData = [[NSData alloc] initWithContentsOfFile:imagePath];
    NSData *imageData = UIImageJPEGRepresentation(myImage, .60);
	
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(myImage, compression);
    }
    
    //Assuming data is not nil we add this to the multipart form
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //Close off the request with the boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the request
    [request setHTTPBody:body];
    
    // set URL
    [request setURL:[NSURL URLWithString:urlString]];
    
//    NSURLResponse* response;
//    NSError* error;
    
    
    // now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"Return Data: %@",returnData);
	NSLog(@"Return String: %@",returnString);
    
    //Here is where you would add any GUI indicators such as a load view to let the user know you are working.
    
    
    //Start your connection and handle any UI components you need to such as removing a loading view after the transaction is complete.
    /*    [NSURLConnection sendAsynchronousRequest:request
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
     //Here is where you put your code to remove a loading view or something.
     }];*/
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) uploadImage
{
    //prodNam = txtProdName.text;
    UIImage * img = myImage;//[UIImage imageNamed:@"SRT2.jpg"];
    NSData *imageData = UIImageJPEGRepresentation(img,0.2);     //change Image to NSData
    
    if (imageData != nil)
        
    {
        NSString * filenames = [NSString stringWithFormat:@"image"];
        NSLog(@"%@", filenames);
        
        //NSString *urlString = @"http://dev9.edisbest.com/upload_image.php";
        NSString *urlString = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users/%@?auth_token=%@"
                               , [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]
                               , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"PUT"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filenames\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[filenames dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\"TestEdreamzIpad.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"Response : %@",returnString);
        
        if([returnString isEqualToString:@"Success ! The file has been uploaded"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image Saved Successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alert show];
        }
        NSLog(@"Finish");
    }
}

- (void) uploadDataWithoutImage{
    NSString *urlString = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users/%@?auth_token=%@"
                           , [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]
                           , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
//	NSLog(urlString);
    
//    NSString* requestStr = [NSString stringWithFormat:@"username=%@", txtUserName.text];
    
    /*
    NSData *myRequestData = [ NSData dataWithBytes: [ requestStr UTF8String ] length: [ requestStr length ] ];
    
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString:urlString]];
    
    [request setHTTPMethod: @"PUT" ];
    [request setHTTPBody: myRequestData ];
    
    */
    
    NSString *post = [NSString stringWithFormat:@"username=%@", txtUserName.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    NSString *content = [NSString stringWithUTF8String:[returnData bytes]];
    NSLog(@"ServerRequestResponse::responseData: %@", content);
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
