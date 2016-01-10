//
//  SearchCell.m
//  ShotsCity
//
//  Created by dev on 13. 10. 31..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import "SearchCell.h"
#import "Image.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CommentsViewController.h"
#import "CheersViewController.h"
#import "STTweetLabel.h"
#import "BarShotListViewController.h"

@implementation SearchCell
@synthesize ai,connection, data;
@synthesize shotData;
@synthesize imgShot, imgProfile, lbUpdatedTime, lbName, btnName, btnLocation;
@synthesize parentViewController;

+ (id)cellWithNib
{
    SearchCell *cell;
    UIViewController *controller = [[UIViewController alloc] initWithNibName:@"SearchCell" bundle:nil];
    cell = (SearchCell *)controller.view;
    //cell.reuseIdentifier
    //[controller release];
    return cell;
}

+ (id)cellWithNib:(NSDictionary*)cellInfo{
	SearchCell *cell;
    UIViewController *controller = [[UIViewController alloc] initWithNibName:@"SearchCell" bundle:nil];
    cell = (SearchCell *)controller.view;
    //[controller release];
	[cell setShotData:cellInfo];
	
    return cell;
}

+ (id)cellWithReuseIdentifier:(NSString *)CellIdentifier{
    SearchCell *cell;
    cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //[cell setFrame:CGRectMake(0, 0, 320, 500)];
    cell.imgProfile = [[Image alloc] initWithFrame:CGRectMake(20, 24, 70, 70)];
    [cell.imgProfile setImage:[UIImage imageNamed:@"no-profile.jpg"]];
    
    
    cell.imgShot = [[Image alloc] initWithFrame:CGRectMake(20, 108, 280, 300)];
    cell.lbName = [[UILabel alloc] initWithFrame:CGRectMake(105, 20, 186, 20)];
    cell.lbUpdatedTime = [[UILabel alloc] initWithFrame:CGRectMake(20, 410, 186, 20)];
    
    [cell.contentView addSubview:cell.imgProfile];
    [cell.contentView addSubview:cell.imgShot];
    //[cell.contentView addSubview:cell.lbUpdatedTime];
    [cell.contentView addSubview:cell.lbName];
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *separator_line = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1, 320, 2)];
        [separator_line setImage:[UIImage imageNamed:@"shotlist_line.png"]];
        [self.contentView addSubview:separator_line];
        
        self.btnLocation = [[UIButton alloc] initWithFrame:CGRectMake(52, 32, 186, 20)];
        [self.btnLocation addTarget:self action:@selector(toggleLocation:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnLocation setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        //[self.btnLocation setTitleColor:[[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.5 alpha:1] forState:UIControlStateNormal];
        [self.btnLocation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnLocation setTitleColor:[UIColor colorWithRed:0.8 green:0.0 blue:0.8 alpha:1.0] forState:UIControlStateHighlighted];
        [self.btnLocation setImage:[UIImage imageNamed:@"icon_pin.png"] forState:UIControlStateNormal];
        [self.btnLocation setContentEdgeInsets:UIEdgeInsetsMake(0, 3, 3, 0)];
        [self.btnLocation setTitleEdgeInsets:UIEdgeInsetsMake(2, 3, 0, 0)];
        
        [self.btnLocation.titleLabel setFont:[UIFont systemFontOfSize:11]];
        
        [self.contentView addSubview:self.btnLocation];
        
        self.imgProfile = [[Image alloc] initWithFrame:CGRectMake(10, 10, 38, 38)];
        self.imgProfile.backgroundColor = [UIColor grayColor];
        self.imgProfile.layer.cornerRadius = 2;
        self.imgProfile.layer.masksToBounds = YES;
        self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
        [self.imgProfile setImage:[UIImage imageNamed:@"no-profile.jpg"]];
        
        btnProfileImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        [btnProfileImage addTarget:self action:@selector(toggleProfile:) forControlEvents:UIControlEventTouchUpInside];
        
        self.imgShot = [[Image alloc] initWithFrame:CGRectMake(245, 3, 65, 65)];
        [self.imgShot setDefaultImage:[UIImage imageNamed:@"no-image-found.jpg"]];
        self.imgShot.backgroundColor = [UIColor grayColor];
        self.imgShot.layer.cornerRadius = 1;
        self.imgShot.layer.masksToBounds = YES;
        self.imgShot.contentMode = UIViewContentModeScaleAspectFill;
        self.imgShot.delegate = self;
        
        
        self.lbText = [[UITextView alloc] initWithFrame:CGRectMake(45, 14, 186, 20)];
        [self.lbText setFont:[UIFont fontWithName:@"Helvetica" size:7]];
        [self.lbText setTextColor:[UIColor grayColor]];
        [self.lbText setText:@""];
        [self.lbText setEditable:FALSE];
        
        [self.contentView addSubview:self.imgProfile];
        [self.contentView addSubview:self.imgShot];
        //[self.contentView addSubview:self.lbUpdatedTime];
        //[self.contentView addSubview:self.lbName];
        //[self.contentView addSubview:self.lbText];
        [self.contentView addSubview:btnProfileImage];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.btnName == nil) {
            self.btnName = [[UIButton alloc] initWithFrame:CGRectMake(55, 5, 186, 30)];
            [self.btnName addTarget:self action:@selector(toggleProfile:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.btnName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            
            [self.btnName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.btnName setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateHighlighted];
            [self.btnName.titleLabel setFont:[UIFont systemFontOfSize:16]];
            
            [self.contentView addSubview:self.btnName];
        }
        
    }
    
    return self;
}

- (void) initWithShotData:(NSDictionary*)itemData{
    [self setShotData:itemData];
    
    
    [self getUserInfo:[itemData objectForKey:@"user_id"]];
    
    
    //[self.lbUpdatedTime setFont:[UIFont fontWithName:@"System" size:9]];
    
    //[self.lbUpdatedTime setText:[NSString stringWithFormat:@"%@",[itemData objectForKey:@"text"]==[NSNull null]?@"":[itemData objectForKey:@"text"]]];
    
    [self.lbText setText:[NSString stringWithFormat:@"%@",[itemData objectForKey:@"text"]==[NSNull null]?@"":[itemData objectForKey:@"text"]]];
    [lbText setHidden:TRUE];
    
    [btnCheers setTitle:[NSString stringWithFormat:@"%d peps", [itemData objectForKey:@"cheers_count"] ==[NSNull null] ? 0 : [[itemData objectForKey:@"cheers_count"] integerValue]]
               forState:UIControlStateNormal];
    
    [btnComments setTitle:[NSString stringWithFormat:@"%d comments", [itemData objectForKey:@"comments_count"] == [NSNull null] ? 0 : [[itemData objectForKey:@"comments_count"] integerValue]]               forState:UIControlStateNormal];
    
    //
    
    
    //[btnAddCheer setEnabled:FALSE];
    
    id shot_url = [itemData objectForKey:@"image_url"];
    if ([shot_url isEqual:[NSNull null]] ) {
        [self.imgShot setImage:[UIImage imageNamed:@"no-image-found.jpg"]];
    }else{
        //NSLog(@"shot image :%@", [itemData objectForKey:@"image_url"]);
        [self.imgShot initWithImageAtURL:[NSURL URLWithString:[itemData objectForKey:@"image_url"] ]];
        
    }
    
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
    
    if ([[self.shotData objectForKey:@"cheered"] intValue] == 1) {
        [btnAddCheer setImage:[UIImage imageNamed:@"btn_cheer_press.png"] forState:UIControlStateNormal];
    }else{
        [btnAddCheer setImage:[UIImage imageNamed:@"btn_cheer.png"] forState:UIControlStateNormal];
    }
    
    if ([self.shotData objectForKey:@"bar"] == [NSNull null]) {
        self.btnLocation.hidden = TRUE;
    }else{
        self.btnLocation.hidden = FALSE;
        
        [self.btnLocation setTitle:[[self.shotData objectForKey:@"bar"] objectForKey:@"name"] forState:UIControlStateNormal];
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
        [self.lbUpdatedTime setTitle:timestr forState:UIControlStateNormal];
    }else if(distanceBetweenDates >= 60 && distanceBetweenDates < 60 * 60){
        NSString *timestr = [NSString stringWithFormat:@"%dm", (int)(distanceBetweenDates/60)%60];
        [self.lbUpdatedTime setTitle:timestr forState:UIControlStateNormal];
    }else if(distanceBetweenDates >= 3600 && distanceBetweenDates < 3600 * 24){
        NSString *timestr = [NSString stringWithFormat:@"%dh", (int)(distanceBetweenDates/3600)%24];
        [self.lbUpdatedTime setTitle:timestr forState:UIControlStateNormal];
    }else if(distanceBetweenDates >= 3600 * 24 && distanceBetweenDates < 3600 * 24 * 7){
        NSString *timestr = [NSString stringWithFormat:@"%dd", (int)(distanceBetweenDates/(3600*24))%7];
        [self.lbUpdatedTime setTitle:timestr forState:UIControlStateNormal];
    }else if(distanceBetweenDates >= 3600 * 24 * 7 ){
        NSString *timestr = [NSString stringWithFormat:@"%dw", (int)(distanceBetweenDates/(3600*24*7))];
        [self.lbUpdatedTime setTitle:timestr forState:UIControlStateNormal];
    }else{
        [self.lbUpdatedTime setTitle:@"0s" forState:UIControlStateNormal];
    }
    
}


- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    if (data==nil) data = [[NSMutableData alloc] initWithCapacity:2048];
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection
{
    if(!data) {
        /*
         NSString *errorString = @"Can not connect Internet";
         UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Faild Reuestion" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [errorAlert show];
         */
        
    }else {
        NSString *aStr = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        
        //NSLog(@"%@", url);
        //NSLog(@"%@", aStr);
        
        //NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"location_id"]);
        NSError *error = nil;
        NSData *jsonData = [aStr dataUsingEncoding:NSUTF8StringEncoding];
        
        if (jsonData) {
            
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            if (error) {
                //NSLog(@"%@", url);
                NSLog(@"%@", aStr);
                NSLog(@"111error is %@", [error localizedDescription]);
                return;
            }
            
            if (![aStr isEqualToString:@"{ \"error\":\"No User!\"}"]) {
                //userdata = jsonObjects;
                NSDictionary *user = [jsonObjects objectForKey:@"user"];
                
                if (user == nil || [user isEqual:nil]) {
                    if ([jsonObjects isKindOfClass:[NSDictionary class]]) {
                        if ([jsonObjects objectForKey:@"id"] != nil && [[jsonObjects objectForKey:@"id"] isEqual:[NSNull null]] == FALSE ) {
                            
                            [self.shotData setValue:[NSString stringWithFormat:@"%d", [[self.shotData objectForKey:@"cheers_count"] integerValue]] forKey:@"cheers_count"];
                            
                            [btnCheers setTitle:[NSString stringWithFormat:@"%d peps", [[self.shotData objectForKey:@"cheers_count"] integerValue]]
                                       forState:UIControlStateNormal];
                        }else{
                            //[self toggleDeleteCheer:nil];
                        }
                        
                    }
                    
                    return;
                }
                //Image *profileImg = [[Image alloc] initWithFrame:CGRectMake(6, 6, 90, 90)];
                
                //[profileImg initWithImageAtURL:[NSURL URLWithString:[user objectForKey:@"image_url"]]];
                //[profileImg setImage:[UIImage imageNamed:@"no-profile.jpg"]];
                //[self.contentView addSubview:profileImg];
                
                //[self.lbName setText:[user objectForKey:@"name"]];
                [self.btnName setTitle:[user objectForKey:@"username"]==[NSNull null]?@"":[user objectForKey:@"username"] forState:UIControlStateNormal];
                
                //NSLog(@"%@", [user objectForKey:@"image_url"]);
                if ([user objectForKey:@"image_url"] == [NSNull null]) {
                    
                }else
                    [self.imgProfile initWithImageAtURL:[NSURL URLWithString:[user objectForKey:@"image_url"]]];
                
            }
        }
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
    
    [self.btnName setTitle:[user objectForKey:@"username"]==[NSNull null]?@"":[user objectForKey:@"username"] forState:UIControlStateNormal];
    
    //NSLog(@"%@", [user objectForKey:@"image_url"]);
    if ([user objectForKey:@"image_url"] == [NSNull null]) {
        
    }else
        [self.imgProfile initWithImageAtURL:[NSURL URLWithString:[user objectForKey:@"image_url"]]];
}

- (void)toggleProfile:(id)sender{
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    ProfileViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kProfileViewController"];
    [VC setUserId:[[self.shotData objectForKey:@"user"] objectForKey:@"id"]];
    [self.parentViewController.navigationController pushViewController:VC animated:YES];
}

- (IBAction)toggleComment:(id)sender{
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    CommentsViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kCommentsViewController"];
    [VC setShotData:self.shotData];
    if (sender == btnComments) {
        VC.isEditing = FALSE;
    }else
        VC.isEditing = TRUE;
    [self.parentViewController.navigationController pushViewController:VC animated:YES];
}

- (IBAction)toggleCheer:(id)sender{
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    CheersViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kCheersViewController"];
    [VC setShotData:self.shotData];
    [self.parentViewController.navigationController pushViewController:VC animated:YES];
}

- (IBAction)toggleAddComment:(id)sender{
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    CommentsViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kCommentsViewController"];
    [VC setShotData:self.shotData];
    VC.isEditing = TRUE;
    [self.parentViewController.navigationController pushViewController:VC animated:YES];
}

- (IBAction)toggleAddCheer:(id)sender{
    /*    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
     
     CheersViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kCheersViewController"];
     [VC setShotData:self.shotData];
     [self.parentViewController.navigationController pushViewController:VC animated:YES];*/
    if ([[self.shotData objectForKey:@"cheered"] intValue] == 1) {
        [self toggleDeleteCheer:nil];
        
        [self.shotData setValue:[NSNumber numberWithInt:0] forKey:@"cheered"];
        [btnAddCheer setImage:[UIImage imageNamed:@"btn_cheer.png"] forState:UIControlStateNormal];
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
        [btnCheers setTitle:[NSString stringWithFormat:@"%d peps", [[self.shotData objectForKey:@"cheers_count"] integerValue]]
                   forState:UIControlStateNormal];
        
        
        [self.shotData setValue:[NSNumber numberWithInt:1] forKey:@"cheered"];
        [btnAddCheer setImage:[UIImage imageNamed:@"btn_cheer_press.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)toggleDeleteCheer:(id)sender{
    [self.shotData setValue:[NSString stringWithFormat:@"%d", [[self.shotData objectForKey:@"cheers_count"] integerValue] - 1] forKey:@"cheers_count"];
    [btnAddCheer setImage:[UIImage imageNamed:@"btn_cheer.png"] forState:UIControlStateNormal];
    [btnCheers setTitle:[NSString stringWithFormat:@"%d peps", [[self.shotData objectForKey:@"cheers_count"] integerValue]]
               forState:UIControlStateNormal];
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots/%@/cheers/%@?auth_token=%@"
                     , [self.shotData objectForKey:@"id"]
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"DELETE"];
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
    data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
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
    
    [self.parentViewController viewWillAppear:YES];
}

+ (NSInteger)getCellHeight:(NSDictionary *)itemData{
    CGFloat result = 70;
    
    return result;
}

- (void)imageDidLoad:(BOOL)isDown{
    [btnAddCheer setEnabled:TRUE];
    //NSArray *tagIds = [self.shotData objectForKey:@"tag_ids"];
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

- (IBAction)toggleLocation:(id)sender{
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    BarShotListViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kBarShotListViewController"];
    [VC setBarItem:[self.shotData objectForKey:@"bar"]];
    [self.parentViewController.navigationController pushViewController:VC animated:YES];
    
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
@end
