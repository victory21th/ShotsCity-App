//
//  TagUserGetController.h
//  ShotCity
//
//  Created by dev on 13. 9. 5..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagUserGetController : NSObject<NSURLConnectionDelegate>{
    
    NSURLConnection *connection;
    NSMutableData* data;
    
}
@property (nonatomic, retain) UIViewController *viewController;
@property (nonatomic, retain) NSString *userName;

- (void) goTagUserProfileView:(NSString*)username viewController:(UIViewController*)viewControloler;

@end
