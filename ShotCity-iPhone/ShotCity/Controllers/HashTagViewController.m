//
//  HashTagViewController.m
//  ShotCity
//
//  Created by dev on 13. 9. 26..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import "HashTagViewController.h"
#import "Image.h"
#import "ShotCell.h"
#import "ShotDetailViewController.h"
#import "AppDelegate.h"


@interface HashTagViewController ()

@end

@implementation HashTagViewController
@synthesize hashTag;


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

- (void)toggleBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
    return [ShotCell getCellHeight:[dataList objectAtIndex:indexPath.row]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Section0 %i", indexPath.row];
    ShotCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *itemData = (NSDictionary*)[dataList objectAtIndex:indexPath.row];
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
        [cell initWithShotData:(NSDictionary*)[dataList objectAtIndex:indexPath.row]];
    }
    NSLog(@"%@", [cell.shotData objectForKey:@"cheered"]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    ShotDetailViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kShotDetailViewController"];
    [VC setShotData:[dataList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)reloadRecentShotList{
    [lbTitle setText:[NSString stringWithFormat:@"HashTag for #%@", self.hashTag]];
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/shots?tag=%@&auth_token=%@"
                     , self.hashTag
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
                
                [dataList removeAllObjects];
                
                if (shots == nil || [shots isEqual:nil]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"1"
                                                                    message:@""
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
                for (int i = 0; i < [shots count]; i++) {
                    NSMutableDictionary *item = [shots objectAtIndex:i];
                /*    NSLog(@"%@", [item objectForKey:@"text"]);
                    NSRange result = [[item objectForKey:@"text"]==[NSNull null]?@"":[item objectForKey:@"text"] rangeOfString:[NSString stringWithFormat:@"#%@", self.hashTag]];
                    if (result.length > 0) {*/
                        [dataList addObject:item];
                    //}
                    
                }
                
                [myTableView setContentOffset:CGPointMake(0, 0)];
                [myTableView reloadData];
            }
        }
    }
    [self stopLoading];
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

@end
