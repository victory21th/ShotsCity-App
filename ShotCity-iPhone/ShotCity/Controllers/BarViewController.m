//
//  BarViewController.m
//  ShotCity
//
//  Created by dev on 13. 8. 21..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "BarViewController.h"
#import "Image.h"
#import "ShotCell.h"
#import "BarShotListViewController.h"
#import "AppDelegate.h"

@interface BarViewController ()

@end

@implementation BarViewController

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
    
    locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	
	//is sending request.
	isSendingRequest = FALSE;
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
        [self updateCurrentLocationInfo];
    
    
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
    return [dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Section0 %i", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *itemData = (NSDictionary*)[dataList objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         tableView.separatorColor = [UIColor grayColor];
        
    }
    cell.textLabel.text = [itemData objectForKey:@"name"];
    cell.detailTextLabel.text = [[itemData objectForKey:@"address"] isEqual:[NSNull null]] ? @" " : [itemData objectForKey:@"address"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    BarShotListViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kBarShotListViewController"];
    [VC setBarItem:[dataList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:VC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)reloadRecentShotList{
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/bars?lat=%f&lon=%f&auth_token=%@"
                     , currentLocation.coordinate.latitude
                     , currentLocation.coordinate.longitude
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    NSLog(@"%@", url);
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    
    
    data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    //[self startLoading];
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
            }
            
            if (![aStr isEqualToString:@"{ \"error\":\"No User!\"}"]) {
                //userdata = jsonObjects;
                //NSArray *shots = [jsonObjects objectForKey:@"shots"];
                
                [dataList removeAllObjects];
                
                if (jsonObjects == nil || [jsonObjects isEqual:nil]) {
                    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Service E"
                                                                    message:@""
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];*/
                    return;
                }
                
                dataList = jsonObjects;
                
                [myTableView setContentOffset:CGPointMake(0, 0)];
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
		[self reloadRecentShotList];
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
@end
