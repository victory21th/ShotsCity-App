//
//  Image.h
//  LSVS
//
//  Created by Mathias Müller on 05.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageDownloaderDelegate;

@interface Image : UIImageView <NSURLConnectionDelegate>{
    id <ImageDownloaderDelegate> delegate;
    
    NSURLConnection *connection;
    NSMutableData* data;
    UIActivityIndicatorView *ai;
    
    NSString *loadedUrl;
}

-(void)initWithImageAtURL:(NSURL*)url;
-(void)initWithImageAtURL:(NSURL *)url withIndicatorStyle:(UIActivityIndicatorViewStyle)style;

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) UIActivityIndicatorView *ai;
@property (nonatomic, retain) UIImage *defaultImage;
@property (nonatomic, retain) id <ImageDownloaderDelegate> delegate;

@end

@protocol ImageDownloaderDelegate<NSObject>
@optional
- (void)imageDidLoad:(BOOL)isDown;

@end