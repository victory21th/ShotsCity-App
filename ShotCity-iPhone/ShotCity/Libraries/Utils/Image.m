//
//  Image.m
//  LSVS
//
//  Created by Mathias Müller on 05.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Image.h"


@implementation Image
@synthesize ai,connection, data;
@synthesize defaultImage;

@synthesize delegate;

-(void)initWithImageAtURL:(NSURL*)url
{
    if (url == [NSNull null]) {
        [self setImage:self.defaultImage];
        return;
    }
    
    NSLog(@"absolute string : %@", [url absoluteString]);
    if ([[url absoluteString] isEqual:loadedUrl]) {
        if([self.delegate respondsToSelector:@selector(imageDidLoad:)])
        {
            //send the delegate function with the amount entered by the user
            [delegate imageDidLoad:TRUE];
        }
        return;
    }
    loadedUrl = [url absoluteString];
    [self setContentMode:UIViewContentModeScaleAspectFit];
    if (!ai){
        if (self.frame.size.width > 50) {
            [self setAi:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]];
        }else
            [self setAi:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
        [ai startAnimating];
        [ai setFrame:CGRectMake(self.frame.size.width/2 - 10, self.frame.size.height/2 - 10, 20, 20)];
        [self addSubview:ai];
        
        [self setImage:self.defaultImage];
        
        
        [self setNeedsDisplay];
        [self reloadInputViews];
    }
	data = nil;
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];    
	
}

- (void)initWithImageAtURL:(NSURL *)url withIndicatorStyle:(UIActivityIndicatorViewStyle)style{
    [self setContentMode:UIViewContentModeScaleAspectFit];
    if (!ai){
        [self setAi:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style]];
        [ai startAnimating];
        [ai setFrame:CGRectMake(self.frame.size.width/2 - 30, self.frame.size.height/2 - 30, 60, 60)];
        [self addSubview:ai];
        
        [self setImage:self.defaultImage];
    }
	
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}

- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    if (data==nil) data = [[NSMutableData alloc] initWithCapacity:2048];
    [data appendData:incrementalData];  
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection 
{
    if ([data length] < 1024) {
        [self setImage:self.defaultImage];
        if([self.delegate respondsToSelector:@selector(imageDidLoad:)])
        {
            //send the delegate function with the amount entered by the user
            [delegate imageDidLoad:FALSE];
        }
    } else {
        [self setImage:[UIImage imageWithData: data]];
        [self setNeedsDisplay];
        if([self.delegate respondsToSelector:@selector(imageDidLoad:)])
        {
            //send the delegate function with the amount entered by the user
            [delegate imageDidLoad:TRUE];
        }
    }
    [self setNeedsDisplay];
    [self reloadInputViews];
    [ai removeFromSuperview];
    ai = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self setImage:self.defaultImage];
    [self setNeedsDisplay];
    [self reloadInputViews];
    [ai removeFromSuperview];
    ai = nil;
    if([self.delegate respondsToSelector:@selector(imageDidLoad:)])
    {
        //send the delegate function with the amount entered by the user
        [delegate imageDidLoad:FALSE];
    }
    
}


@end
