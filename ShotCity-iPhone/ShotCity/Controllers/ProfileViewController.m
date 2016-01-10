//
//  ProfileViewController.m
//  ShotCity
//
//  Created by dev on 13. 8. 18..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "UserListViewController.h"
#import "EditProfileViewController.h"
#import "ShotDetailViewController.h"
#import "ShotCell.h"
#import "PhotoMapViewController.h"
#import "NotifyListViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    
    [ivProfile setBackgroundColor:[UIColor grayColor]];
    [btnFollow setHidden:TRUE];
    [btnUnfollow setHidden:TRUE];
    if (self.userId == nil) {
        self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    }
    if ([self.userId isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]) {
        [btnLogout setHidden:FALSE];
        [btnNotify setHidden:FALSE];
        //[btnFollow setHidden:TRUE];
    }else{
        [btnLogout setHidden:TRUE];
        [btnNotify setHidden:TRUE];
        //[btnFollow setHidden:FALSE];
    }
    [self getUserInfo:self.userId];
    
    dataList = [[NSMutableArray alloc] init];
    
    [self updateSubMenuButtons];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /*
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (delegate.userInfo == nil) {
        return;
    }
    NSURL* url = [NSURL URLWithString:delegate.userInfo.imgUrl];
    
    [ivProfile initWithImageAtURL:url];
    [lbUserId setText:delegate.userInfo.uid];
    [lbUserName setText:delegate.userInfo.name];
    [lbGender setText:delegate.userInfo.gender];
    */
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"update_list"] != nil && [[[NSUserDefaults standardUserDefaults] objectForKey:@"update_list"] isEqual:@"TRUE"] ) {
        
        [btnFollow setHidden:TRUE];
        [btnUnfollow setHidden:TRUE];
        if ([self.userId isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]) {
            [btnLogout setHidden:FALSE];
            [btnNotify setHidden:FALSE];
            //[btnFollow setHidden:TRUE];
        }else{
            [btnLogout setHidden:TRUE];
            [btnNotify setHidden:TRUE];
            //[btnFollow setHidden:FALSE];
        }
        [self getUserInfo:self.userId];
        
        dataList = [[NSMutableArray alloc] init];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"update_list"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleLogOut:(id)sender{
/*    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"auth_token"];
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [delegate showLoginViewController];*/
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    EditProfileViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kEditProfileViewController"];
    [VC setUserData:userData];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void) getUserInfo:(NSString*)uid{
    isShotListReq = FALSE;
    [self startLoading];
    [dataList removeAllObjects];
    lastItemId = nil;
    isReloading = TRUE;
    isNewUpdate = FALSE;
    [myTableView setContentOffset:CGPointMake(0, 0)];
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users/%@?auth_token=%@"
                     , uid
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    
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
    isReloading = FALSE;
    [self stopLoading];
    
    if(!data) {
        NSString *errorString = @"Can not connect Internet";
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Faild Reuestion" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        
        
    }else {
        NSString *aStr = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        
        //NSLog(@"%@", url);
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
                if (isShotListReq) {
                    NSArray *shots = [jsonObjects objectForKey:@"shots"];
                    
                    
                    if (shots == nil || [shots isEqual:nil] || shots.count == 0) {
                        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"1"
                         message:@""
                         delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
                         [alert show];*/
                        [myTableView reloadData];
                        [myCollectionView reloadData];
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
                    [myCollectionView reloadData];
                    
                    //[btnPhotos setTitle:[NSString stringWithFormat:@"%d", [dataList count]]                               forState:UIControlStateNormal];
                }else{
                    NSDictionary *user = [jsonObjects objectForKey:@"user"];
                    userData = user;
                    
                    if (user == nil || [user isEqual:nil]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:@""
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        return;
                    }else{
                        
                        NSURL* url = [NSURL URLWithString:[user objectForKey:@"image_url"]];
                        [ivProfile initWithImageAtURL:url];
                        
                        [btnPhotos setTitle:[NSString stringWithFormat:@"%d",[[user objectForKey:@"shots_count"] integerValue]]
                                   forState:UIControlStateNormal];
                        [btnFollowers setTitle:[NSString stringWithFormat:@"%d",[[[user objectForKey:@"counts"] objectForKey:@"followers"] integerValue]]
                                      forState:UIControlStateNormal];
                        [btnFollowings setTitle:[NSString stringWithFormat:@"%d",[[[user objectForKey:@"counts"] objectForKey:@"following"] integerValue]]
                                       forState:UIControlStateNormal];
                        
                        [lbUserId setText:[user objectForKey:@"name"]==[NSNull null]?@"":[user objectForKey:@"name"]];
                        [lbUserName setText:[user objectForKey:@"username"]==[NSNull null]?@"":[user objectForKey:@"username"]];
                        [lbGender setText:[user objectForKey:@"gender"]];
                        //NSLog(@"%@", [user objectForKey:@"image_url"]);
                        
                        if ([self.userId isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]) {
                            [btnLogout setHidden:FALSE];
                            [btnNotify setHidden:FALSE];
                            [btnFollow setHidden:TRUE];
                            [btnUnfollow setHidden:TRUE];
                        }else{
                            [btnLogout setHidden:TRUE];
                            [btnNotify setHidden:TRUE];
                            
                            if ([[user objectForKey:@"following"] boolValue]) {
                                [btnFollow setHidden:TRUE];
                                [btnUnfollow setHidden:FALSE];
                            }else{
                                [btnFollow setHidden:FALSE];
                                [btnUnfollow setHidden:TRUE];
                            }
                        }
                        
                        [self updateSubMenuButtons];
                        
                        [self performSelector:@selector(reloadRecentShotList) withObject:nil afterDelay:0.00f];
                    }
                }
                
            }
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [self stopLoading];
    
}


//////
- (void)reloadRecentShotList{
    isShotListReq = TRUE;
    [dataList removeAllObjects];
    lastItemId = nil;
    isReloading = TRUE;
    isNewUpdate = FALSE;
    [myTableView setContentOffset:CGPointMake(0, 0)];
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users/%@/shots?auth_token=%@"
                     , [userData objectForKey:@"id"]
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    
    data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
 /*
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&theString error:&error];
    
    NSLog(@"%@", url);
    
    
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
                NSArray *shots = [jsonObjects objectForKey:@"shots"];
                
                [dataList removeAllObjects];
                
                if (shots == nil || [shots isEqual:nil]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@""
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
                for (int i = 0; i < [shots count]; i++) {
                    //UserModel *user = [[UserModel alloc] init];
                    NSDictionary *item = [shots objectAtIndex:i];
                    
                    
                    [dataList addObject:item];
                }
                //[dataList addObject:shots];
                
                [myCollectionView setContentOffset:CGPointMake(0, 0)];
                [myCollectionView reloadData];
                
                [btnPhotos setTitle:[NSString stringWithFormat:@"%d", [dataList count]]
                           forState:UIControlStateNormal];
            }
        }
        
    }*/
}

- (void)toggleFollow:(id)sender{
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users/%@/followers?auth_token=%@"
                     , [userData objectForKey:@"id"]
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    NSLog(@"%@", url);
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];
    
    
    data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    

}

- (void)toggleUnfollow:(id)sender{
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users/%@/followers/me?auth_token=%@"
                     , [userData objectForKey:@"id"]
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    NSLog(@"%@", url);
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"DELETE"];
    
    
    data = nil;
    NSData *urlData;
    NSURLResponse *theString;
    NSError *error;
    
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&theString error:&error];
    
    [self getUserInfo:self.userId];
}

- (void)toggleFollowers:(id)sender{
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users/%@/followers?relationship=followers&auth_token=%@"
                     , [userData objectForKey:@"id"]
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    UserListViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kUserListViewController"];
    [VC setReqString:url];
    [VC setReqType:@"followers"];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)toggleFollowings:(id)sender{
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users/%@/followers?relationship=following&auth_token=%@"
                     , [userData objectForKey:@"id"]
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    UserListViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kUserListViewController"];
    [VC setReqString:url];
    [VC setReqType:@"following"];
    [self.navigationController pushViewController:VC animated:YES];
}


//////user's shot list

//
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [dataList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PhotoCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString* url = [[dataList objectAtIndex:indexPath.row] objectForKey:@"image_url"];
    if (cell == nil) {
        //NSURL* url = [NSURL URLWithString:@"http://graph.facebook.com/100004790670119/picture?type=square"];
        Image *img = [[Image alloc] initWithFrame:CGRectMake(6, 6, 90, 90)];
        img.tag = 888;
        [img setDefaultImage:[UIImage imageNamed:@"no-image-found.jpg"]];
        img.backgroundColor = [UIColor grayColor];
        /*
        if ([url isEqual:[NSNull null]] ) {
            [img setImage:[UIImage imageNamed:@"no-image-found.jpg"]];
        }else{
            [img initWithImageAtURL:[NSURL URLWithString:[[dataList objectAtIndex:indexPath.row] objectForKey:@"image_url"]]];
            //NSLog(@"%@", [itemData objectForKey:@"image_url"]);
        }*/
        //[img initWithImageAtURL:url];
        //[cell.contentView addSubview:img];
    }
    Image *img = (Image*)[cell viewWithTag:100];
    if (img != nil) {
        [img removeFromSuperview];
    }
    img = [[Image alloc] initWithFrame:CGRectMake(6, 6, 90, 90)];
    img.tag = 100;
    img.backgroundColor = [UIColor grayColor];
    [img setDefaultImage:[UIImage imageNamed:@"no-image-found.jpg"]];
    
    if ([url isEqual:[NSNull null]] ) {
        [img setImage:[UIImage imageNamed:@"no-image-found.jpg"]];
    }else{
        //[img initWithImageAtURL:[NSURL URLWithString:[[dataList objectAtIndex:indexPath.row] objectForKey:@"image_url"]]];
        //NSLog(@"%@", [itemData objectForKey:@"image_url"]);
        
        if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"image_url"] rangeOfString:@".mov"].location == NSNotFound) {
            [img initWithImageAtURL:[NSURL URLWithString:[[dataList objectAtIndex:indexPath.row] objectForKey:@"image_url"]]];
        }else{
            
            [img initWithImageAtURL:[NSURL URLWithString:[[dataList objectAtIndex:indexPath.row] objectForKey:@"thumb_image_url"] ]];
        }
    }
    //[img initWithImageAtURL:url];
    [cell.contentView addSubview:img];
    
    /*
    id shot_url = [[dataList objectAtIndex:indexPath.row] objectForKey:@"image_url"];
    if ([shot_url isEqual:[NSNull null]] ) {
        [self.imgShot setImage:[UIImage imageNamed:@"no-image-found.jpg"]];
    }else{
        [self.imgProfile initWithImageAtURL:[NSURL URLWithString:[[dataList objectAtIndex:indexPath.row] objectForKey:@"image_url"]]];
        NSLog(@"%@", [itemData objectForKey:@"image_url"]);
    }
     */
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    ShotDetailViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kShotDetailViewController"];
    [VC setShotData:[dataList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)resigneKeyboard:(id)sender{
    [self resignFirstResponder];
}



/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

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
    if (itemData == nil) {
        itemData = (NSDictionary*)[dataList objectAtIndex:indexPath.row];
    }
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Section0 %i", indexPath.row];
    ShotCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    

    if (cell == nil) {
        cell = [[ShotCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setParentViewController:self];
                
    }
    if ([[itemData objectForKey:@"_id"] isEqual:[cell.shotData objectForKey:@"id"]]) {
        
    }else{
        [cell initWithShotData:(NSDictionary*)[dataList objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    ShotDetailViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kShotDetailViewController"];
    [VC setShotData:[dataList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:VC animated:YES];
}

/****************************************************************/
/*********************** Action Define***************************/
/****************************************************************/
- (void)toggleCollectionView:(id)sender{
    currentMenuIndex = 0;
    myTableView.hidden = TRUE;
    myCollectionView.hidden = FALSE;
    [self updateSubMenuButtons];
    
    [myCollectionView reloadData];
}

- (void)toggleListView:(id)sender{
    currentMenuIndex = 1;
    myCollectionView.hidden = TRUE;
    myTableView.hidden = FALSE;
    [self updateSubMenuButtons];
    
    [myTableView reloadData];
}

- (void)toggleMapView:(id)sender{
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    PhotoMapViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kPhotoMapViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)toggleFourth:(id)sender{
    
}

- (void) updateSubMenuButtons{
    if (currentMenuIndex == 0) {
        [btnCollection setImage:[UIImage imageNamed:@"btn_grid_press.png"] forState:UIControlStateNormal];
        [btnList setImage:[UIImage imageNamed:@"btn_list.png"] forState:UIControlStateNormal];
        //[btnMap setBackgroundImage:[UIImage imageNamed:@"subBtn_bg1.png"] forState:UIControlStateNormal];
        //[btnFourth setBackgroundImage:[UIImage imageNamed:@"subBtn_bg1.png"] forState:UIControlStateNormal];
    }
    if (currentMenuIndex == 1) {
        [btnCollection setImage:[UIImage imageNamed:@"btn_grid.png"] forState:UIControlStateNormal];
        [btnList setImage:[UIImage imageNamed:@"btn_list_press.png"] forState:UIControlStateNormal];
        //[btnMap setBackgroundImage:[UIImage imageNamed:@"subBtn_bg1.png"] forState:UIControlStateNormal];
        //[btnFourth setBackgroundImage:[UIImage imageNamed:@"subBtn_bg1.png"] forState:UIControlStateNormal];
    }/*
    if (currentMenuIndex == 2) {
        [btnCollection setBackgroundImage:[UIImage imageNamed:@"subBtn_bg1.png"] forState:UIControlStateNormal];
        [btnList setBackgroundImage:[UIImage imageNamed:@"subBtn_bg1.png"] forState:UIControlStateNormal];
        [btnMap setBackgroundImage:[UIImage imageNamed:@"subBtn_bg.png"] forState:UIControlStateNormal];
        [btnFourth setBackgroundImage:[UIImage imageNamed:@"subBtn_bg1.png"] forState:UIControlStateNormal];
    }
    if (currentMenuIndex == 3) {
        [btnCollection setBackgroundImage:[UIImage imageNamed:@"subBtn_bg1.png"] forState:UIControlStateNormal];
        [btnList setBackgroundImage:[UIImage imageNamed:@"subBtn_bg1.png"] forState:UIControlStateNormal];
        [btnMap setBackgroundImage:[UIImage imageNamed:@"subBtn_bg1.png"] forState:UIControlStateNormal];
        [btnFourth setBackgroundImage:[UIImage imageNamed:@"subBtn_bg.png"] forState:UIControlStateNormal];
    }*/
    
}

- (void)startLoading{
    [loadingView setHidden:FALSE];
    [activityLoading startAnimating];
}

- (void)stopLoading{
    [loadingView setHidden:TRUE];
    [activityLoading stopAnimating];
}

- (void)toggleNotify:(id)sender{
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    NotifyListViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kNotifyListViewController"];
    [self.navigationController pushViewController:VC animated:YES];
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
	if (dataList.count == 0) {
        return;
    }
	
	UITableView* tb = (UITableView*)scrollView;
	
	float oy = tb.contentOffset.y;
    
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
    
    NSString *url = nil;
    if (isNewUpdate) {
        url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users/%@/shots?auth_token=%@&after=%@"
                         , [userData objectForKey:@"id"]
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
        url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users/%@/shots?auth_token=%@&before=%@"
               , [userData objectForKey:@"id"]
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

- (void)toggleReload:(id)sender{
    [btnFollow setHidden:TRUE];
    [btnUnfollow setHidden:TRUE];
    if ([self.userId isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]) {
        [btnLogout setHidden:FALSE];
        [btnNotify setHidden:FALSE];
        //[btnFollow setHidden:TRUE];
    }else{
        [btnLogout setHidden:TRUE];
        [btnNotify setHidden:TRUE];
        //[btnFollow setHidden:FALSE];
    }
    [self getUserInfo:self.userId];
    
    dataList = [[NSMutableArray alloc] init];
}
@end
