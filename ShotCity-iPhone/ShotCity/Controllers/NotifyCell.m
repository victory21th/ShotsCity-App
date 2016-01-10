//
//  NotifyCell.m
//  ShotCity
//
//  Created by dev on 13. 10. 3..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import "NotifyCell.h"
#import "Image.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CommentsViewController.h"
#import "CheersViewController.h"
#import "STTweetLabel.h"
#import "BarShotListViewController.h"

@implementation NotifyCell
@synthesize ai,connection, data;
@synthesize cellData;
@synthesize imgShot, imgProfile, lbUpdatedTime;
@synthesize parentViewController;

+ (id)cellWithNib
{
    NotifyCell *cell;
    UIViewController *controller = [[UIViewController alloc] initWithNibName:@"NotifyCell" bundle:nil];
    cell = (NotifyCell *)controller.view;
    //cell.reuseIdentifier
    //[controller release];
    return cell;
}

+ (id)cellWithNib:(NSDictionary*)cellInfo{
	NotifyCell *cell;
    UIViewController *controller = [[UIViewController alloc] initWithNibName:@"NotifyCell" bundle:nil];
    cell = (NotifyCell *)controller.view;
    //[controller release];
	//[cell setShotData:cellInfo];
	
    return cell;
}

+ (id)cellWithReuseIdentifier:(NSString *)CellIdentifier{
    NotifyCell *cell;
    cell = [[NotifyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //[cell setFrame:CGRectMake(0, 0, 320, 500)];
    cell.imgProfile = [[Image alloc] initWithFrame:CGRectMake(20, 24, 70, 70)];
    [cell.imgProfile setImage:[UIImage imageNamed:@"no-profile.jpg"]];
    
    
    cell.imgShot = [[Image alloc] initWithFrame:CGRectMake(280, 24, 80, 80)];
    cell.lbUpdatedTime = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 186, 20)];
    
    [cell.contentView addSubview:cell.imgProfile];
    [cell.contentView addSubview:cell.imgShot];
    [cell.contentView addSubview:cell.lbUpdatedTime];
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.imgProfile = [[Image alloc] initWithFrame:CGRectMake(11, 9, 32, 32)];
        self.imgProfile.backgroundColor = [UIColor grayColor];
        self.imgProfile.layer.cornerRadius = 2;
        self.imgProfile.layer.masksToBounds = YES;
        self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
        [self.imgProfile setImage:[UIImage imageNamed:@"no-profile.jpg"]];
        
        btnProfileImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        [btnProfileImage addTarget:self action:@selector(toggleProfile:) forControlEvents:UIControlEventTouchUpInside];
        
        self.imgShot = [[Image alloc] initWithFrame:CGRectMake(260, 3, 50, 50)];
        [self.imgShot setDefaultImage:[UIImage imageNamed:@"no-image-found.jpg"]];
        self.imgShot.backgroundColor = [UIColor grayColor];
        self.imgShot.layer.cornerRadius = 1;
        self.imgShot.layer.masksToBounds = YES;
        self.imgShot.contentMode = UIViewContentModeScaleAspectFill;
        self.imgShot.delegate = self;
        
        self.lbUpdatedTime = [[UILabel alloc] initWithFrame:CGRectMake(50, 33, 186, 22)];
        [self.lbUpdatedTime setFont:[UIFont systemFontOfSize:NOTIFY_CELL_TWEET_FONT_SIZE]];
        [self.lbUpdatedTime setTextColor:[UIColor blackColor]];
        
        [self.contentView addSubview:self.imgProfile];
        [self.contentView addSubview:self.imgShot];
        [self.contentView addSubview:self.lbUpdatedTime];
        [self.contentView addSubview:btnProfileImage];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        btnDetail = [[UIButton alloc] initWithFrame:CGRectMake(260, 0, 60, 60)];
        //[btnDetail setImage:[UIImage imageNamed:@"img_detail.png"] forState:UIControlStateNormal];
        [btnDetail addTarget:self action:@selector(toggleDetail:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:btnDetail];
        
        _tweetLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(50, 7, NOTIFY_CELL_TWEET_WIDTH, 30.0)];
        [_tweetLabel setFont:[UIFont systemFontOfSize:NOTIFY_CELL_TWEET_FONT_SIZE]];
        [_tweetLabel setFontUser:[UIFont boldSystemFontOfSize:NOTIFY_CELL_TWEET_FONT_SIZE]];
        [_tweetLabel setTextColor:[UIColor blackColor]];
        [_tweetLabel setColorAccount:[UIColor blackColor]];
        [_tweetLabel setColorHashtag:[UIColor blackColor]];
        [_tweetLabel setColorUser:[UIColor blackColor]];
        [_tweetLabel setText:@"Hi. This is a new tool for @you! Developed by->@SebThiebaud for #iPhone #Obj-C... ;-) My GitHub page: https://www.github.com/SebastienThiebaud! \n Hi. This is a new tool for @you! Developed by->@SebThiebaud for #iPhone #Obj-C... ;-) My GitHub page: https://www.github.com/SebastienThiebaud!"];
        
        STLinkCallbackBlock callbackBlock = ^(STLinkActionType actionType, NSString *link) {
            
            NSString *displayString = NULL;
            
            switch (actionType) {
                    
                case STLinkActionTypeAccount:
                    displayString = [NSString stringWithFormat:@"Twitter account:\n%@", link];
                    
                    [(AppDelegate*)[[UIApplication sharedApplication] delegate] goUserSearchView:[link substringFromIndex:1] viewController:self.parentViewController];
                    break;
                    
                case STLinkActionTypeHashtag:
                    displayString = [NSString stringWithFormat:@"Twitter hashtag:\n%@", link];
                    
                    [(AppDelegate*)[[UIApplication sharedApplication] delegate] goHashTagView:[link substringFromIndex:1] viewController:self.parentViewController];
                    break;
                    
                case STLinkActionTypeWebsite:
                    displayString = [NSString stringWithFormat:@"Website:\n%@", link];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
                    break;
            }
            NSLog(@"%@", displayString);
            
        };
        
        [_tweetLabel setCallbackBlock:callbackBlock];
        
        
        [self.contentView addSubview:_tweetLabel];
    }
    
    return self;
}

- (void) initWithShotData:(NSDictionary*)itemData{
    [self setCellData:itemData];
    
    id shot_url = [itemData objectForKey:@"notifiable_image_url"];
    if ([shot_url isEqual:[NSNull null]] ) {
        [self.imgShot setImage:[UIImage imageNamed:@"no-image-found.jpg"]];
    }else{
        //NSLog(@"shot image :%@", [itemData objectForKey:@"image_url"]);
        [self.imgShot initWithImageAtURL:[NSURL URLWithString:shot_url]];
        
    }
    
    NSDictionary *user = [self.cellData objectForKey:@"sent_by"];
    
    //NSLog(@"%@", [user objectForKey:@"image_url"]);
    if ([user objectForKey:@"image_url"] == [NSNull null]) {
        
    }else
        [self.imgProfile initWithImageAtURL:[NSURL URLWithString:[user objectForKey:@"image_url"]]];
    
    //tweet label
    NSMutableString *tweetText = [NSMutableString stringWithFormat:@"|%@"
                                  , [itemData objectForKey:@"text"]==[NSNull null]?@"":[itemData objectForKey:@"text"]];
    if ([[self.cellData objectForKey:@"notifiable_type"] isEqual:@"Shot"]) {
        tweetText = [NSMutableString stringWithFormat:@"%@"
                     , [itemData objectForKey:@"text"]==[NSNull null]?@"":[itemData objectForKey:@"text"]];
    }else{
        tweetText = [NSMutableString stringWithFormat:@"%@"
                     , [itemData objectForKey:@"text"]==[NSNull null]?@"":[itemData objectForKey:@"text"]];
    }
    
    if ([tweetText isEqual:@""]) {
        
        
    }else{
        self.tweetLabel.hidden = FALSE;
        
        [_tweetLabel setText:tweetText];
        
        //[_tweetLabel setNeedsDisplay];
        
        CGRect twRect = _tweetLabel.frame;
        twRect.size.height = [_tweetLabel getFitSize].height+0;
        [_tweetLabel setFrame:twRect];
        
        
    }
    
    CGRect rc1 = lbUpdatedTime.frame;
    rc1.origin.y = [self getCellHeight] - 22;
    lbUpdatedTime.frame = rc1;
    
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
//    NSLog(lastViewedString);
    
    NSString *startViewedString = [NSString stringWithFormat:@"%@",[[itemData objectForKey:@"created_at"] isEqual:[NSNull null]] ? @"" : [itemData objectForKey:@"created_at"]];
    //startViewedString = @"2013-09-12 01:34:11";
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init] ;
    [dateFormatter1 setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter1 setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startViewed = [startViewedString isEqual:@""] == TRUE || [startViewedString isEqual:@"(null)"] == TRUE ? [NSDate date] : [dateFormatter1 dateFromString:startViewedString] ;
    
    NSTimeInterval distanceBetweenDates = [lastViewed timeIntervalSinceDate:startViewed];
    if(distanceBetweenDates >= 0 && distanceBetweenDates < 60){
        NSString *timestr = [NSString stringWithFormat:@"%d seconds ago", (int)(distanceBetweenDates)%60];
        [self.lbUpdatedTime setText:timestr];
    }else if(distanceBetweenDates >= 60 && distanceBetweenDates < 60 * 60){
        NSString *timestr = [NSString stringWithFormat:@"%d minutes ago", (int)(distanceBetweenDates/60)%60];
        [self.lbUpdatedTime setText:timestr];
    }else if(distanceBetweenDates >= 3600 && distanceBetweenDates < 3600 * 24){
        NSString *timestr = [NSString stringWithFormat:@"%d hours ago", (int)(distanceBetweenDates/3600)%24];
        [self.lbUpdatedTime setText:timestr];
    }else if(distanceBetweenDates >= 3600 * 24 && distanceBetweenDates < 3600 * 24 * 7){
        NSString *timestr = [NSString stringWithFormat:@"%d days ago", (int)(distanceBetweenDates/(3600*24))%7];
        [self.lbUpdatedTime setText:timestr];
    }else if(distanceBetweenDates >= 3600 * 24 * 7 ){
        NSString *timestr = [NSString stringWithFormat:@"%d weeks ago", (int)(distanceBetweenDates/(3600*24*7))];
        [self.lbUpdatedTime setText:timestr];
    }else{
        [self.lbUpdatedTime setText:@"0 second ago"];
    }
    
}

- (void)toggleProfile:(id)sender{
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    ProfileViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kProfileViewController"];
    [VC setUserId:[[self.cellData objectForKey:@"sent_by"] objectForKey:@"id"]];
    [self.parentViewController.navigationController pushViewController:VC animated:YES];
}

- (IBAction)toggleDetail:(id)sender
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate goShotView:[self.cellData objectForKey:@"notifiable_id"]];
}

- (float)getCellHeight{
    CGFloat result = 25;
    CGFloat defaultHeight = 55;
    
    if ([_tweetLabel.text isEqual:@""]) {
        return defaultHeight;
        
    }
    
    result += _tweetLabel.frame.size.height;
    if (result < defaultHeight) {
        return defaultHeight;
    }
    
    return result;
}
+ (NSInteger)getCellHeight:(NSDictionary *)itemData{
    CGFloat result = 25;
    CGFloat defaultHeight = 55;
    //tweet label
    NSMutableString *tweetText = [NSMutableString stringWithFormat:@"|%@"
                                  , [itemData objectForKey:@"text"]==[NSNull null]?@"":[itemData objectForKey:@"text"]];
    if ([[itemData objectForKey:@"notifiable_type"] isEqual:@"Shot"]) {
        tweetText = [NSMutableString stringWithFormat:@"%@"
                     , [itemData objectForKey:@"text"]==[NSNull null]?@"":[itemData objectForKey:@"text"]];
    }else{
        tweetText = [NSMutableString stringWithFormat:@"%@"
                     , [itemData objectForKey:@"text"]==[NSNull null]?@"":[itemData objectForKey:@"text"]];
    }
    
    if ([tweetText isEqual:@""]) {
        return defaultHeight;
        
    }
    
    result += [STTweetLabel getFitHeightWithText:tweetText boundWidth:200 font:[UIFont boldSystemFontOfSize:NOTIFY_CELL_TWEET_FONT_SIZE] color:[UIColor grayColor]];
    if (result < defaultHeight) {
        return defaultHeight;
    }
    
    return result;
}

@end
