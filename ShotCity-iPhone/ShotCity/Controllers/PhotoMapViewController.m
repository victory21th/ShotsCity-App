//
//  PhotoMapViewController.m
//  ShotCity
//
//  Created by dev on 13. 9. 11..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import "PhotoMapViewController.h"

@interface PhotoMapViewController ()

@end

@implementation PhotoMapViewController

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

- (void)toggleBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
