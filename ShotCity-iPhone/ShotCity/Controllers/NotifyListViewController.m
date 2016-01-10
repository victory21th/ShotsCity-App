//
//  NotifyListViewController.m
//  ShotCity
//
//  Created by dev on 13. 10. 3..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import "NotifyListViewController.h"
#import "NotifyCell.h"
#import "AppDelegate.h"
#import "ShotDetailViewController.h"

@interface NotifyListViewController ()

@end

@implementation NotifyListViewController

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
    
    
    [AppDelegate setNotificationBadge:nil];    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self reloadList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)toggleReload:(id)sender{
    [self reloadList];
}

- (void)reloadList{
    [myTableView setContentOffset:CGPointMake(0, 0)];
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/notifications?auth_token=%@"
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
                NSArray *shots = [jsonObjects objectForKey:@"notifications"];
                
                [dataList removeAllObjects];
                
                
                for (int i = 0; i < [shots count]; i++) {
                    NSMutableDictionary *item = [shots objectAtIndex:i];
                    
                    [dataList addObject:item];
                }
                
                [myTableView reloadData];
                //[myTableView setContentOffset:CGPointMake(0, 0)];
                
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

/////////


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return 55;
    return [NotifyCell getCellHeight:[dataList objectAtIndex:indexPath.row]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Section0 %i", indexPath.row];
    NotifyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *itemData = (NSDictionary*)[dataList objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[NotifyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setParentViewController:self];
        
    }
    if ([[itemData objectForKey:@"_id"] isEqual:[cell.cellData objectForKey:@"id"]]) {
        
    }else{
        [cell initWithShotData:itemData];
    }
    
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

@end
