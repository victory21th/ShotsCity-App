//
//  CommentsViewController.m
//  ShotCity
//
//  Created by dev on 13. 8. 28..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import "CommentsViewController.h"
#import "Image.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "STTweetLabel.h"
#import "SearchUserListViewController.h"

@interface CommentsViewController ()
@property (strong, nonatomic) UIPanGestureRecognizer *navigationBarPanGestureRecognizer;

@end

@implementation CommentsViewController
@synthesize shotData;
@synthesize imgShot;

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
        
        [myTableView setScrollIndicatorInsets:UIEdgeInsetsMake(65, 0, 51, 0)];
        [myTableView setContentInset:UIEdgeInsetsMake(65, 0, 51, 0)];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    commentList = [[NSMutableArray alloc] init];
    
    self.sideSwipeView = [[UIViewController alloc] initWithNibName:@"MasterSideSwipeView" bundle:nil].view;
    [self setupSideSwipeView];
    
    [myTableView setSeparatorColor:[UIColor colorWithWhite:0 alpha:0.2]];
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    searchUserListViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"kSearchUserListViewController"];
    searchUserListViewController.view.frame = CGRectMake(0, 34, 320, self.view.frame.size.height - 34 - 205);
    searchUserListViewController.sharePhotoViewController = self;
    
    [self.view addSubview:searchUserListViewController.view];
    searchUserListViewController.view.hidden = TRUE;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.isEditing) {
        [txtComment becomeFirstResponder];
    }else{
        [txtComment resignFirstResponder];
        [self unFocusTextview];
    }
    
    
    id shot_url = [self.shotData objectForKey:@"image_url"];
    if ([shot_url isEqual:[NSNull null]] ) {
        [self.imgShot setImage:[UIImage imageNamed:@"no-image-found.jpg"]];
    }else{
        NSLog(@"shot image :%@", [self.shotData objectForKey:@"image_url"]);
        [self.imgShot initWithImageAtURL:[NSURL URLWithString:[self.shotData objectForKey:@"image_url"] ]];
        
    }
    
    [self getCommentList];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [commentList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 87;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 87)];
    imgShot.frame = CGRectMake(119, 3, 81, 81);
    [headerView addSubview:imgShot];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat result = 45;
    
    NSDictionary *itemData = [commentList objectAtIndex:indexPath.row];
    NSString *tweetText = [NSString stringWithFormat:@"%@",[itemData objectForKey:@"text"]==[NSNull null]?@"":[itemData objectForKey:@"text"]];
    
    if ([tweetText isEqual:@""]) {
        return 45;
    }
    result += [STTweetLabel getFitHeightWithText:tweetText boundWidth:260.0 font:[UIFont boldSystemFontOfSize:12] color:[UIColor grayColor]];
    
    return result;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Section0 %i", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *item = [commentList objectAtIndex:indexPath.row];
    
    Image *imgProfile;
    UILabel *ttitle;
    //UILabel *stitle;
    STTweetLabel *subTitle;
    UIButton *btnName;
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        //tableView.separatorColor = [UIColor grayColor];
        
        CGRect rc = cell.textLabel.frame;
        rc.origin.x = 45;
        cell.textLabel.frame = rc;
        
        imgProfile = [[Image alloc] initWithFrame:CGRectMake(8, 9, 29, 29)];
        [imgProfile setDefaultImage:[UIImage imageNamed:@"no-profile.jpg"]];
        imgProfile.tag = 100;
        
        btnName = [[UIButton alloc] initWithFrame:CGRectMake(45, 8, 320, 20)];
        [btnName addTarget:self action:@selector(toggleProfile:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [btnName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnName setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateHighlighted];
        [btnName.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        
        [cell.contentView addSubview:btnName];
        btnName.tag = 400;
        
        ttitle = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 320, 20)];
        ttitle.font = [UIFont boldSystemFontOfSize:13];
        ttitle.textColor    = [UIColor blackColor];
        ttitle.textAlignment = UITextAlignmentLeft;
        ttitle.tag = 200;
        
        /*
        stitle = [[UILabel alloc] initWithFrame:CGRectMake(45, 25, 320, 20)];
        stitle.font = [UIFont boldSystemFontOfSize:13];
        stitle.textColor    = [UIColor blackColor];
        stitle.textAlignment = UITextAlignmentLeft;
        stitle.tag = 300;
        */
        
        [cell.contentView addSubview:imgProfile];
        //[cell.contentView addSubview:ttitle];
        //[cell.contentView addSubview:stitle];
        
        subTitle = [[STTweetLabel alloc] initWithFrame:CGRectMake(45, 27, 260.0, 130.0)];
        //[subTitle setFont:[UIFont boldSystemFontOfSize:12]];
        //[subTitle setTextColor:[UIColor grayColor]];
        [subTitle setText:@"Hi. This is a new tool for @you! Developed by->@SebThiebaud for #iPhone #Obj-C... ;-) My GitHub page: https://www.github.com/SebastienThiebaud! \n Hi. This is a new tool for @you! Developed by->@SebThiebaud for #iPhone #Obj-C... ;-) My GitHub page: https://www.github.com/SebastienThiebaud!"];
        subTitle.tag = 300;
        
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
        
        [subTitle setCallbackBlock:callbackBlock];
        
        
        [cell.contentView addSubview:subTitle];
    }else{
        imgProfile = (Image*)[cell viewWithTag:100];
        ttitle = (UILabel*)[cell viewWithTag:200];
        subTitle = (STTweetLabel*)[cell viewWithTag:300];
        btnName = (UIButton*)[cell viewWithTag:400];
    }
    
    cell.contentView.tag = indexPath.row;
    
    [imgProfile initWithImageAtURL:[NSURL URLWithString:[item objectForKey:@"user_image_url"]]];
    [ttitle setText:[item objectForKey:@"user_name"]==[NSNull null]?@"":[item objectForKey:@"user_name"]];
    [btnName setTitle:[item objectForKey:@"user_name"]==[NSNull null]?@"":[item objectForKey:@"user_name"] forState:UIControlStateNormal];
    //[stitle setText:[item objectForKey:@"text"]];
    //cell.textLabel.text = [item objectForKey:@"name"];
    
    [subTitle setText:[item objectForKey:@"text"]];
    
    //[_tweetLabel setNeedsDisplay];
    
    CGRect twRect = subTitle.frame;
    twRect.size.height = [subTitle getFitSize].height+0;
    [subTitle setFrame:twRect];
    
    return cell;
}


- (void) getCommentList{
    
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots/%@/comments?auth_token=%@"
                     , [self.shotData objectForKey:@"id"]//shot id
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    NSLog(@"%@", url);
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    
    data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    
}


- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    if (data==nil) data = [[NSMutableData alloc] initWithCapacity:2048];
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection
{
    [self stopLoading];
    
    if(!data) {
        NSString *errorString = @"Can not connect Internet";
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Faild Reuestion" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        
        
    }else {
        NSString *aStr = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        
        NSLog(@"%@", aStr);
        
        //NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"location_id"]);
        NSError *error = nil;
        NSData *jsonData = [aStr dataUsingEncoding:NSUTF8StringEncoding];
        
        if (jsonData) {
            
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            if (error) {
                NSLog(@"error is %@", [error localizedDescription]);
                if ([txtComment.text isEqual:@""] == FALSE) {
                    [txtComment setText:@""];
                    [txtComment setEnabled:YES];
                    
                    [self getCommentList];
                }
            }
            
            if (![aStr isEqualToString:@"{ \"error\":\"No User!\"}"]) {
                //userdata = jsonObjects;
                if ([jsonObjects isKindOfClass:[NSDictionary class]]) {
                    [txtComment setText:@""];
                    [txtComment setEnabled:YES];
                    
                    [self getCommentList];
                }else{
                    commentList = jsonObjects;
                    
                    [myTableView reloadData];
                }
            }
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self stopLoading];
    
    NSString *errorString = @"Can not connect Internet";
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Faild Reuestion" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
}

- (void)toggleAddComment:(id)sender{
    [self startLoading];
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots/%@/comments?auth_token=%@"
                     , [self.shotData objectForKey:@"id"]//shot id
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    NSLog(@"%@", url);
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"text=%@", txtComment.text];
    [urlRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    
    [txtComment resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"%@, %@", txtComment.text, string);
    if ([txtComment.text length] > 1) {
        [btnSend setEnabled:YES];
    }else
        [btnSend setEnabled:NO];
    if([string isEqualToString:@"\n"]) {
        [self toggleAddComment:nil];
        return NO;
    }
    
    if ([string isEqualToString:@"@"]) {
        searchUserListViewController.view.hidden = FALSE;
    }
    
    if ([string isEqualToString:@" "]) {
        searchUserListViewController.view.hidden = TRUE;
    }else{
        NSArray *words = [[NSString stringWithFormat:@"%@%@" ,txtComment.text, string] componentsSeparatedByString:@"@"];
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
    
    return TRUE;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self focusTextview];
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self unFocusTextview];
    
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [super scrollViewWillBeginDragging:scrollView];
    
    [txtComment resignFirstResponder];
    
}

- (void) focusTextview{
    CGRect rc = viewSendArea.frame;
    if (self.view.frame.size.height > 540) {
        rc.origin.y = self.view.frame.size.height - 217 - rc.size.height;
    }else
        rc.origin.y = self.view.frame.size.height - 217 - rc.size.height;
    [viewSendArea setFrame:rc];
    
    rc = myTableView.frame;
    rc.size.height = viewSendArea.frame.origin.y - rc.origin.y;
    [myTableView setFrame:rc];
}

- (void) unFocusTextview{
    
    
    CGRect rc = viewSendArea.frame;
    rc.origin.y = self.view.frame.size.height - rc.size.height;
    if (rc.origin.y > 510) {
        rc.origin.y -= 50;
    }else
        rc.origin.y -= 50;
    [viewSendArea setFrame:rc];
    
    rc = myTableView.frame;
    rc.size.height = viewSendArea.frame.origin.y - rc.origin.y;
    [myTableView setFrame:rc];
}

- (void)toggleProfile:(id)sender{
/*    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    NSDictionary *item = [commentList objectAtIndex:indexPath.row];
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    ProfileViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kProfileViewController"];
    [VC setUserId:[item objectForKey:@"user_id"]];
    [self.navigationController pushViewController:VC animated:YES];*/
    
    UITableViewCell *cell = (UITableViewCell *)[sender superview];
//    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    NSDictionary *item = [commentList objectAtIndex:cell.tag];
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    ProfileViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kProfileViewController"];
    [VC setUserId:[item objectForKey:@"user_id"]];
    [self.navigationController pushViewController:VC animated:YES];
}

/////////////////////////////////////////////////
///////////// SWIPE ////////////

- (void) setupSideSwipeView
{
    self.swipeCellXPositionOffset = 250;
    
    [self.sideSwipeView setFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 40)];
    //////////////////////////////////////////
    // Add the background pattern for the side swipe cell
    //////////////////////////////////////////
    //self.sideSwipeView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"sideSwipeBG-dark.png"]];
    
    // Overlay a shadow image that adds a subtle darker drop shadow around the edges
    /*  UIImage* shadow = [[UIImage imageNamed:@"inner-shadow.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
     UIImageView* shadowImageView = [[UIImageView alloc] initWithFrame:sideSwipeView.bounds];
     shadowImageView.alpha = 0.6;
     shadowImageView.image = shadow;
     shadowImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
     [self.sideSwipeView insertSubview:shadowImageView atIndex:0];
     */
    
    /*
    favoriteButton = (UIButton *)[self.sideSwipeView viewWithTag:1];
    [favoriteButton addTarget:self action:@selector(favoriteClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    hideButton = (UIButton *)[self.sideSwipeView viewWithTag:2];
    [hideButton addTarget:self action:@selector(hideClicked:) forControlEvents:UIControlEventTouchUpInside];
    shoppingButton = (UIButton *)[self.sideSwipeView viewWithTag:3];
    [shoppingButton addTarget:self action:@selector(shoppingClicked:) forControlEvents:UIControlEventTouchUpInside];
    */
    //[self addPanGuestureRecognizer];
    [self addPanGuestureRecognizer];
}


- (void)addPanGuestureRecognizer {
    
    UIViewController *controller = self.tabBarController.parentViewController; // MainViewController : GHRevealController
    if ([controller respondsToSelector:@selector(revealGesture:)] && [controller respondsToSelector:@selector(revealToggle:)])
	{
		// Check if a UIPanGestureRecognizer already sits atop our NavigationBar.
		if (![[self.navigationController.navigationBar gestureRecognizers] containsObject:self.navigationBarPanGestureRecognizer])
		{
			// If not, allocate one and add it.
			UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:controller action:@selector(revealGesture:)];
			self.navigationBarPanGestureRecognizer = panGestureRecognizer;
			
			[self.navigationController.navigationBar addGestureRecognizer:self.navigationBarPanGestureRecognizer];
		}
        
        // Check if a UIPanGestureRecognizer already sits atop our View.
		if (![[self.view gestureRecognizers] containsObject:self.navigationBarPanGestureRecognizer])
		{
			// If not, allocate one and add it.
			UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:controller action:@selector(revealGesture:)];
			self.navigationBarPanGestureRecognizer = panGestureRecognizer;
			
			[self.view addGestureRecognizer:self.navigationBarPanGestureRecognizer];
		}
		
		// Check if we have a revealButton already.
		if (![self.navigationItem leftBarButtonItem]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerSelectedOption:) name:@"MenuSelectedOption" object:nil];
			// If not, allocate one and add it.
			UIImage *imageMenu = [UIImage imageNamed:@"button-menu"];
            UIBarButtonItem *itemMenu = [[UIBarButtonItem alloc] initWithImage:imageMenu
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:controller
                                                                        action:@selector(revealToggle:)];
            UIImage *imgMenuBkg = [[UIImage imageNamed:@"barButton-left"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
            [itemMenu setBackgroundImage:imgMenuBkg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
            self.navigationItem.leftBarButtonItem = itemMenu;
		}
	}
}

///////////////
///////////////
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        //[self toggleShare:nil];
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
    NSMutableArray *words = (NSMutableArray*)[[NSString stringWithFormat:@"%@" ,txtComment.text] componentsSeparatedByString:@"@"];
    if ([words count] > 1) {
        [words removeObjectAtIndex:[words count]-1];
        [words addObject:[NSString stringWithFormat:@"%@ ", username]];
        
        txtComment.text = [words componentsJoinedByString:@"@"];
        
        searchUserListViewController.view.hidden = TRUE;
    }
}

- (void)startLoading{
    [loadingView setHidden:FALSE];
    [activityLoading startAnimating];
}

- (void)stopLoading{
    [loadingView setHidden:TRUE];
    [activityLoading stopAnimating];
}


@end
