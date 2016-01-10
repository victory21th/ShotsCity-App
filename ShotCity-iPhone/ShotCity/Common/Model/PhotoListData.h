//
//  PhotoListData.h
//  HenHouse
//
//  Created by dev on 13. 6. 21..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoListData : NSObject {
	
    NSString *user_id;
	NSString *photo_url;
}

@property (nonatomic, retain) NSString *user_id;
@property (nonatomic, retain) NSString *photo_url;
@property (nonatomic, retain) UIImage *image;

@end
