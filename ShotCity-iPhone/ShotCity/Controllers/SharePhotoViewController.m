//
//  SharePhotoViewController.m
//  ShotCity
//
//  Created by dev on 13. 8. 24..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import "SharePhotoViewController.h"
#import "AppDelegate.h"
#import "AppSharedData.h"
#import "UIPlaceHolderTextView.h"
#import "SearchUserListViewController.h"
#import "SearchBarViewController.h"

@interface SharePhotoViewController ()

@end

@implementation SharePhotoViewController

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
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    searchUserListViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"kSearchUserListViewController"];
    searchUserListViewController.view.frame = CGRectMake(0, 100, 320, self.view.frame.size.height - 100 - 220);
    searchUserListViewController.sharePhotoViewController = self;
    
    [self.view addSubview:searchUserListViewController.view];
    searchUserListViewController.view.hidden = TRUE;
    
    viewBarSection.hidden = TRUE;
    mySwitch.on = FALSE;
    [self toggleChangeSwitch:mySwitch];
    //
    searchBarViewController = [[SearchBarViewController alloc] initWithNibName:@"SearchBarViewController" bundle:nil];
    [self.view addSubview:searchBarViewController.view];
    searchBarViewController.view.hidden = TRUE;
    searchBarViewController.targetViewController = self;
    
    selectedBar = nil;
    [btnSelectBar setTitle:@"Tag A Bar" forState:UIControlStateNormal];
    
    isFb = FALSE;
    isTw = FALSE;
    
    [self stopLoading];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [myImageView setImage:[(AppDelegate*)[[UIApplication sharedApplication] delegate] tempImage]];
    
    [commentTextView becomeFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)toggleBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController.view removeFromSuperview];
}

- (void)toggleShare:(id)sender{
/*    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@"
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    NSLog(@"%@", url);
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *postString = [NSString stringWithFormat:@"data:image/png;base64,%@&text=%@&tag_ids=%@"
                            , [AppSharedData GetBase64String:myImageView.image]
                            , [commentTextView text]
                            , @"shot"];
    NSLog(@"%@", postString);
    
    [urlRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    */
    [commentTextView resignFirstResponder];
    
    [self startLoading];
    isSendingShare = TRUE;
    
    [self uploadData1];
    /*
    [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"update_list"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController dismissModalViewControllerAnimated:YES];*/
}


- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    if (data==nil) data = [[NSMutableData alloc] initWithCapacity:2048];
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection
{
    [self stopLoading];
    
    if(!data) {
        NSString *errorString = @"FAILD REGISTER SHOT!";
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Faild Reuestion" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        
        
    }else {
        NSString *aStr = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        
        //NSLog(@"%@", url);
        NSLog(@"%@", aStr);
        
        //NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"location_id"]);
        NSError *error = nil;
        NSData *jsonData = [aStr dataUsingEncoding:NSUTF8StringEncoding];
        
        if (jsonData) {
            
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            if (error) {
                NSLog(@"error is %@", [error localizedDescription]);
            }
            
            if (![aStr isEqualToString:@"{ \"error\":\"No User!\"}"]) {
                //userdata = jsonObjects;
                NSDictionary *user = [jsonObjects objectForKey:@"user"];
                
                if (user == nil || [user isEqual:nil]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@""
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"update_list"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                
            }
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self stopLoading];
}

- (void)startLoading{
    [loadingView setHidden:FALSE];
    [activityLoading startAnimating];
}

- (void)stopLoading{
    isSendingShare = FALSE;
    
    [loadingView setHidden:TRUE];
    [activityLoading stopAnimating];
}

- (IBAction)uploadData {
	
	//NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	/*
	 turning the image into a NSData object
	 getting the image back out of the UIImageView
	 setting the quality to 90
	 */
    
	NSData *imageData = UIImageJPEGRepresentation(myImageView.image, .60);
	// setting up the URL to post to
	//NSString *urlString = @"http://infotechmobile.us/hhdating/upload.php";
	NSString *urlString = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@"
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
	// setting up the request object now
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
	 */
    
	NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
	 */
    
	NSMutableData *body = [NSMutableData data];
	
	NSDate* date = [NSDate date];
	
	//Create the dateformatter object
	
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
	
	//Set the required date format
	
	[formatter setDateFormat:@"yyyyMMddHHmmss"];
	
	//Get the string date
	
	NSString* str1 = [formatter stringFromDate:date];
	NSString *str = @"shot";
	NSString *imageFile = [NSString stringWithFormat:@"%@%@%@.jpg", str, [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"], str1];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	//[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"ipodfile.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", imageFile] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
    NSString *postString = [NSString stringWithFormat:@"text=%@&tag_ids=%@"
                            , [commentTextView text]
                            , @"shot"];
    NSLog(@"%@", postString);
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",postString] dataUsingEncoding:NSUTF8StringEncoding]];
	    
    
    // setting the body of the post to the reqeust
	[request setHTTPBody:body];
    
    
    
    
    
	
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"Return Data: %@",returnData);
	NSLog(@"Return String: %@",returnString);
	    
    
}

- (void) uploadData1{
    NSString *urlString = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@"
                           , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
	
    //Get path to file.
    NSArray *paths                                      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory        = [paths objectAtIndex:0];
    NSString *imagePath                         = [documentsDirectory stringByAppendingPathComponent:@"temp.jpg"];
    
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //Set Params
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    //Create boundary, it can be anything
    NSString *boundary = @"------WebKitFormBoundary4QuqLuM1cE5lMwCy";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    //Populate a dictionary with all the regular values you would like to send.
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:11];
    [parameters setValue:[commentTextView text] forKey:@"text"];
    [parameters setValue:isFb == TRUE ? @"true" : @"false" forKey:@"facebook_share"];
    [parameters setValue:isTw == TRUE ? @"true" : @"false" forKey:@"twitter_share"];
    if (mySwitch.on) {
        [parameters setValue:[selectedBar objectForKey:@"id"] forKey:@"bar_id"];
    }    
    [parameters setValue:@"Shot" forKey:@"tag_ids"];
    [parameters setValue:[NSString stringWithFormat:@"%f", searchBarViewController.currentLocation.coordinate.latitude] forKey:@"lat"];
    [parameters setValue:[NSString stringWithFormat:@"%f", searchBarViewController.currentLocation.coordinate.longitude] forKey:@"lon"];
    
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
    NSData *imageData = UIImageJPEGRepresentation(myImageView.image, .60);
	
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(myImageView.image, compression);
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
/*
    NSURLResponse* response;
    NSError* error;
    
    
    // now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"Return Data: %@",returnData);
	NSLog(@"Return String: %@",returnString);
 */
    data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    [self startLoading];
    
    
    
    //Here is where you would add any GUI indicators such as a load view to let the user know you are working.
    
    
    //Start your connection and handle any UI components you need to such as removing a loading view after the transaction is complete.
/*    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               //Here is where you put your code to remove a loading view or something.
                           }];*/
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self toggleShare:nil];
        return NO;
    }
    
    if ([text isEqualToString:@"@"]) {
        searchUserListViewController.view.hidden = FALSE;
    }
    
    if ([text isEqualToString:@" "]) {
        searchUserListViewController.view.hidden = TRUE;
    }else{
        NSArray *words = [[NSString stringWithFormat:@"%@%@" ,textView.text, text] componentsSeparatedByString:@"@"];
        if ([words count] > 1) {
            NSString *lastword = [words objectAtIndex:[words count] - 1];
            NSArray *words1 = [lastword componentsSeparatedByString:@" "];
            if ([words1 count] == 1 && [[words1 objectAtIndex:0] isEqualToString:@""] == FALSE) {
                searchUserListViewController.view.hidden = FALSE;
                [searchUserListViewController updateSearchList:[words1 objectAtIndex:0]];
            }else
                searchUserListViewController.view.hidden = TRUE;
        }else
            searchUserListViewController.view.hidden = TRUE;
    }
    return YES;
}

- (void)appendUserName:(NSString *)username{
    NSMutableArray *words = (NSMutableArray*)[[NSString stringWithFormat:@"%@" ,commentTextView.text] componentsSeparatedByString:@"@"];
    if ([words count] > 1) {
        [words removeObjectAtIndex:[words count]-1];
        [words addObject:[NSString stringWithFormat:@"%@ ", username]];
        
        commentTextView.text = [words componentsJoinedByString:@"@"];
        
        searchUserListViewController.view.hidden = TRUE;
    }
}

- (void)toggleChangeSwitch:(id)sender{
    if (mySwitch.on) {
        viewBarSection.hidden = FALSE;
        
        CGRect rc = viewShareSection.frame;
        rc.origin.y = 211;
        viewShareSection.frame = rc;
    }else{
        viewBarSection.hidden = TRUE;
        
        CGRect rc = viewShareSection.frame;
        rc.origin.y = 176;
        viewShareSection.frame = rc;
    }
}

- (void)toggleSelectBar:(id)sender{
    [commentTextView resignFirstResponder];
    
    searchBarViewController.view.hidden = FALSE;
        
    CGRect basketBottomFrame = searchBarViewController.view.frame;
    basketBottomFrame.origin.y = self.view.bounds.size.height;
    searchBarViewController.view.frame = basketBottomFrame;
    
    basketBottomFrame.origin.y = 0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    searchBarViewController.view.frame = basketBottomFrame;
    
    [UIView commitAnimations];
}

- (void) toggleSelectedBar:(id)bardata{
    NSDictionary *dic = (NSDictionary*)bardata;
    [btnSelectBar setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
    selectedBar = dic;
}

- (void)toggleFacebook:(id)sender{
    
    if (isFb) {
        isFb = FALSE;
        [btnFacebook setImage:[UIImage imageNamed:@"icon_fb_gray.png"] forState:UIControlStateNormal];
    }else{
        isFb = TRUE;
        [btnFacebook setImage:[UIImage imageNamed:@"icon_fb.png"] forState:UIControlStateNormal];

    }

}

- (void)toggleTwitter:(id)sender{
    
    if (isTw) {
        isTw = FALSE;
        [btnTwitter setImage:[UIImage imageNamed:@"icon_tw_gray.png"] forState:UIControlStateNormal];
    }else{
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token_tw"] == nil) {
            [self toggleGetTwitterAuth:nil];
        }
        
    }
}


///
- (void)toggleGetTwitterAuth:(id)sender{
    [self resignFirstResponder];
    [commentTextView resignFirstResponder];
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/auth/twitter?user_id=%@"
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:20.0];
    //[myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    NSLog(@"%@", url);
    [myWebView loadRequest:req];
    
    [myWebView setHidden:FALSE];
}

///////////////
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [indicationView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [indicationView stopAnimating];
    
    NSString *aStr = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
    
    NSLog(@"%@", aStr);
    NSData *jsonData = [aStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    if (jsonData) {
        
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        if (error) {
            //NSLog(@"error is %@", [error localizedDescription]);
            //[myWebView setHidden:FALSE];
            //[indicationView stopAnimating];
            //[myWebView setHidden:TRUE];
            
            return;
        }
        
        if (![aStr isEqualToString:@"{ \"error\":\"No User!\"}"]) {
            //userdata = jsonObjects;
            NSDictionary *user = [jsonObjects objectForKey:@"user"];
            
            if (user == nil || [user isEqual:nil]) {
                [indicationView stopAnimating];
                
                [myWebView setHidden:TRUE];
                
                isTw = FALSE;
                [btnTwitter setImage:[UIImage imageNamed:@"icon_tw_gray.png"] forState:UIControlStateNormal];

                return;
            }
            isTw = TRUE;
            [btnTwitter setImage:[UIImage imageNamed:@"icon_tw.png"] forState:UIControlStateNormal];
            
            [indicationView stopAnimating];
            
            [myWebView setHidden:TRUE];
            
            /*
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [[NSUserDefaults standardUserDefaults] setObject:[user objectForKey:@"auth_token_tw"] forKey:@"auth_token"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"update_list"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [myWebView setHidden:TRUE];
            */
            //[self dismissModalViewControllerAnimated:YES];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [indicationView stopAnimating];
    
    [myWebView setHidden:TRUE];
    
    NSLog(@"%@", error);
    
    isTw = FALSE;
    [btnTwitter setImage:[UIImage imageNamed:@"icon_tw_gray.png"] forState:UIControlStateNormal];
}

@end
