//
//  AppSharedData.m
//  NVRMobile
//
//  Created by System Administrator on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AppSharedData.h"
#import "base64.h"
#import "NSData+Base64.h"

@implementation AppSharedData


@synthesize interfaceOrientation;
@synthesize searchList;
@synthesize push_token;
@synthesize capturedMovieUrl, selectedSoundUrl;
@synthesize selectedShotId;

static AppSharedData *sharedInstance = nil;

+ (AppSharedData*) sharedInstance {
	if (!sharedInstance) {
		sharedInstance = [[self alloc] init];
	}
	return sharedInstance;
}


//문자열이 빈값인가를 검사
+ (BOOL)isBlankString:(NSString*)str {
	if(str == nil || [str isEqualToString:@""]) {
		return TRUE;
	}else {
		return FALSE;
	}
}


- (id)init {
	if (self = [super init]) {
		
		interfaceOrientation = UIInterfaceOrientationPortrait;
		
		
	}
	
	return self;
}

+ (NSString *) GetBase64String:(UIImage*)image{
//	NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSData *imageData1 = UIImagePNGRepresentation(image);
	//And then apply Base64 encoding to convert it into base-64 encoded string
	//NSString *encodedString = [imageData base64Encoding];
	NSString *encodedString = [imageData1 base64EncodingWithLineLength:0];
	//	//NSLog    (@"encodedString : %@", encodedString);
	
	return encodedString;
}

// Transform the image in grayscale.
+ (UIImage *)grayishImage:(UIImage *)inputImage {
    
    // Create a graphic context.
    UIGraphicsBeginImageContextWithOptions(inputImage.size, YES, 1.0);
    CGRect imageRect = CGRectMake(0, 0, inputImage.size.width, inputImage.size.height);
    
    // Draw the image with the luminosity blend mode.
    // On top of a white background, this will give a black and white image.
    [inputImage drawInRect:imageRect blendMode:kCGBlendModeLuminosity alpha:1.0];
    
    // Get the resulting image.
    UIImage *filteredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return filteredImage;
}

+ (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}

+ (AVCaptureDevice *)backCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            return device;
        }
    }
    return nil;
}

@end
