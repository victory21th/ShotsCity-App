//
//  ADVSociovilleTheme.m
//
//
//  Created by Valentin Filip on 7/9/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "ADVFitpulseTheme.h"
#import "UIImage+iPhone5.h"

@implementation ADVFitpulseTheme

- (UIStatusBarStyle)statusBarStyle {
    return UIStatusBarStyleBlackOpaque;
}

- (UIColor *)mainColor {
    return [UIColor colorWithWhite:0.3 alpha:1.0];
}

- (UIColor *)secondColor {
    return [UIColor blackColor];
}

- (UIColor *)navigationTextColor {
    return [UIColor colorWithWhite:1.0 alpha:1.0];
}

- (UIColor *)highlightColor
{
    return [UIColor colorWithWhite:0.9 alpha:1.0];
}

- (UIColor *)shadowColor
{
    return [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (UIColor *)highlightShadowColor
{
    return [UIColor colorWithWhite:0.3 alpha:0.7];
}

- (UIColor *)navigationTextShadowColor {
    return [UIColor blackColor];
}

- (UIFont *)navigationFont {
    return [UIFont fontWithName:@"HelveticaNeue Bold" size:24];
}

- (UIColor *)backgroundColor
{
    return [UIColor colorWithWhite:0.85 alpha:1.0];
}

- (UIColor *)baseTintColor
{
    return nil;
}

- (UIColor *)accentTintColor
{
    return nil;
}

- (UIColor *)selectedTabbarItemTintColor
{
    return [UIColor blackColor];
}

- (UIColor *)switchThumbColor
{
    return [UIColor blackColor];
}

- (UIColor *)switchOnColor
{
    return [UIColor blackColor];
}

- (UIColor *)switchTintColor
{
    return [UIColor blackColor];;
}

- (CGSize)shadowOffset
{
    return CGSizeMake(0.0, 1.0);
}

- (UIImage *)topShadow
{
    return [UIImage tallImageNamed:@"topShadow"];
}

- (UIImage *)bottomShadow
{
    return [UIImage tallImageNamed:@"bottomShadow"];
}

- (UIImage *)navigationBackgroundForBarMetrics:(UIBarMetrics)metrics
{
    NSString *name = @"navigationBackground";
    if (metrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    UIImage *image = [UIImage tallImageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)];
    return image;
}

- (UIImage *)navigationBackgroundForIPadAndOrientation:(UIInterfaceOrientation)orientation {
    NSString *name = @"navigationBackgroundRight";
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    UIImage *image = [UIImage tallImageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)];
    return image;
}

- (UIImage *)barButtonBackgroundForState:(UIControlState)state style:(UIBarButtonItemStyle)style barMetrics:(UIBarMetrics)barMetrics
{
    NSString *name = @"barButton";
    if (style == UIBarButtonItemStyleDone) {
        name = [name stringByAppendingString:@"Done"];
    }
    if (barMetrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    }
    UIImage *image = [UIImage tallImageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    return image;
}

- (UIImage *)backBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics
{
    NSString *name = @"backButton";
    if (barMetrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    }
    UIImage *image = [UIImage tallImageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 21.0, 0.0, 13.0)];
    return image;
}

- (UIImage *)toolbarBackgroundForBarMetrics:(UIBarMetrics)metrics
{
    NSString *name = @"toolbarBackground";
    if (metrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    UIImage *image = [UIImage tallImageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)];
    return image;
}

- (UIImage *)searchBackground
{
    return [UIImage tallImageNamed:@"searchBackground"];
}

- (UIImage *)searchFieldImage
{
    UIImage *image = [UIImage tallImageNamed:@"searchField"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0)];
    return image;
}

- (UIImage *)searchScopeButtonBackgroundForState:(UIControlState)state
{
    NSString *name = @"searchScopeButton";
    if (state == UIControlStateSelected) {
        name = [name stringByAppendingString:@"Selected"];
    }
    UIImage *image = [UIImage tallImageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6.0, 6.0, 6.0, 6.0)];
    return image;
}

- (UIImage *)searchScopeButtonDivider
{
    return [UIImage tallImageNamed:@"searchScopeButtonDivider"];
}

- (UIImage *)searchImageForIcon:(UISearchBarIcon)icon state:(UIControlState)state
{
    NSString *name;
    if (icon == UISearchBarIconSearch) {
        name = @"searchIconSearch";
    } else if (icon == UISearchBarIconClear) {
        name = @"searchIconClear";
        if (state == UIControlStateHighlighted) {
            name = [name stringByAppendingString:@"Highlighted"];
        }
    }
    return (name ? [UIImage tallImageNamed:name] : nil);
}

- (UIImage *)segmentedBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics;
{
    NSString *name = @"segmentedBackground";
    if (barMetrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    if (state == UIControlStateSelected) {
        name = [name stringByAppendingString:@"Selected"];
    }
    UIImage *image = [UIImage tallImageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
    return image;
}

- (UIImage *)segmentedDividerForBarMetrics:(UIBarMetrics)barMetrics
{
    NSString *name = @"segmentedDivider";
    if (barMetrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    return [UIImage tallImageNamed:name];
}

- (UIImage *)tableBackground
{
    UIImage *image = [UIImage tallImageNamed:@"background"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    return image;
}

- (UIImage *)tableSectionHeaderBackground {
    UIImage *image = [UIImage tallImageNamed:@"list-section-header-bg"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    return image;
}


- (UIImage *)tableFooterBackground {
    UIImage *image = [UIImage tallImageNamed:@"list-footer-bg"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    return image;
}

- (UIImage *)viewBackground
{
    UIImage *image = [UIImage tallImageNamed:@"background"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    return image;
}

- (UIImage *)switchOnImage
{
    return [UIImage tallImageNamed:@"switchOnBackground"];
}

- (UIImage *)switchOffImage
{
    return [UIImage tallImageNamed:@"switchOffBackground"];
}


- (UIImage *)switchThumbForState:(UIControlState)state {
    NSString *name = @"switchHandle";
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    }
    return [UIImage tallImageNamed:name];
}

- (UIImage *)sliderThumbForState:(UIControlState)state
{
    NSString *name = @"sliderThumb";
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    }
    return [UIImage tallImageNamed:name];
}

- (UIImage *)sliderMinTrack
{
    UIImage *image = [UIImage tallImageNamed:@"sliderMinTrack"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 35.0, 0.0, 35.0)];
    return image;
}

- (UIImage *)sliderMaxTrack
{
    UIImage *image = [UIImage tallImageNamed:@"sliderMaxTrack"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 35.0, 0.0, 35.0)];
    return image;
}

- (UIImage *)progressTrackImage
{
    UIImage *image = [UIImage tallImageNamed:@"progress-segmented-track"];
    return image;
}

- (UIImage *)progressProgressImage
{
    UIImage *image = [UIImage tallImageNamed:@"progress-segmented-fill"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    return image;
}

- (UIImage *)progressPercentTrackImage
{
    UIImage *image = [UIImage tallImageNamed:@"progressTrack"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
    return image;
}

- (UIImage *)progressPercentProgressImage
{
    UIImage *image = [UIImage tallImageNamed:@"progressProgress"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
    return image;
}

- (UIImage *)stepperBackgroundForState:(UIControlState)state
{
    NSString *name = @"stepperBackground";
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    } else if (state == UIControlStateDisabled) {
        name = [name stringByAppendingString:@"Disabled"];
    }
    UIImage *image = [UIImage tallImageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 13.0, 0.0, 13.0)];
    return image;
}

- (UIImage *)stepperDividerForState:(UIControlState)state
{
    NSString *name = @"stepperDivider";
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    }
    return [UIImage tallImageNamed:name];
}

- (UIImage *)stepperIncrementImage
{
    return [UIImage tallImageNamed:@"stepperIncrement"];
}

- (UIImage *)stepperDecrementImage
{
    return [UIImage tallImageNamed:@"stepperDecrement"];
}

- (UIImage *)buttonBackgroundForState:(UIControlState)state
{
    NSString *name = @"button";
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    } else if (state == UIControlStateDisabled) {
        name = [name stringByAppendingString:@"Disabled"];
    }
    UIImage *image = [UIImage tallImageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0)];
    return image;
}

- (UIImage *)tabBarBackground
{
    return [UIImage tallImageNamed:@"tabBarBackground3"];
}

- (UIImage *)tabBarSelectionIndicator
{
    return [UIImage tallImageNamed:@"tabBarSelectionIndicator"];
}

- (UIImage *)imageForTab:(SSThemeTab)tab
{
    return nil;
}

- (UIImage *)finishedImageForTab:(SSThemeTab)tab selected:(BOOL)selected
{
    NSLog(@"finishedImageForTab:%d selected:%@", tab, selected ? @"YES" : @"NO");
    
    NSString *name = nil;
    if (tab == SSThemeTabMe) {
        name = @"menu01";
    } else if (tab == SSThemeTabWorkouts) {
        name = @"menu02";
    } else if (tab == SSThemeTabElements) {
        name = @"menu03";
    } else if (tab == SSThemeTabExtra) {
        name = @"menu04";
    } else if (tab == SSThemeTabLinks) {
        name = @"menu05";
        
    }
    if (selected) {
        name = [NSString stringWithFormat:@"%@_press", name];
    }
    
    NSLog(@"finishedImageForTab image name %@", name);
    
    return (name ? [UIImage tallImageNamed:name] : nil);
}


@end