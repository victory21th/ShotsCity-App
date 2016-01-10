//
//  SearchViewController.m
//  ShotCity
//
//  Created by dev on 13. 8. 19..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "SearchViewController.h"
#import "Image.h"
#import "AppDelegate.h"
#import "AppSharedData.h"
#import "PhotoListData.h"
#import <QuartzCore/QuartzCore.h>
#import "UserModel.h"
#import "ProfileViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController


- (void)viewDidLoad{
    [super viewDidLoad];
      
    imageDownloadsInProgress = [NSMutableDictionary dictionary];
    dataList = [[NSMutableArray alloc] init];
    
    if (self.searchString != nil) {
        lbSearch.text = self.searchString;
    }
    
}

- (void)updateUserData{
    
    [NSThread detachNewThreadSelector:@selector(searchUser:) toTarget:self withObject:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [dataList removeAllObjects];
    [myCollectionView reloadData];
    
    [self performSelector:@selector(searchUser:) withObject:nil afterDelay:0.001f];
}

//
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [dataList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PhotoCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSURL* url = [NSURL URLWithString:[[dataList objectAtIndex:indexPath.row] imgUrl]];
    if (cell == nil) {
        //NSURL* url = [NSURL URLWithString:@"http://graph.facebook.com/100004790670119/picture?type=square"];
        Image *img = [[Image alloc] initWithFrame:CGRectMake(6, 6, 90, 90)];
        img.tag = 888;
        [img setDefaultImage:[UIImage imageNamed:@"no-profile.jpg"]];
        
        [img initWithImageAtURL:url];
        [cell.contentView addSubview:img];
    }
    Image *img = (Image*)[cell viewWithTag:100];
    if (img != nil) {
        [img removeFromSuperview];
    }
    img = [[Image alloc] initWithFrame:CGRectMake(6, 6, 90, 90)];
    img.tag = 100;
    [img setDefaultImage:[UIImage imageNamed:@"no-profile.jpg"]];
    
    [img initWithImageAtURL:url];
    [cell.contentView addSubview:img];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    ProfileViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kProfileViewController"];
    [VC setUserId:[[dataList objectAtIndex:indexPath.row] uid]];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)resigneKeyboard:(id)sender{
    NSString *searchStr = lbSearch.text;
    NSString *url;
    if (searchStr == nil || [searchStr isEqual:@""]) {
        url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users?auth_token=%@"
               , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
               , searchStr];
        
    }else{
        url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users?auth_token=%@&username=%@"
               , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
               , searchStr];
        
    }
    /*        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
     
     [urlRequest setURL:[NSURL URLWithString:url]];
     [urlRequest setHTTPMethod:@"GET"];
     
     NSData *urlData;
     NSURLResponse *theString;
     NSError *error;
     
     urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&theString error:&error];
     
     NSLog(@"%@", url);
     */
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    
    
    data = nil;
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    
    [self startLoading];
    
    
    
    
    lbSearch.text = @"";
    [self resignFirstResponder];
}


//////
- (void) updateSearchData{
    
    NSString *url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users?auth_token=%@"
                     , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    
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
                NSArray *users = [jsonObjects objectForKey:@"users"];
                
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
                    UserModel *user = [[UserModel alloc] init];
                    NSDictionary *item = [users objectAtIndex:i];
                    
                    [user setUserDataWithUID:[item objectForKey:@"id"]
                                    userName:[item objectForKey:@"username"]
                                        Name:[item objectForKey:@"name"]
                                    imageUrl:[item objectForKey:@"image_url"]
                                      Gender:[item objectForKey:@"gender"]
                                       Email:[item objectForKey:@"email"]
                                        Link:[item objectForKey:@"link"]
                                       Local:[item objectForKey:@"locale"]
                                    Timezone:[item objectForKey:@"timezone"]
                                    Follower:[item objectForKey:@"follower"]
                                   Follwoing:[item objectForKey:@"following"]
                                      Counts:[item objectForKey:@"counts"]];
                    
                    [dataList addObject:user];
                }
                
                [myCollectionView reloadData];
            }
        }
        
    }
}

- (void)searchUser:(id)sender{
    NSString *searchStr = lbSearch.text;
    NSString *url;
    if (searchStr == nil || [searchStr isEqual:@""]) {
        url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users?auth_token=%@"
                         , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
                         , searchStr];
        
    }else{
        url = [NSString stringWithFormat:@"http://shots-city-api-staging.herokuapp.com/v1/users?auth_token=%@&username=%@"
                         , [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
                         , searchStr];
        
    }
/*        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
        
        [urlRequest setURL:[NSURL URLWithString:url]];
        [urlRequest setHTTPMethod:@"GET"];
        
        NSData *urlData;
        NSURLResponse *theString;
        NSError *error;
        
        urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&theString error:&error];
        
        NSLog(@"%@", url);
    */
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
                NSArray *users = [jsonObjects objectForKey:@"users"];
                
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
                    UserModel *user = [[UserModel alloc] init];
                    NSDictionary *item = [users objectAtIndex:i];
                    
                    [user setUserDataWithUID:[item objectForKey:@"id"]
                                    userName:[item objectForKey:@"username"]
                                        Name:[item objectForKey:@"name"]
                                    imageUrl:[item objectForKey:@"image_url"]
                                      Gender:[item objectForKey:@"gender"]
                                       Email:[item objectForKey:@"email"]
                                        Link:[item objectForKey:@"link"]
                                       Local:[item objectForKey:@"locale"]
                                    Timezone:[item objectForKey:@"timezone"]
                                    Follower:[item objectForKey:@"follower"]
                                   Follwoing:[item objectForKey:@"following"]
                                      Counts:[item objectForKey:@"counts"]];
                    
                    [dataList addObject:user];
                }
                
                [myCollectionView reloadData];
            }
        }
        
    }
}

- (void)searchUserWithUserName:(NSString*)username{
    lbSearch.text = username;
    self.searchString = username;
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
