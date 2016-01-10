//
//  LoginViewController.h
//  ShotCity
//
//  Created by dev on 13. 8. 18..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UIWebViewDelegate>{
    
    IBOutlet UIWebView *myWebView;
    IBOutlet UIActivityIndicatorView *indicationView;
}

- (IBAction)toggleLoginViaFacebook:(id)sender;
@end

