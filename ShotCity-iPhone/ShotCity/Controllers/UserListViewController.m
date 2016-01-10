//
//  UserListViewController.m
//  ShotCity
//
//  Created by dev on 13. 8. 22..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "UserListViewController.h"
#import "Image.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"

@interface UserListViewController ()

@end

@implementation UserListViewController
@synthesize reqString;

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dataList = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [lbTitle setText:self.reqType];
    [self reloadList];
} 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Section0 %i", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *item = [dataList objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        tableView.separatorColor = [UIColor grayColor];
        
        CGRect rc = cell.textLabel.frame;
        rc.origin.x = 45;
        cell.textLabel.frame = rc;
        Image *imgProfile = [[Image alloc] initWithFrame:CGRectMake(8, 9, 24, 24)];
        [imgProfile setDefaultImage:[UIImage imageNamed:@"no-profile.jpg"]];
        
        [imgProfile initWithImageAtURL:[NSURL URLWithString:[item objectForKey:@"image_url"]]];
        [cell.contentView addSubview:imgProfile];
        
        UILabel *ttitle = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 320, 45)];
        ttitle.font = [UIFont boldSystemFontOfSize:13];
        ttitle.textColor    = [UIColor blackColor];
        ttitle.textAlignment = UITextAlignmentLeft;
        
        [ttitle setText:[item objectForKey:@"name"]];
        
        [cell.contentView addSubview:ttitle];
    }
    
    //cell.textLabel.text = [item objectForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = [dataList objectAtIndex:indexPath.row];
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    ProfileViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kProfileViewController"];
    [VC setUserId:[item objectForKey:@"id"]];
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)reloadList{
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:self.reqString]];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSData *urlData;
    NSURLResponse *theString;
    NSError *error;
    
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&theString error:&error];
    
    NSLog(@"%@", self.reqString);
    
    
    if(!urlData) {
        NSString *errorString = @"Can not connect Internet";
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Faild Reuestion" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        
        
    }else {
        NSString *aStr = [[NSString alloc] initWithData:urlData encoding:NSISOLatin1StringEncoding];
        
        NSLog(@"%@", aStr);
        
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"location_id"]);
        NSError *error = nil;
        NSData *jsonData = [aStr dataUsingEncoding:NSUTF8StringEncoding];
        
        
        if (jsonData) {
            
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            if (error) {
                NSLog(@"error is %@", [error localizedDescription]);
            }
            
            if (![aStr isEqualToString:@"{ \"error\":\"No User!\"}"]) {
                //userdata = jsonObjects;
                NSArray *users = [jsonObjects objectForKey:self.reqType];
                
                [dataList removeAllObjects];
                
                if (users == nil || [users isEqual:nil]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@""
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
                for (int i = 0; i < [users count]; i++) {
                    //UserModel *user = [[UserModel alloc] init];
                    NSDictionary *item = [users objectAtIndex:i];
                    
                    
                    [dataList addObject:item];
                }
                //[dataList addObject:shots];
                
                [myTableView setContentOffset:CGPointMake(0, 0)];
                [myTableView reloadData];
            }
        }
        
    }
}

- (void)toggleBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
