/*

 
 */

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MoviePlayerUserPrefs : NSObject 
{
}

+ (MPMovieScalingMode)scalingModeUserSetting;
+ (MPMovieControlStyle)controlStyleUserSetting;
+ (UIColor *)backgroundColorUserSetting;
+ (MPMovieRepeatMode)repeatModeUserSetting;
+ (BOOL)audioSessionUserSetting;
+ (BOOL)backgroundImageUserSetting;

@end
