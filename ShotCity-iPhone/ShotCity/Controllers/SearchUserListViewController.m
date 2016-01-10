//
//  SearchUserListViewController.m
//  ShotCity
//
//  Created by dev on 13. 9. 6..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import "SearchUserListViewController.h"
#import "Image.h"
#import "SharePhotoViewController.h"

@interface SearchUserListViewController ()

@end

@implementation SearchUserListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *item = [dataList objectAtIndex:indexPath.row];
    
    Image *imgProfile;
    UILabel *ttitle;
    UILabel *stitle;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        tableView.separatorColor = [UIColor grayColor];
        
        CGRect rc = cell.textLabel.frame;
        rc.origin.x = 45;
        cell.textLabel.frame = rc;
        
        imgProfile = [[Image alloc] initWithFrame:CGRectMake(8, 9, 29, 29)];
        [imgProfile setDefaultImage:[UIImage imageNamed:@"no-profile.jpg"]];
        imgProfile.tag = 100;
        
        
        ttitle = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 320, 20)];
        ttitle.font = [UIFont boldSystemFontOfSize:13];
        ttitle.textColor    = [UIColor blackColor];
        ttitle.textAlignment = UITextAlignmentLeft;
        ttitle.tag = 200;
        
        
        stitle = [[UILabel alloc] initWithFrame:CGRectMake(45, 25, 320, 20)];
        stitle.font = [UIFont boldSystemFontOfSize:13];
        stitle.textColor    = [UIColor blackColor];
        stitle.textAlignment = UITextAlignmentLeft;
        stitle.tag = 300;
        
        
        [cell.contentView addSubview:imgProfile];
        [cell.contentView addSubview:ttitle];
        [cell.contentView addSubview:stitle];
    }else{
        imgProfile = (Image*)[cell viewWithTag:100];
        ttitle = (UILabel*)[cell viewWithTag:200];
        stitle = (UILabel*)[cell viewWithTag:300];
    }
    if ([item objectForKey:@"image_url"]!=[NSNull null]) {
        [imgProfile setDefaultImage:[UIImage imageNamed:@"no-profile.jpg"]];
        [imgProfile initWithImageAtURL:[NSURL URLWithString:[item objectForKey:@"image_url"]]];
    }else
        [imgProfile setImage:imgProfile.defaultImage];
    
    [ttitle setText:[item objectForKey:@"username"]==[NSNull null]?@"":[item objectForKey:@"username"]];
    [stitle setText:[item objectForKey:@"name"]];
    //cell.textLabel.text = [item objectForKey:@"name"];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
   
    [self.sharePhotoViewController appendUserName:[[dataList objectAtIndex:indexPath.row] objectForKey:@"username"]];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) updateSearchList:(NSString*) username{

    //[dataList removeAllObjects];
    //[self.tableView reloadData];
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users?auth_token=%@&username=%@"
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
                     , username];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    
    data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    NSLog(@"%@", url);
    
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
        
        
        NSError *error = nil;
        NSData *jsonData = [aStr dataUsingEncoding:NSUTF8StringEncoding];
        
        if (jsonData) {
            
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            if (error) {
                NSLog(@"error is %@", [error localizedDescription]);
            }
            
            if (![aStr isEqualToString:@"{ \"error\":\"No User!\"}"]) {
                //userdata = jsonObjects;
                dataList = [jsonObjects objectForKey:@"users"];
                
                [self.tableView reloadData];
            }
        }
    }
}

@end
