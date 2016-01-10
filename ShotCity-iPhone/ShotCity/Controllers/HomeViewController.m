//
//  HomeViewController.m
//  ShotCity
//
//  Created by dev on 13. 8. 20..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "HomeViewController.h"
#import "Image.h"
#import "ShotCell.h"
#import "ShotDetailViewController.h"
#import "AppDelegate.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    
    dataList = [[NSMutableArray alloc] init];
    
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

- (IBAction)toggleReload:(id)sender{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    
    if (userId == nil || [userId isEqual:@""]) {
        
    }else
        [self reloadRecentShotList];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
                    return 580;
                }
                return 30;
            }
            return [ShotCell getCellHeight:[dataList objectAtIndex:indexPath.row - 1]];
        }else if (isNewUpdate == FALSE){
            if (indexPath.row == dataList.count) {
                return 30;
            }
            return [ShotCell getCellHeight:[dataList objectAtIndex:indexPath.row]];
        }
    }
    return [ShotCell getCellHeight:[dataList objectAtIndex:indexPath.row]];
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
    if (indexPath.row > [dataList count]) {
        static NSString *CellIdentifier = @"LoadingCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        return cell;
    }
    if (itemData == nil) {
        itemData = (NSDictionary*)[dataList objectAtIndex:indexPath.row];
    }
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Section0 %i", indexPath.row];
    ShotCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[ShotCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setParentViewController:self];
        
        /*cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         tableView.separatorColor = [UIColor grayColor];
         */
        //cell = [ShotCell cellWithNib];
        //cell = [ShotCell cellWithReuseIdentifier:CellIdentifier];
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
    [self.navigationController pushViewController:VC animated:YES];*/
}

- (void)reloadRecentShotList{
    [dataList removeAllObjects];
    lastItemId = nil;
    isReloading = TRUE;
    isNewUpdate = FALSE;
    [myTableView setContentOffset:CGPointMake(0, 0)];
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@&following=true"
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
                     ];
    NSLog(@"%@", url);
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
                    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"1"
                                                                    message:@""
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];*/
                    [myTableView reloadData];
                    return;
                }
                if (isNewUpdate == FALSE) {
                    for (int i = 0; i < [shots count]; i++) {
                        NSMutableDictionary *item = [shots objectAtIndex:i];
                        
                        [dataList addObject:item];
                    }
                }else{
                    [dataList insertObjects:shots atIndexes:[NSIndexSet indexSetWithIndex:0]];
                }
                
                [myTableView reloadData];
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
    isReloading = FALSE;
    
    [loadingView setHidden:TRUE];
    [activityLoading stopAnimating];
}


/////////////// data paging

#pragma mark Scrolling Overrides
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	
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
			
			[self startLoadingList];
			
			[myTableView setContentOffset:CGPointMake(0, oy+49)];
//		}
	}
    
    if (oy < -20) {
        isNewUpdate = TRUE;
		lastItemId = [[dataList objectAtIndex:0] objectForKey:@"id"];
        [self startLoadingList];
    }
}

- (void) startLoadingList{
    isReloading = TRUE;
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@&following=true"
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
                     ];
    if (isNewUpdate) {
        url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@&following=true&after=%@"
               , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
               , lastItemId
               ];
        
        NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [insertIndexPaths addObject:newPath];
        [myTableView beginUpdates];
        [myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
        [myTableView endUpdates];
        
    }else{
        url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?auth_token=%@&following=true&before=%@"
               , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
               , lastItemId
               ];
        
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

@end
