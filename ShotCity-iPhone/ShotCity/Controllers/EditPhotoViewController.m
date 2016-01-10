//
//  EditPhotoViewController.m
//  ShotCity
//
//  Created by dev on 13. 8. 23..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import "EditPhotoViewController.h"
#import "AppDelegate.h"
#import "SharePhotoViewController.h"
#import "AppSharedData.h"

@interface EditPhotoViewController ()

@end

@implementation EditPhotoViewController

@synthesize actionSheet, myImage;

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [theimageView setImage:[(AppDelegate*)[[UIApplication sharedApplication] delegate] tempImage]];
    myImage = theimageView.image;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleCancel:(id)sender{
    [self.navigationController dismissModalViewControllerAnimated:NO];
    //[self.navigationController.view removeFromSuperview];
}

- (void)toggleNext:(id)sender{
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setTempImage:theimageView.image];
    
    UIStoryboard *mainStoryboard = [AppDelegate getStoryboard];
    
    SharePhotoViewController *VC = [mainStoryboard instantiateViewControllerWithIdentifier:@"kSharePhotoViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}

/////// actions ////////////
- (IBAction)toggleFrame:(id)sender{
    maskImage = [UIImage imageNamed:@"bluegem.png"];
    //[theimageView setImage:[self maskImage:[(AppDelegate*)[[UIApplication sharedApplication] delegate] tempImage] withMask:maskImage]];
    
    [theimageView setImage:[self getMaskImage:[(AppDelegate*)[[UIApplication sharedApplication] delegate] tempImage] withMask:maskImage]];
}

- (IBAction)toggleBlur:(id)sender{
    maskImage = [UIImage imageNamed:@"mask1.png"];
    [theimageView setImage:[self maskImage:[(AppDelegate*)[[UIApplication sharedApplication] delegate] tempImage] withMask:maskImage]];
    
    myImage = theimageView.image;
}

- (IBAction)toggleGrayscale:(id)sender{
    [theimageView setImage:[AppSharedData grayishImage:[(AppDelegate*)[[UIApplication sharedApplication] delegate] tempImage]]];
    
    myImage = theimageView.image;
}

- (IBAction)toggleRotate:(id)sender{
    
    theimageView.image = [self scaleAndRotateImage:theimageView.image];
    
    myImage = theimageView.image;
}

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    
    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    
    // returns new image with mask applied
    //return maskedImage;
    
    UIGraphicsBeginImageContextWithOptions(theimageView.bounds.size, NO, 0.0);
    
    [maskedImage drawInRect:CGRectMake(0, 0, theimageView.frame.size.width, theimageView.frame.size.height)];
    
    //[maskedImage drawInRect:theimageView.bounds];
    
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return SaveImage;
}

- (UIImage*)scaleAndRotateImage:(UIImage *)image
{
    int kMaxResolution = 320; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    orient = nRotateIndex % 8;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    nRotateIndex ++;
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //[self setRotatedImage:imageCopy];
    return imageCopy;
}

- (UIImage*) getMaskImage:(UIImage *)image withMask:(UIImage *)maskImage{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //UIImage *maskImage = [UIImage imageNamed:@"mask3.png"];
    CGImageRef maskImageRef = [maskImage CGImage];
    
    // create a bitmap graphics context the size of the image
    CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width, maskImage.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    
    
    if (mainViewContentContext==NULL)
        return NULL;
    
    CGFloat ratio = 0;
    
    ratio = maskImage.size.width/ image.size.width;
    
    if(ratio * image.size.height < maskImage.size.height) {
        ratio = maskImage.size.height/ image.size.height;
    }
    
    CGRect rect1  = {{0, 0}, {maskImage.size.width, maskImage.size.height}};
    CGRect rect2  = {{-((image.size.width*ratio)-maskImage.size.width)/2 , -((image.size.height*ratio)-maskImage.size.height)/2}, {image.size.width*ratio, image.size.height*ratio}};
    
    
    CGContextClipToMask(mainViewContentContext, rect1, maskImageRef);
    CGContextDrawImage(mainViewContentContext, rect2, image.CGImage);
    
    
    // Create CGImageRef of the main view bitmap content, and then
    // release that bitmap context
    CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    UIImage *theImage = [UIImage imageWithCGImage:newImage];
    
    CGImageRelease(newImage);
    
    // return the image
    return theImage;
}

/////////
- (IBAction)toggleFrame0:(id)sender{
    [theimageView setImage:[(AppDelegate*)[[UIApplication sharedApplication] delegate] tempImage]];
        
    myImage = theimageView.image;
}
- (IBAction)toggleFrame1:(id)sender{
    maskImage = [UIImage imageNamed:@"mask4-1.png"];
    [theimageView setImage:[self maskImage:myImage withMask:maskImage]];
}
- (IBAction)toggleFrame2:(id)sender{
    UIImage *imageFrame = [UIImage imageNamed:@"mask2-1.png"];
    UIGraphicsBeginImageContextWithOptions(theimageView.bounds.size, NO, 0.0);
    
    [myImage drawInRect:CGRectMake(0, 0, theimageView.frame.size.width, theimageView.frame.size.height)];
    
    [imageFrame drawInRect:theimageView.bounds];
    
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [theimageView setImage: SaveImage];
}
- (IBAction)toggleFrame3:(id)sender{
    UIImage *imageFrame = [UIImage imageNamed:@"mask2-2.png"];
    UIGraphicsBeginImageContextWithOptions(theimageView.bounds.size, NO, 0.0);
    
    [myImage drawInRect:CGRectMake(0, 0, theimageView.frame.size.width, theimageView.frame.size.height)];
    
    [imageFrame drawInRect:theimageView.bounds];
    
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [theimageView setImage: SaveImage];
}
- (IBAction)toggleFrame4:(id)sender{
    maskImage = [UIImage imageNamed:@"mask1-4.png"];
    [theimageView setImage:[self maskImage:myImage withMask:maskImage]];
}
- (IBAction)toggleFrame5:(id)sender{
    maskImage = [UIImage imageNamed:@"mask1-2.png"];
    [theimageView setImage:[self maskImage:myImage withMask:maskImage]];
}
- (IBAction)toggleFrame6:(id)sender{
    maskImage = [UIImage imageNamed:@"mask3-1.png"];
    [theimageView setImage:[self maskImage:myImage withMask:maskImage]];
    
}- (IBAction)toggleFrame7:(id)sender{
    maskImage = [UIImage imageNamed:@"mask1-4.png"];
    [theimageView setImage:[self maskImage:[(AppDelegate*)[[UIApplication sharedApplication] delegate] tempImage] withMask:maskImage]];
    
}

- (IBAction)toggleFrame12:(id)sender{
    UIImage *imageFrame = [UIImage imageNamed:@"mask1-2.png"];
    UIGraphicsBeginImageContextWithOptions(theimageView.bounds.size, NO, 0.0);
    
    [myImage drawInRect:CGRectMake(0, 0, theimageView.frame.size.width, theimageView.frame.size.height)];
    
    [imageFrame drawInRect:theimageView.bounds];
    
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [theimageView setImage: SaveImage];
}


- (IBAction)toggleFrame21:(id)sender{
    UIImage *imageFrame = [UIImage imageNamed:@"mask2-1.png"];
    UIGraphicsBeginImageContextWithOptions(theimageView.bounds.size, NO, 0.0);
    
    [myImage drawInRect:CGRectMake(0, 0, theimageView.frame.size.width, theimageView.frame.size.height)];
    
    [imageFrame drawInRect:theimageView.bounds];
    
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [theimageView setImage: SaveImage];
}
- (IBAction)toggleFrame22:(id)sender{
    UIImage *imageFrame = [UIImage imageNamed:@"mask2-2.png"];
    UIGraphicsBeginImageContextWithOptions(theimageView.bounds.size, NO, 0.0);
    
    [myImage drawInRect:CGRectMake(0, 0, theimageView.frame.size.width, theimageView.frame.size.height)];
    
    [imageFrame drawInRect:theimageView.bounds];
    
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [theimageView setImage: SaveImage];
}
- (IBAction)toggleFrame23:(id)sender{
    UIImage *imageFrame = [UIImage imageNamed:@"mask2-3.png"];
    UIGraphicsBeginImageContextWithOptions(theimageView.bounds.size, NO, 0.0);
    
    [myImage drawInRect:CGRectMake(0, 0, theimageView.frame.size.width, theimageView.frame.size.height)];
    
    [imageFrame drawInRect:theimageView.bounds];
    
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [theimageView setImage: SaveImage];
}
- (IBAction)toggleFrame24:(id)sender{
    maskImage = [UIImage imageNamed:@"mask2-3.png"];
    [theimageView setImage:[self maskImage:myImage withMask:maskImage]];
    
}

- (IBAction)toggleFrame31:(id)sender{
    maskImage = [UIImage imageNamed:@"mask3-1.png"];
    [theimageView setImage:[self maskImage:myImage withMask:maskImage]];
    
}
- (IBAction)toggleFrame32:(id)sender{
    maskImage = [UIImage imageNamed:@"mask3-2.png"];
    [theimageView setImage:[self maskImage:myImage withMask:maskImage]];
    
}


- (IBAction)toggleFrame41:(id)sender{
    UIImage *imageFrame = [UIImage imageNamed:@"mask4-1.png"];
    UIGraphicsBeginImageContextWithOptions(theimageView.bounds.size, NO, 0.0);
    
    [myImage drawInRect:CGRectMake(0, 0, theimageView.frame.size.width, theimageView.frame.size.height)];
    
    [imageFrame drawInRect:theimageView.bounds];
    
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [theimageView setImage: SaveImage];
}
- (IBAction)toggleFrame42:(id)sender{
    UIImage *imageFrame = [UIImage imageNamed:@"mask4-2.png"];
    UIGraphicsBeginImageContextWithOptions(theimageView.bounds.size, NO, 0.0);
    
    [myImage drawInRect:CGRectMake(0, 0, theimageView.frame.size.width, theimageView.frame.size.height)];
    
    [imageFrame drawInRect:theimageView.bounds];
    
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [theimageView setImage: SaveImage];
}
- (IBAction)toggleFrame43:(id)sender{
    UIImage *imageFrame = [UIImage imageNamed:@"mask4-3.png"];
    UIGraphicsBeginImageContextWithOptions(theimageView.bounds.size, NO, 0.0);
    
    [myImage drawInRect:CGRectMake(0, 0, theimageView.frame.size.width, theimageView.frame.size.height)];
    
    [imageFrame drawInRect:theimageView.bounds];
    
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [theimageView setImage: SaveImage];
}

- (IBAction)toggleFrame51:(id)sender{
    UIImage *imageFrame = [UIImage imageNamed:@"mask5-1.png"];
    UIGraphicsBeginImageContextWithOptions(theimageView.bounds.size, NO, 0.0);
    
    [myImage drawInRect:CGRectMake(0, 0, theimageView.frame.size.width, theimageView.frame.size.height)];
    
    [imageFrame drawInRect:theimageView.bounds];
    
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [theimageView setImage: SaveImage];
}
- (IBAction)toggleFrame52:(id)sender{
    UIImage *imageFrame = [UIImage imageNamed:@"mask5-2.png"];
    UIGraphicsBeginImageContextWithOptions(theimageView.bounds.size, NO, 0.0);
    
    [myImage drawInRect:CGRectMake(0, 0, theimageView.frame.size.width, theimageView.frame.size.height)];
    
    [imageFrame drawInRect:theimageView.bounds];
    
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [theimageView setImage: SaveImage];
}
- (IBAction)toggleFrame53:(id)sender{
    UIImage *imageFrame = [UIImage imageNamed:@"mask5-3.png"];
    UIGraphicsBeginImageContextWithOptions(theimageView.bounds.size, NO, 0.0);
    
    [myImage drawInRect:CGRectMake(0, 0, theimageView.frame.size.width, theimageView.frame.size.height)];
    
    [imageFrame drawInRect:theimageView.bounds];
    
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [theimageView setImage: SaveImage];
}
- (IBAction)toggleFrame54:(id)sender{
    UIImage *imageFrame = [UIImage imageNamed:@"mask5-4.png"];
    UIGraphicsBeginImageContextWithOptions(theimageView.bounds.size, NO, 0.0);
    
    [myImage drawInRect:CGRectMake(0, 0, theimageView.frame.size.width, theimageView.frame.size.height)];
    
    [imageFrame drawInRect:theimageView.bounds];
    
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [theimageView setImage: SaveImage];
}
- (IBAction)toggleFrame55:(id)sender{
/*    UIImage *imageFrame = [UIImage imageNamed:@"mask5-5.png"];
    UIGraphicsBeginImageContextWithOptions(theimageView.bounds.size, NO, 0.0);
    
    [myImage drawInRect:CGRectMake(0, 0, theimageView.frame.size.width, theimageView.frame.size.height)];
    
    [imageFrame drawInRect:theimageView.bounds];
    
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [theimageView setImage: SaveImage];
    */
    maskImage = [UIImage imageNamed:@"mask5-5.png"];
    [theimageView setImage:[self maskImage:myImage withMask:maskImage]];
}

- (IBAction)toggleFrame56:(id)sender{
    UIImage *imageFrame = [UIImage imageNamed:@"mask5-4.png"];
    UIGraphicsBeginImageContextWithOptions(theimageView.bounds.size, NO, 0.0);
    
    [myImage drawInRect:CGRectMake(0, 0, theimageView.frame.size.width, theimageView.frame.size.height)];
    
    [imageFrame drawInRect:theimageView.bounds];
    
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [theimageView setImage: SaveImage];
    
    maskImage = [UIImage imageNamed:@"mask3-2.png"];
    [theimageView setImage:[self maskImage:SaveImage withMask:maskImage]];
    
}

@end
