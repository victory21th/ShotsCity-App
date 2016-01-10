//
//  CheersViewController.m
//  ShotCity
//
//  Created by dev on 13. 8. 28..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import "CheersViewController.h"
#import "Image.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"

@interface CheersViewController ()

@property (strong, nonatomic) UIPanGestureRecognizer *navigationBarPanGestureRecognizer;

@end

@implementation CheersViewController
@synthesize shotData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)toggleBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
    dataList = [[NSMutableArray alloc] init];
    
    //self.sideSwipeView = [[UIViewController alloc] initWithNibName:@"MasterSideSwipeView" bundle:nil].view;
    //[self setupSideSwipeView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [txtComment becomeFirstResponder];
    
    [self getCheerList];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Section0 %i", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *item = [dataList objectAtIndex:indexPath.row];
    
    Image *imgProfile;
    UILabel *ttitle;
    UILabel *stitle;
    UIButton *btnName;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        tableView.separatorColor = [UIColor grayColor];
        
        CGRect rc = cell.textLabel.frame;
        rc.origin.x = 45;
        cell.textLabel.frame = rc;
        
        imgProfile = [[Image alloc] initWithFrame:CGRectMake(8, 4, 29, 29)];
        [imgProfile setDefaultImage:[UIImage imageNamed:@"no-profile.jpg"]];
        imgProfile.tag = 100;
        
        
        ttitle = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 320, 20)];
        ttitle.font = [UIFont boldSystemFontOfSize:13];
        ttitle.textColor    = [UIColor grayColor];
        ttitle.textAlignment = UITextAlignmentLeft;
        ttitle.tag = 200;
        
        btnName = [[UIButton alloc] initWithFrame:CGRectMake(45, 10, 320, 20)];
        [btnName addTarget:self action:@selector(toggleProfile:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [btnName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnName setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateHighlighted];
        [btnName.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        
        [cell.contentView addSubview:btnName];
        btnName.tag = 400;
        
        stitle = [[UILabel alloc] initWithFrame:CGRectMake(45, 25, 320, 20)];
        stitle.font = [UIFont boldSystemFontOfSize:13];
        stitle.textColor    = [UIColor blackColor];
        stitle.textAlignment = UITextAlignmentLeft;
        stitle.tag = 300;
        
        
        [cell.contentView addSubview:imgProfile];
        //[cell.contentView addSubview:ttitle];
        [cell.contentView addSubview:stitle];
    }else{
        imgProfile = (Image*)[cell viewWithTag:100];
        ttitle = (UILabel*)[cell viewWithTag:200];
        stitle = (UILabel*)[cell viewWithTag:300];
        btnName = (UIButton*)[cell viewWithTag:400];
    }
    
    cell.contentView.tag = indexPath.row;
    
    if ([item objectForKey:@"user_image_url"]!=[NSNull null]) {
        [imgProfile initWithImageAtURL:[NSURL URLWithString:[item objectForKey:@"user_image_url"]]];
    }else
        [imgProfile setImage:imgProfile.defaultImage];
    
    [ttitle setText:[item objectForKey:@"user_name"]==[NSNull null]?@"":[item objectForKey:@"user_name"]];
    [btnName setTitle:[item objectForKey:@"user_name"]==[NSNull null]?@"":[item objectForKey:@"user_name"] forState:UIControlStateNormal];
    
    //[stitle setText:[item objectForKey:@"text"]];
    //cell.textLabel.text = [item objectForKey:@"name"];
    return cell;
}


- (void) getCheerList{
    
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots/%@/cheers?auth_token=%@"
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
            }
            
            if (![aStr isEqualToString:@"{ \"error\":\"No User!\"}"]) {
                //userdata = jsonObjects;
                if ([jsonObjects isKindOfClass:[NSDictionary class]]) {
                    [txtComment setText:@""];
                    [txtComment setEnabled:FALSE];
                    
                    [self getCheerList];
                }else{
                    dataList = jsonObjects;
                    
                    [myTableView reloadData];
                }
            }
        }
    }
}

- (void)toggleProfile:(id)sender{
    UITableViewCell *cell = (UITableViewCell *)[sender superview];
//    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    NSDictionary *item = [dataList objectAtIndex:cell.tag];
    
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

@end
