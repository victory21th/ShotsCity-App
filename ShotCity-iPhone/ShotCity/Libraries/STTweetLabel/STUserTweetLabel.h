//
//  STUserTweetLabel.h
//  STUserTweetLabel
//
//  Created by Sebastien Thiebaud on 12/14/12.
//  Copyright (c) 2012 Sebastien Thiebaud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTweetLabel.h"

/**
 A custom UILabel view controller for iOS with certain words tappable like Twitter (#Hashtag, @People and http://www.link.com/page)
 */
@interface STUserTweetLabel : UILabel
{
    NSMutableArray *sizeLines;
    
    NSMutableArray *touchLocations;
    NSMutableArray *touchWords;
}



/** @name Customizing the Text */

/**
 The font of the different links.
 
 The default value for this property is the font of the text.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, strong) UIFont *fontLink;
@property (nonatomic, strong) UIFont *fontUser;

/**
 The font of the different hashtags and mentions.
 
 The default value for this property is the font of the text.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, strong) UIFont *fontHashtag;

/**
 The color of the different links.
 
 The default value for this property is `RGB(170,170,170)`.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, strong) UIColor *colorLink;

/**
 The color of the different hashtags and mentions.
 
 The default value for this property is `RGB(129,171,193)`.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, strong) UIColor *colorHashtag;
@property (nonatomic, strong) UIColor *colorAccount;
@property (nonatomic, strong) UIColor *colorUser;

/**
 The color of the shadow text.
 
 The default value for this property is `RGB(0,0,0)`.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, strong) UIColor *shadowColor;

/**
 The size of the shadow text.
 
 The default value for this property is `CGSizeZero`.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, assign) CGSize shadowOffset;



/** @name Configuring the Spaces and Alignments */

/**
 The space between each word.
 
 The default value for this property is `0`.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, assign) float wordSpace;

/**
 The space between each line.
 
 The default value for this property is `0`.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, assign) float lineSpace;

/**
 The horizontal alignment of the text.
 
 The default value for this property is `STHorizontalAlignmentLeft`.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, assign) STHorizontalAlignment horizontalAlignment;

/**
 The vertical alignment of the text.
 
 The default value for this property is `STVerticalAlignmentTop`.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, assign) STVerticalAlignment verticalAlignment;



/** @name Managing the Delegate and Callback Block */

/**
 The object that acts as the delegate of the receiving tweet label view. (Deprecated in 2.0. Use callbackBlock instead.)
 
 The delegate must adopt the STLinkProtocol protocol.
 */
@property (nonatomic, strong) id<STLinkProtocol> delegate __attribute__ ((deprecated));

/**
 The block called when an user interaction is caught
 
 You can declare a STLinkCallbackBlock with `void(^STLinkCallbackBlock)(STLinkActionType actionType, NSString *link);`:
 
 STLinkCallbackBlock callbackBlock = ^(STLinkActionType actionType, NSString *link) {
 // Do something...
 };
 */
@property (nonatomic, copy) STLinkCallbackBlock callbackBlock;

- (CGSize) getFitSize;

+ (CGFloat) getFitHeightWithText:(NSString*)tweetText boundWidth:(CGFloat)boundWidth font:(UIFont*)tFont color:(UIColor*)tColor;

@end
