//
//  SelectSoundViewController.m
//  ShotsCity
//
//  Created by dev on 13. 11. 21..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import "SelectSoundViewController.h"
#import "AppSharedData.h"
#import "AppDelegate.h"

@interface SelectSoundViewController ()

@end

@implementation SelectSoundViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)toggleCancel:(id)sender{
    //[self.navigationController dismissModalViewControllerAnimated:NO];
    //[self.navigationController.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toggleNext:(id)sender{
    
    //[(AppDelegate*)[[UIApplication sharedApplication] delegate] setTempImage:theimageView.image];
    
    //UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
