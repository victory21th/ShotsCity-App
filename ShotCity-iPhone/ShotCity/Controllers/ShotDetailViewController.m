//
//  ShotDetailViewController.m
//  ShotCity
//
//  Created by dev on 13. 8. 27..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import "ShotDetailViewController.h"
#import "Image.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "AppSharedData.h"
#import <QuartzCore/QuartzCore.h>
#import "VideoCommentsViewController.h"
#import "CheersViewController.h"
#import "STTweetLabel.h"
#import "ShotCell.h"
#import "BarShotListViewController.h"
#import "StreamingMovieViewController.h"

@interface ShotDetailViewController ()

@end

@implementation ShotDetailViewController

@synthesize shotData, connection, data;


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
    NSString *version = [[UIDevice currentDevice] systemVersion];
    BOOL isAtLeast7 = [version floatValue] >= 7.0;
    if (isAtLeast7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        [myScrollView setScrollIndicatorInsets:UIEdgeInsetsMake(65, 0, 51, 0)];
        [myScrollView setContentInset:UIEdgeInsetsMake(65, 0, 51, 0)];
        
        [myScrollView setContentOffset:CGPointMake(0, 0)];
        

    }

    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    btnLocation = [[UIButton alloc] initWithFrame:CGRectMake(52, 32, 186, 20)];
    [btnLocation addTarget:self action:@selector(toggleLocation:) forControlEvents:UIControlEventTouchUpInside];
    [btnLocation setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    //[self.btnLocation setTitleColor:[[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.5 alpha:1] forState:UIControlStateNormal];
    [btnLocation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnLocation setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnLocation setImage:[UIImage imageNamed:@"icon_pin.png"] forState:UIControlStateNormal];
    [btnLocation setContentEdgeInsets:UIEdgeInsetsMake(0, 3, 3, 0)];
    [btnLocation setTitleEdgeInsets:UIEdgeInsetsMake(2, 3, 0, 0)];
    
    [btnLocation.titleLabel setFont:[UIFont systemFontOfSize:11]];
    
    [myScrollView addSubview:btnLocation];
    
    //self.imgProfile = [[Image alloc] initWithFrame:CGRectMake(11, 9, 32, 32)];
    [imgProfile setFrame:CGRectMake(10, 10, 38, 38)];
    imgProfile.backgroundColor = [UIColor grayColor];
    imgProfile.layer.cornerRadius = 2;
    imgProfile.layer.masksToBounds = YES;
    imgProfile.contentMode = UIViewContentModeScaleAspectFill;
    [imgProfile setImage:[UIImage imageNamed:@"no-profile.jpg"]];
    
    [btnProfileImage setFrame:CGRectMake(0, 0, 55, 55)];
    [btnProfileImage addTarget:self action:@selector(toggleProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    [imgShot setFrame:CGRectMake(9, 53, 302, 302)];
    //[imgShot setDefaultImage:[UIImage imageNamed:@"no-image-found.jpg"]];
    imgShot.backgroundColor = [UIColor grayColor];
    imgShot.layer.cornerRadius = 1;
    imgShot.layer.masksToBounds = YES;
    imgShot.contentMode = UIViewContentModeScaleAspectFill;
    imgShot.delegate = self;
    
    lbUpdatedTime = [[UIButton alloc] initWithFrame:CGRectMake(220, 19, 90, 13)];
    [lbUpdatedTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [lbUpdatedTime setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [lbUpdatedTime.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [lbUpdatedTime.titleLabel setTextAlignment:NSTextAlignmentRight];
    //[self.lbUpdatedTime setImage:[UIImage imageNamed:@"time-48.ico"] forState:UIControlStateNormal];
    [lbUpdatedTime setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [[lbUpdatedTime imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [lbUpdatedTime setTitle:@"5s" forState:UIControlStateNormal];
    [lbUpdatedTime setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [lbUpdatedTime setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -14)];
    //[self.lbUpdatedTime setContentMode:UIViewContentMode];
    [myScrollView addSubview:lbUpdatedTime];
    
    
    lbText = [[UITextView alloc] initWithFrame:CGRectMake(45, 14, 186, 20)];
    [lbText setFont:[UIFont fontWithName:@"Helvetica" size:7]];
    [lbText setTextColor:[UIColor grayColor]];
    [lbText setText:@""];
    [lbText setEditable:FALSE];
    
    
    btnPlayMovie = [[UIButton alloc] initWithFrame:CGRectMake(101, 144, 120, 120)];
    [btnPlayMovie setImage:[UIImage imageNamed:@"btn_play.png"] forState:UIControlStateNormal];
    btnPlayMovie.hidden = TRUE;
    [btnPlayMovie addTarget:self action:@selector(onClickPlay:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:btnPlayMovie];
    

    //[self.view addSubview:imgProfile];
    //[self.view addSubview:imgShot];
    //[self.contentView addSubview:self.lbUpdatedTime];
    //[self.contentView addSubview:self.lbName];
    //[self.contentView addSubview:self.lbText];
    //[self.view addSubview:btnProfileImage];
    
    //self.view.backgroundColor = [UIColor clearColor];
    
    //if (btnName == nil) {
        //btnName = [[UIButton alloc] initWithFrame:CGRectMake(45, 5, 186, 20)];
        //[btnName addTarget:self action:@selector(toggleProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [btnName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnName setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateHighlighted];
    [btnName.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
        //[self.view addSubview:btnName];
    //}
    
    btnCheers = [[UIButton alloc] initWithFrame:CGRectMake(19, 369, 100, 20)];
    [btnCheers addTarget:self action:@selector(toggleCheer:) forControlEvents:UIControlEventTouchUpInside];
    [btnCheers setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnCheers setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCheers setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateHighlighted];
    [btnCheers setImage:[UIImage imageNamed:@"icon_cheer.png"] forState:UIControlStateNormal];
    //[btnCheers setContentEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
    [btnCheers setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [btnCheers setTitle:@"cheer_1.png" forState:UIControlStateNormal];
    [btnCheers.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [myScrollView addSubview:btnCheers];
    
    btnComments = [[UIButton alloc] initWithFrame:CGRectMake(19, 385, 100, 20)];
    [btnComments addTarget:self action:@selector(toggleComment:) forControlEvents:UIControlEventTouchUpInside];
    [btnComments setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnComments setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnComments setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateHighlighted];
    [btnComments setImage:[UIImage imageNamed:@"icon_comment.png"] forState:UIControlStateNormal];
    //[btnComments setContentEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
    [btnComments setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    //[btnComments setTitle:@"cheer_1.png" forState:UIControlStateNormal];
    [btnComments.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [myScrollView addSubview:btnComments];
    
    btnAddComment = [[UIButton alloc] initWithFrame:CGRectMake(264, 362, 41, 42)];
    [btnAddComment setImage:[UIImage imageNamed:@"btn_comment.png"] forState:UIControlStateNormal];
    [btnAddComment setImage:[UIImage imageNamed:@"btn_comment_press.png"] forState:UIControlStateHighlighted];
    [btnAddComment addTarget:self action:@selector(toggleAddComment:) forControlEvents:UIControlEventTouchUpInside];
    
    [myScrollView addSubview:btnAddComment];
    
    btnAddCheer = [[UIButton alloc] initWithFrame:CGRectMake(140, 362, 41, 42)];
    [btnAddCheer setImage:[UIImage imageNamed:@"btn_cheer.png"] forState:UIControlStateNormal];
    [btnAddCheer setImage:[UIImage imageNamed:@"btn_cheer_press.png"] forState:UIControlStateHighlighted];
    [btnAddCheer addTarget:self action:@selector(toggleAddCheer:) forControlEvents:UIControlEventTouchUpInside];
    
    [myScrollView addSubview:btnAddCheer];
    
    btnDetail = [[UIButton alloc] initWithFrame:CGRectMake(187, 362, 69, 42)];
    [btnDetail setImage:[UIImage imageNamed:@"btn_more.png"] forState:UIControlStateNormal];
    [btnDetail addTarget:self action:@selector(toggleDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    [myScrollView addSubview:btnDetail];
    
    _tweetLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(9, 413, 302, 130.0)];
    [_tweetLabel setFont:[UIFont systemFontOfSize:13]];
    [_tweetLabel setFontUser:[UIFont boldSystemFontOfSize:13]];
    [_tweetLabel setTextColor:[UIColor blackColor]];
    [_tweetLabel setColorAccount:[UIColor blackColor]];
    [_tweetLabel setColorHashtag:[UIColor blackColor]];
    [_tweetLabel setColorUser:[UIColor blackColor]];
    //[_tweetLabel setBackgroundColor:[UIColor blueColor]];
    [_tweetLabel setText:@"Hi. This is a new tool for @you! Developed by->@SebThiebaud for #iPhone #Obj-C... ;-) My GitHub page: https://www.github.com/SebastienThiebaud! \n Hi. This is a new tool for @you! Developed by->@SebThiebaud for #iPhone #Obj-C... ;-) My GitHub page: https://www.github.com/SebastienThiebaud!"];
    
    STLinkCallbackBlock callbackBlock = ^(STLinkActionType actionType, NSString *link) {
        
        NSString *displayString = NULL;
        
        switch (actionType) {
                
            case STLinkActionTypeAccount:
                displayString = [NSString stringWithFormat:@"Twitter account:\n%@", link];
                
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] goUserSearchView:[link substringFromIndex:1] viewController:self];
                break;
                
            case STLinkActionTypeHashtag:
                displayString = [NSString stringWithFormat:@"Twitter hashtag:\n%@", link];
                
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] goHashTagView:[link substringFromIndex:1] viewController:self];
                break;
                
            case STLinkActionTypeWebsite:
                displayString = [NSString stringWithFormat:@"Website:\n%@", link];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
                break;
        }
        NSLog(@"%@", displayString);
        
    };
    
    [_tweetLabel setCallbackBlock:callbackBlock];
    
    
    [myScrollView addSubview:_tweetLabel];
    
    
    [self initWithShotData:self.shotData];
    if (self.shotData == nil) {
        
    }else
        [self stopLoading];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [myScrollView setContentOffset:CGPointMake(0, -65)];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toggleProfile:(id)sender{
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    ProfileViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kProfileViewController"];
    [VC setUserId:[self.shotData objectForKey:@"user_id"]];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)toggleComment:(id)sender{
/*    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    CommentsViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kCommentsViewController"];
    [VC setShotData:self.shotData];
    [self.navigationController pushViewController:VC animated:YES];*/
    
    [[AppSharedData sharedInstance] setSelectedShotId:[self.shotData objectForKey:@"id"]];
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    VideoCommentsViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kVideoCommentsViewController"];
    [VC setShotData:self.shotData];
    if (sender == btnComments) {
        VC.isEditing = FALSE;
    }else
        VC.isEditing = TRUE;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)toggleCheer:(id)sender{
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    CheersViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kCheersViewController"];
    [VC setShotData:self.shotData];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)initWithShotData:(NSDictionary *)itemData{
    
    
    [self setShotData:itemData];
    
    [self getUserInfo:[itemData objectForKey:@"user_id"]];
    
    [lbText setText:[NSString stringWithFormat:@"%@",[itemData objectForKey:@"text"]==[NSNull null]?@"":[itemData objectForKey:@"text"]]];
    [lbText setHidden:TRUE];
    
    [btnCheers setTitle:[NSString stringWithFormat:@"%d peps", [[itemData objectForKey:@"cheers_count"] integerValue]]
               forState:UIControlStateNormal];
    [btnComments setTitle:[NSString stringWithFormat:@"%d comments", [[itemData objectForKey:@"comments_count"] integerValue]]               forState:UIControlStateNormal];
    
    [btnAddCheer setEnabled:TRUE];
    
    id shot_url = [itemData objectForKey:@"image_url"];
    if ([shot_url isEqual:[NSNull null]] ) {
        [imgShot setImage:[UIImage imageNamed:@"no-image-found.jpg"]];
    }else{
        //NSLog(@"shot image :%@", [itemData objectForKey:@"image_url"]);
        
        if ([[itemData objectForKey:@"image_url"] rangeOfString:@".mov"].location == NSNotFound) {
            [imgShot initWithImageAtURL:[NSURL URLWithString:[itemData objectForKey:@"image_url"] ]];
            [btnPlayMovie setHidden:TRUE];
            [btnAddCheer setEnabled:FALSE];
            
        }else{
            [btnPlayMovie setHidden:FALSE];
            [btnAddCheer setEnabled:TRUE];
            
            [imgShot initWithImageAtURL:[NSURL URLWithString:[itemData objectForKey:@"thumb_image_url"] ]];
        }
        
    }
    
    //tweet label
    //tweet label
    NSDictionary *user = [self.shotData objectForKey:@"user"];
    
    NSMutableString *tweetText = [NSMutableString stringWithFormat:@"|%@ %@"
                                  , [user objectForKey:@"username"]==[NSNull null]?@"":[user objectForKey:@"username"]
                                  , [itemData objectForKey:@"text"]==[NSNull null]?@"":[itemData objectForKey:@"text"]];
    
    NSArray *commentList = [self.shotData objectForKey:@"comments"];
    if ([commentList count] > 0) {
        for (int i = 0; i < [commentList count]; i++) {
            NSDictionary *item = [commentList objectAtIndex:i];
            [tweetText appendFormat:@"\n|%@ %@", [item objectForKey:@"user_name"], [item objectForKey:@"text"]];
        }
    }
    if ([tweetText isEqual:@""]) {
        btnComments.hidden = TRUE;
        self.tweetLabel.hidden = TRUE;
        /*
        [btnAddCheer setFrame:CGRectMake(btnAddCheer.frame.origin.x
                                         , _tweetLabel.frame.origin.y
                                         , btnAddCheer.frame.size.width
                                         , btnAddCheer.frame.size.height)];
        [btnAddComment setFrame:CGRectMake(btnAddComment.frame.origin.x
                                           , _tweetLabel.frame.origin.y
                                           , btnAddComment.frame.size.width
                                           , btnAddComment.frame.size.height)];
        [btnDetail setFrame:CGRectMake(btnDetail.frame.origin.x
                                       , _tweetLabel.frame.origin.y
                                       , btnDetail.frame.size.width
                                       , btnDetail.frame.size.height)];
        */
        
    }else{
        btnComments.hidden = FALSE;
        self.tweetLabel.hidden = FALSE;
        
        [_tweetLabel setText:tweetText];
        
        //[_tweetLabel setNeedsDisplay];
        
        CGRect twRect = _tweetLabel.frame;
        twRect.size.height = [_tweetLabel getFitSize].height+0;
        [_tweetLabel setFrame:twRect];
        /*
        [btnAddCheer setFrame:CGRectMake(btnAddCheer.frame.origin.x, _tweetLabel.frame.origin.y + _tweetLabel.frame.size.height + 15
                                         , btnAddCheer.frame.size.width, btnAddCheer.frame.size.height)];
        [btnAddComment setFrame:CGRectMake(btnAddComment.frame.origin.x, _tweetLabel.frame.origin.y + _tweetLabel.frame.size.height + 15
                                           , btnAddComment.frame.size.width, btnAddComment.frame.size.height)];
        [btnDetail setFrame:CGRectMake(btnDetail.frame.origin.x
                                       , _tweetLabel.frame.origin.y + _tweetLabel.frame.size.height + 15
                                       , btnDetail.frame.size.width, btnDetail.frame.size.height)];
        */
    }
    [myScrollView setContentSize:CGSizeMake(320, [ShotCell getCellHeight:self.shotData])];
    
    //[myScrollView setContentOffset:CGPointMake(0, 0)];
    
    
    if ([[self.shotData objectForKey:@"cheered"] intValue] == 1) {
        [btnAddCheer setImage:[UIImage imageNamed:@"btn_cheer_press.png"] forState:UIControlStateNormal];
    }else{
        [btnAddCheer setImage:[UIImage imageNamed:@"btn_cheer.png"] forState:UIControlStateNormal];
    }

    ///
    if ([self.shotData objectForKey:@"bar"] == [NSNull null]) {
        btnLocation.hidden = TRUE;
    }else{
        btnLocation.hidden = FALSE;
        
        [btnLocation setTitle:[[self.shotData objectForKey:@"bar"] objectForKey:@"name"] forState:UIControlStateNormal];
    }
    
    ///////
    /*    NSString *lastViewedString = [item objectForKey:TAG_PROGRAM_END_TIME];
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
     [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
     */
    NSDate *lastViewed = [NSDate date];//[dateFormatter dateFromString:lastViewedString] ;
    NSDateFormatter* df_utc = [[NSDateFormatter alloc] init];
    [df_utc setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [df_utc setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString *lastViewedString = [df_utc stringFromDate:lastViewed];
    lastViewed = [df_utc dateFromString:lastViewedString];
    NSLog(lastViewedString);
    
    NSString *startViewedString = [NSString stringWithFormat:@"%@",[[itemData objectForKey:@"created_at"] isEqual:[NSNull null]] ? @"" : [itemData objectForKey:@"created_at"]];
    //startViewedString = @"2013-09-12 01:34:11";
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init] ;
    [dateFormatter1 setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter1 setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startViewed = [startViewedString isEqual:@""] == TRUE || [startViewedString isEqual:@"(null)"] == TRUE ? [NSDate date] : [dateFormatter1 dateFromString:startViewedString] ;
    
    NSTimeInterval distanceBetweenDates = [lastViewed timeIntervalSinceDate:startViewed];
    if(distanceBetweenDates >= 0 && distanceBetweenDates < 60){
        NSString *timestr = [NSString stringWithFormat:@"%ds", (int)(distanceBetweenDates)%60];
        [lbUpdatedTime setTitle:timestr forState:UIControlStateNormal];
    }else if(distanceBetweenDates >= 60 && distanceBetweenDates < 60 * 60){
        NSString *timestr = [NSString stringWithFormat:@"%dm", (int)(distanceBetweenDates/60)%60];
        [lbUpdatedTime setTitle:timestr forState:UIControlStateNormal];
    }else if(distanceBetweenDates >= 3600 && distanceBetweenDates < 3600 * 24){
        NSString *timestr = [NSString stringWithFormat:@"%dh", (int)(distanceBetweenDates/3600)%24];
        [lbUpdatedTime setTitle:timestr forState:UIControlStateNormal];
    }else if(distanceBetweenDates >= 3600 * 24 && distanceBetweenDates < 3600 * 24 * 7){
        NSString *timestr = [NSString stringWithFormat:@"%dd", (int)(distanceBetweenDates/(3600*24))%7];
        [lbUpdatedTime setTitle:timestr forState:UIControlStateNormal];
    }else if(distanceBetweenDates >= 3600 * 24 * 7 ){
        NSString *timestr = [NSString stringWithFormat:@"%dw", (int)(distanceBetweenDates/(3600*24*7))];
        [lbUpdatedTime setTitle:timestr forState:UIControlStateNormal];
    }else{
        [lbUpdatedTime setTitle:@"0s" forState:UIControlStateNormal];
    }
    
}


- (void) getUserInfo:(NSString*)uid{
    
    /*
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users/%@?auth_token=%@"
                     , uid
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    
    data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    */
    
    NSDictionary *user = [self.shotData objectForKey:@"user"];
    
    [btnName setTitle:[user objectForKey:@"username"]==[NSNull null]?@"":[user objectForKey:@"username"] forState:UIControlStateNormal];
    
    //NSLog(@"%@", [user objectForKey:@"image_url"]);
    if ([user objectForKey:@"image_url"] == [NSNull null]) {
        
    }else
        [imgProfile initWithImageAtURL:[NSURL URLWithString:[user objectForKey:@"image_url"]]];
    
}

- (void)initWithShotID:(NSString *)shotid{
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots/%@?auth_token=%@"
                     , shotid
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    
    data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    [self startLoading];
}

- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    if (data==nil) data = [[NSMutableData alloc] initWithCapacity:2048];
    [data appendData:incrementalData];
}


- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection
{
    [self stopLoading];
    if(!data) {
        /*
         NSString *errorString = @"Can not connect Internet";
         UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Faild Reuestion" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [errorAlert show];
         */
        
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
                //NSLog(@"%@", url);
                NSLog(@"%@", aStr);
                NSLog(@"111error is %@", [error localizedDescription]);
                
                [self toggleBack:nil];
                return;
            }
            
            if (![aStr isEqualToString:@"{ \"error\":\"No User!\"}"]) {
                //userdata = jsonObjects;
                NSDictionary *user = jsonObjects;//[jsonObjects objectForKey:@"user"];
                if ([[self.shotData objectForKey:@"id"] isEqual:[jsonObjects objectForKey:@"id"]]) {
                    [self initWithShotData:jsonObjects];
                }else{
                    [self initWithShotData:user];
                }
            }
        }
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self stopLoading];
    [self toggleBack:nil];
}

- (IBAction)toggleAddComment:(id)sender{
/*    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    CommentsViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kCommentsViewController"];
    [VC setShotData:self.shotData];
    VC.isEditing = TRUE;
    [self.navigationController pushViewController:VC animated:YES];
 */
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setTempImage:nil];
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    UINavigationController *NC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kTakeVideoCommentNavigationController"];
    [[AppSharedData sharedInstance] setSelectedShotId:[self.shotData objectForKey:@"id"]];
    //    [self presentModalViewController:NC animated:NO];
    [self.navigationController presentViewController:NC animated:NO
                                          completion:nil];
}


- (IBAction)toggleAddCheer:(id)sender{
    /*    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
     
     CheersViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kCheersViewController"];
     [VC setShotData:self.shotData];
     [self.parentViewController.navigationController pushViewController:VC animated:YES];*/
    if ([[self.shotData objectForKey:@"cheered"] intValue] == 1) {
        [self toggleDeleteCheer:nil];
        
        [self.shotData setValue:[NSNumber numberWithInt:0] forKey:@"cheered"];
    }else{
        NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots/%@/cheers?auth_token=%@"
                         , [self.shotData objectForKey:@"id"]
                         , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
        
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
        
        [urlRequest setURL:[NSURL URLWithString:url]];
        [urlRequest setHTTPMethod:@"POST"];
        
        data = nil;
        connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        
        [self.shotData setValue:[NSString stringWithFormat:@"%d", [[self.shotData objectForKey:@"cheers_count"] integerValue] + 1] forKey:@"cheers_count"];
        [btnAddCheer setImage:[UIImage imageNamed:@"btn_cheer_press.png"] forState:UIControlStateNormal];
        [btnCheers setTitle:[NSString stringWithFormat:@"%d peps", [[self.shotData objectForKey:@"cheers_count"] integerValue]]
                   forState:UIControlStateNormal];
        
        
        [self.shotData setValue:[NSNumber numberWithInt:1] forKey:@"cheered"];
    }
}

- (IBAction)toggleDeleteCheer:(id)sender{
    [self.shotData setValue:[NSString stringWithFormat:@"%d", [[self.shotData objectForKey:@"cheers_count"] integerValue] - 1] forKey:@"cheers_count"];
    [btnAddCheer setImage:[UIImage imageNamed:@"btn_cheer.png"] forState:UIControlStateNormal];
    
    [btnCheers setTitle:[NSString stringWithFormat:@"%d peps", [[self.shotData objectForKey:@"cheers_count"] integerValue]]
               forState:UIControlStateNormal];
    /*
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots/%@/cheers/%@?auth_token=%@"
                     , [self.shotData objectForKey:@"id"]
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    NSLog(@"%@", url);
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"DELETE"];*/
    /*
     data = nil;
     NSData *urlData;
     NSURLResponse *theString;
     NSError *error;
     
     urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&theString error:&error];
     NSString *aStr = [[NSString alloc] initWithData:urlData encoding:NSISOLatin1StringEncoding];
     
     NSLog(@"%@", url);
     NSLog(@"%@", aStr);
     */
    /*data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    */
    
    [self performSelectorInBackground:@selector(deleteCheer) withObject:nil];
}

- (void)deleteCheer{
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots/%@/cheers/%@?auth_token=%@"
                     , [self.shotData objectForKey:@"id"]
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    NSLog(@"%@", url);
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"DELETE"];
    
     data = nil;
     NSData *urlData;
     NSURLResponse *theString;
     NSError *error;
     
     urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&theString error:&error];
     NSString *aStr = [[NSString alloc] initWithData:urlData encoding:NSISOLatin1StringEncoding];
     
     NSLog(@"%@", url);
     NSLog(@"%@", aStr);
     
}

- (void)imageDidLoad:(BOOL)isDown{
    
    [btnAddCheer setEnabled:TRUE];
//    NSArray *tagIds = [self.shotData objectForKey:@"tag_ids"];
    if ([[self.shotData objectForKey:@"user_id"] isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]
        //|| [tagIds containsObject:@"Shot"] == FALSE
        ) {
        //[btnAddCheer setEnabled:FALSE];
    }else{
        [btnAddCheer setEnabled:TRUE];
    }
    if (isDown == FALSE) {
        [btnAddCheer setEnabled:FALSE];
    }
    return;
}

- (IBAction)toggleDetail:(id)sender
{
    if ([[self.shotData objectForKey:@"user_id"] isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]){
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"Delete", nil];
        [actionSheet showInView:[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view]];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        
    }else{
        
    }
    
}

- (void)actionSheet:(UIActionSheet *)theActionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[self.shotData objectForKey:@"user_id"] isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]){
        
        if (buttonIndex == 2) {
            NSLog(@"cancel clicked");
            
            return;
        }
        
        if (buttonIndex == 0) {
            //delete shot
            [self toggleDeleteShot:nil];
        }
        
    }else{
        
    }
	
}

- (IBAction)toggleDeleteShot:(id)sender{
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots/%@?auth_token=%@"
                     , [self.shotData objectForKey:@"id"]
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    NSLog(@"%@", url);
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"DELETE"];
    
    
    data = nil;
    NSData *urlData;
    NSURLResponse *theString;
    NSError *error;
    
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&theString error:&error];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"update_list"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toggleLocation:(id)sender{
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    BarShotListViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kBarShotListViewController"];
    [VC setBarItem:[self.shotData objectForKey:@"bar"]];
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)startLoading{
    [loadingView setHidden:FALSE];
    [activityLoading startAnimating];
}

- (void)stopLoading{
    [loadingView setHidden:TRUE];
    [activityLoading stopAnimating];
}

- (IBAction)onClickPlay:(id)sender{
    if (cvChannelViewController == nil) {
        cvChannelViewController = [[MNetStreamingMovieViewController alloc] init];
        
    }
    [[cvChannelViewController view] setFrame:CGRectMake(imgShot.frame.origin.x
                                                        , imgShot.frame.origin.y
                                                        , imgShot.frame.size.width
                                                        , imgShot.frame.size.height)];
    
    //    [cvChannelViewController setStrMovieUrl:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];
    
    //[cvChannelViewController setStrMovieUrl:@"http://vf2.jumpcam.com/ve1p/l-vfmntuR2jVONZiu4n7V3HjrWBgA-hq.mp4"];
    [cvChannelViewController setStrMovieUrl:[self.shotData objectForKey:@"image_url"]];
    
    
    //[cvChannelViewController setStrMovieUrl:[[[self.programInfo objectForKey:TAG_PROGRAM_PATH_LIST] objectAtIndex:0] objectForKey:TAG_PROGRAM_PATH_URL_HLS]];
    //NSLog(@"%@",self.programInfo);
    
    //[cvChannelViewController setStrMovieUrl:@"http://192.168.0.68:1935/live/16_99_1/playlist.m3u8"];
    /*
     if (isLive) {
     [cvChannelViewController setStrMovieUrl:[self.programInfo objectForKey:TAG_PROGRAM_PATH_URL_HLS]];
     }else{
     [cvChannelViewController setStrMovieUrl:[self.programInfo objectForKey:TAG_PROGRAM_PATH_URL_HLS]];
     NSLog(@"%@",[self.programInfo objectForKey:TAG_PROGRAM_PATH_URL_HLS]);
     }
     
     */
    if (cvChannelViewController.bPlaying == TRUE) {
        
        [cvChannelViewController onClickPlayCloseButton:nil];
        [cvChannelViewController.view removeFromSuperview];
    }else{
        
        [myScrollView addSubview:cvChannelViewController.view];
        [cvChannelViewController startPlay];
        
    }
    
    //[self.view bringSubviewToFront:btnPlay];
    
    //[btnCloseMovie setHidden:FALSE];
    //[self.contentView bringSubviewToFront:btnCloseMovie];
}

@end
