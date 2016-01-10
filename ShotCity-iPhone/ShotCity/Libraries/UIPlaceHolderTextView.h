//
//  UIPlaceHolderTextView.h
//  ShotCity
//
//  Created by dev on 13. 9. 4..
//  Copyright (c) 2013년 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
