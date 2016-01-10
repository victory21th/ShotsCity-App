//
//  AppSharedData.h
//  ShotCity
//
//  Created by dev on 13. 8. 19..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AppSharedData : NSObject {
	
	UIInterfaceOrientation interfaceOrientation;
}
@property 	UIInterfaceOrientation interfaceOrientation;
@property (nonatomic, retain) NSMutableArray *searchList;
@property (nonatomic, retain) NSString *push_token;
@property (nonatomic, retain) NSURL *capturedMovieUrl;
@property (nonatomic, retain) NSURL *selectedSoundUrl;
@property (nonatomic, retain) NSString *selectedShotId;

+ (AppSharedData*)sharedInstance;
+ (BOOL) isBlankString:(NSString*)str; //널이거나 빈문자렬인가를 검사

+ (NSString *) GetBase64String:(UIImage*)image;

///
+ (UIImage *)grayishImage:(UIImage *)inputImage;

+ (AVCaptureDevice *)frontCamera;
+ (AVCaptureDevice *)backCamera;

@end
