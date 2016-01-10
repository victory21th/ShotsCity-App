//
//  SearchLoc1ViewController.m
//  ShotsCity
//
//  Created by dev on 13. 10. 30..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import "SearchLoc1ViewController.h"
#import "Image.h"
#import "SearchCell.h"
#import "ShotDetailViewController.h"
#import "AppDelegate.h"

@interface SearchLoc1ViewController ()

@end

@implementation SearchLoc1ViewController

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
        
        //[myTableView setScrollIndicatorInsets:UIEdgeInsetsMake(65 + 33, 0, 0, 0)];
        //[myTableView setContentInset:UIEdgeInsetsMake(65 + 33, 0, 0, 0)];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    searchType = FALSE;
    
    dataList = [[NSMutableArray alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	
	//is sending request.
	isSendingRequest = FALSE;
    
    [myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view bringSubviewToFront:loadingView];
    
    
    [self toggleReload:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"update_list"] != nil && [[[NSUserDefaults standardUserDefaults] objectForKey:@"update_list"] isEqual:@"TRUE"] ) {
        [self toggleReload:nil];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"update_list"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////// textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    CGRect rc = viewSearchSection.frame;
//    rc.origin.y = self.view.frame.size.height - 198;
//    
//    [UIView beginAnimations:@"animateAddContentView" context:nil];
//    [UIView setAnimationDuration:0.4];
//    viewSearchSection.frame = rc;
//    
//    [UIView commitAnimations];
//
    searchType = searchType == 0 ? 2 : searchType;
    [self initView];
    
    return TRUE;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    CGRect rc = viewSearchSection.frame;
//    rc.origin.y = self.view.frame.size.height - rc.size.height;
//    
//    [UIView beginAnimations:@"animateAddContentView" context:nil];
//    [UIView setAnimationDuration:0.3];
//    viewSearchSection.frame = rc;
//    
//    [UIView commitAnimations];
    return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self toggleSearch:btnSearch];
    
    return TRUE;
}

////// tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isReloading) {
        if (isNewUpdate) {
            return [dataList count] + 1;
        }else{
            return [dataList count] + 1;
        }
    }
    return [dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isReloading) {
        if (isNewUpdate ) {
            if (indexPath.row == 0) {
                if ([dataList count] == 0) {
                    return 70;
                }
                return 30;
            }
            return [SearchCell getCellHeight:[dataList objectAtIndex:indexPath.row - 1]];
        }else if (isNewUpdate == FALSE){
            if (indexPath.row == dataList.count) {
                return 30;
            }
            return [SearchCell getCellHeight:[dataList objectAtIndex:indexPath.row]];
        }
    }
    return [SearchCell getCellHeight:[dataList objectAtIndex:indexPath.row]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *itemData = nil;
    
    if (isReloading) {
        if (isNewUpdate) {
            if (indexPath.row == 0) {
                static NSString *CellIdentifier = @"LoadingCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                    
                    cell.contentView.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    //tableView.separatorColor = [UIColor grayColor];
                    
                }
                //cell.textLabel.text = [item objectForKey:@"name"];
                [(UIActivityIndicatorView*)[cell viewWithTag:10] startAnimating];
                if ([dataList count] == 0) {
                    [(UIActivityIndicatorView*)[cell viewWithTag:10] setHidden:TRUE];
                }else
                    [(UIActivityIndicatorView*)[cell viewWithTag:10] setHidden:FALSE];
                return cell;
            }
            itemData = (NSDictionary*)[dataList objectAtIndex:indexPath.row - 1];
        }else{
            if (indexPath.row == dataList.count) {
                static NSString *CellIdentifier = @"LoadingCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                    
                    cell.contentView.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    //tableView.separatorColor = [UIColor grayColor];
                    
                }
                [(UIActivityIndicatorView*)[cell viewWithTag:10] startAnimating];
                
                if ([dataList count] == 0) {
                    [(UIActivityIndicatorView*)[cell viewWithTag:10] setHidden:TRUE];
                }else
                    [(UIActivityIndicatorView*)[cell viewWithTag:10] setHidden:FALSE];
                
                return cell;
            }
        }
    }
    if (itemData == nil) {
        itemData = (NSDictionary*)[dataList objectAtIndex:indexPath.row];
    }
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Section0 %i", indexPath.row];
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setParentViewController:self];
        
        /*cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         tableView.separatorColor = [UIColor grayColor];
         */
        //cell = [SearchCell cellWithNib];
        //cell = [SearchCell cellWithReuseIdentifier:CellIdentifier];
        //[cell setRestorationIdentifier:CellIdentifier];
        
        //[cell initWithShotData:(NSDictionary*)[dataList objectAtIndex:indexPath.row]];
        
    }
    if ([[itemData objectForKey:@"_id"] isEqual:[cell.shotData objectForKey:@"id"]]) {
        
    }else{
        [cell initWithShotData:itemData];
    }
    // NSLog(@"%@", [cell.shotData objectForKey:@"cheered"]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    ShotDetailViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kShotDetailViewController"];
    [VC setShotData:[dataList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:VC animated:YES];
    */
}

- (void) initView{
    
    if (searchType == 0) {
        //nearby
        txtSearch.text = @"";
        [btnHashtag setImage:[UIImage imageNamed:@"btn_search_loc.png"] forState:UIControlStateNormal];
        [btnBar setImage:[UIImage imageNamed:@"btn_search_map.png"] forState:UIControlStateNormal];
        
    }
    if (searchType == 1) {
        //bar
        //txtSearch.text = @"";
        [btnHashtag setImage:[UIImage imageNamed:@"btn_search_loc.png"] forState:UIControlStateNormal];
        [btnBar setImage:[UIImage imageNamed:@"btn_search_map_press.png"] forState:UIControlStateNormal];
        
    }
    if (searchType == 2) {
        //tag
        //txtSearch.text = @"";
        [btnHashtag setImage:[UIImage imageNamed:@"btn_search_loc_press.png"] forState:UIControlStateNormal];
        [btnBar setImage:[UIImage imageNamed:@"btn_search_map.png"] forState:UIControlStateNormal];
        
    }
}
//////////******* action *******////////////
- (IBAction)toggleReload:(id)sender{
    [self initView];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    
    if (userId == nil || [userId isEqual:@""]) {
        
    }else{
        if (searchType == 0) {
            [self updateCurrentLocationInfo];
        }else {
            [self toggleSearch:nil];
        }
    }
    
    
    
}
- (IBAction)toggleSearch:(id)sender{
    [txtSearch resignFirstResponder];
    
    [self requestSearchShots];
}

- (IBAction)toggleNearby:(id)sender{
    searchType = 0;
    [self initView];
    
    [self updateCurrentLocationInfo];
}

- (IBAction)toggleHashtag:(id)sender{
    searchType = 2;
    [self initView];
}
- (IBAction)toggleBar:(id)sender{
    searchType = 1;
    [self initView];
}


//////
- (void)reloadRecentShotList{
    [dataList removeAllObjects];
    lastItemId = nil;
    isReloading = TRUE;
    isNewUpdate = FALSE;
    [myTableView setContentOffset:CGPointMake(0, 0)];
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@&lat=%f&lon=%f"
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
                     , currentLocation.coordinate.latitude
                     , currentLocation.coordinate.longitude];
    NSLog(@"%@", url);
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    
    
    data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    /*
     NSData *urlData;
     NSURLResponse *theString;
     NSError *error;
     
     urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&theString error:&error];
     
     NSLog(@"%@", url);
     
     
     if(!urlData) {
     NSString *errorString = @"Can not connect Internet";
     UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Faild Reuestion" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [errorAlert show];
     
     
     }else {
     
     
     }*/
    
    [self startLoading];
}


- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    if (data==nil) data = [[NSMutableData alloc] initWithCapacity:2048];
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection
{
    isReloading = FALSE;
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
            }
            
            if (![aStr isEqualToString:@"{ \"error\":\"No User!\"}"]) {
                //userdata = jsonObjects;
                NSArray *shots = [jsonObjects objectForKey:@"shots"];
                
                
                if (shots == nil || [shots isEqual:nil] || shots.count == 0) {
                    if (isNotFirstRequest == FALSE) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No search result."
                                                                        message:@""
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Confirm"
                                                              otherButtonTitles:nil];
                        [alert show];
                        [dataList removeAllObjects];
                    }
                    
                    [myTableView reloadData];
                    
                    return;
                }
                if (isNotFirstRequest == FALSE) {
                    [dataList removeAllObjects];
                }
                if (isNewUpdate == FALSE) {
                    for (int i = 0; i < [shots count]; i++) {
                        NSMutableDictionary *item = [shots objectAtIndex:i];
                        
                        [dataList addObject:item];
                    }
                }else{
                    [dataList insertObjects:shots atIndexes:[NSIndexSet indexSetWithIndex:0]];
                }
                
                
                if ([dataList count] == 0) {
                    //[lbDataCount setText:[NSString stringWithFormat:@"%d Shot", dataList.count]];
                }else{
                    //[lbDataCount setText:[NSString stringWithFormat:@"%d Shots", dataList.count]];
                    
                    if (isNotFirstRequest == FALSE) {
                        [myTableView setContentOffset:CGPointMake(0, 0)];
                        
                    }
                }
            }
        }
    }
    [myTableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self stopLoading];
}

- (void)startLoading{
    [loadingView setHidden:FALSE];
    [activityLoading startAnimating];
}

- (void)stopLoading{
    [loadingView setHidden:TRUE];
    [activityLoading stopAnimating];
}

- (IBAction)updateCurrentLocationInfo{
	
	[self startLoading];
    
	isSendingRequest = FALSE;
	[locationManager startUpdatingLocation];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation{
	[locationManager stopUpdatingLocation];
	
	//.
	if (isSendingRequest == FALSE) {
		if(currentLocation == nil)
			currentLocation = newLocation;
		else {
			//[currentLocation release];
			currentLocation = newLocation;
		}
		
		isSendingRequest = TRUE;
		//[self reloadRecentShotList];
        [self requestNearby];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
	CLLocationCoordinate2D pos;
	pos.latitude = 37.566508; //+ i * 0.001;//3
	pos.longitude = 126.97807; //+ i * 0.001;//
	
    [locationManager stopUpdatingLocation];
	
	[self stopLoading];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GPS Fail"
													message:@"Please, check the GPS setting."
												   delegate:self
										  cancelButtonTitle:@"Confirm"
										  otherButtonTitles:nil];
	[alert show];
}


/////////////// data paging

#pragma mark Scrolling Overrides
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[txtSearch resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    [[self _popupMenuBtn] setHidden:TRUE];
    //	[[self _popupMenuSPView] setHidden:TRUE];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
				  willDecelerate:(BOOL)decelerate
{
	if (isReloading) return;
	
	UITableView* tb = (UITableView*)scrollView;
	
	float oy = tb.contentOffset.y;
    
    if (dataList.count == 0) {
        return;
    }
	if (oy > tb.contentSize.height - tb.bounds.size.height + 20) {
        isNewUpdate = FALSE;
		lastItemId = [[dataList objectAtIndex:dataList.count - 1] objectForKey:@"id"];
        //		if (pageNo <= totalPage) {
        //
        //			if (pageNo > totalPage) {
        //				return;
        //			}
        isNotFirstRequest = TRUE;
        [self startLoadingList];
        
        [myTableView setContentOffset:CGPointMake(0, oy+49)];
        //		}
	}
    
    if (oy < -20) {
        isNewUpdate = TRUE;
		lastItemId = [[dataList objectAtIndex:0] objectForKey:@"id"];
        isNotFirstRequest = TRUE;
        
        [self startLoadingList];
    }
}

- (void) startLoadingList{
    isReloading = TRUE;
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@&following=true"
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
                     ];
    if (isNewUpdate) {
        url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@&lat=%f&lon=%f&after=%@"
               , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
               , currentLocation.coordinate.latitude
               , currentLocation.coordinate.longitude
               , lastItemId
               ];
        if (searchType == 1) {
            //bar
            url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@&name=%@&after=%@"
                   , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
                   , txtSearch.text
                   , lastItemId
                   ];
        }else if (searchType == 2){
            //tag
            url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@&tag=%@&after=%@"
                   , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
                   , txtSearch.text
                   , lastItemId
                   ];
        }
        
        NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [insertIndexPaths addObject:newPath];
        [myTableView beginUpdates];
        [myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
        [myTableView endUpdates];
        
    }else{
        url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@&lat=%f&lon=%f&before=%@"
               , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
               , currentLocation.coordinate.latitude
               , currentLocation.coordinate.longitude
               , lastItemId
               ];
        if (searchType == 1) {
            //bar
            url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@&name=%@&before=%@"
                   , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
                   , txtSearch.text
                   , lastItemId
                   ];
        }else if (searchType == 2){
            //tag
            url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@&tag=%@&before=%@"
                   , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
                   , txtSearch.text
                   , lastItemId
                   ];
        }
        
        NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:[dataList count] inSection:0];
        [insertIndexPaths addObject:newPath];
        [myTableView beginUpdates];
        [myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
        [myTableView endUpdates];
        
        [myTableView setContentSize:CGSizeMake(myTableView.frame.size.width, myTableView.contentSize.height + 50)];
        [myTableView setContentOffset:CGPointMake(0, myTableView.contentSize.height + 50)];
    }
    NSLog(@"%@", url);
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    
    
    data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    
    //[self startLoading];
    //[myTableView reloadData];
    
}

- (void) requestNearby{
    [self startLoading];
    //[dataList removeAllObjects];
    lastItemId = nil;
    isReloading = TRUE;
    isNewUpdate = FALSE;
    isNotFirstRequest = FALSE;
    //[myTableView setContentOffset:CGPointMake(0, 0)];
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@&lat=%f&lon=%f"
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
                     , currentLocation.coordinate.latitude
                     , currentLocation.coordinate.longitude];
    NSLog(@"%@", url);
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    
    
    data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
}

- (void) requestSearchShots{
    [self startLoading];
    
    //[dataList removeAllObjects];
    lastItemId = nil;
    isReloading = TRUE;
    isNewUpdate = FALSE;
    [myTableView setContentOffset:CGPointMake(0, 0)];
    isNotFirstRequest = FALSE;
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@&lat=%f&lon=%f"
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
                     , currentLocation.coordinate.latitude
                     , currentLocation.coordinate.longitude];
    
    if (searchType == 1) {
        //bar
        url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@&name=%@"
               , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
               , txtSearch.text
               ];
    }else if (searchType == 2){
        //tag
        url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@&tag=%@"
               , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
               , txtSearch.text
               ];
    }
    NSLog(@"%@", url);
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    
    
    data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
}
@end
