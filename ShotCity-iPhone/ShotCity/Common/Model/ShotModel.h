//
//  ShotModel.h
//  ShotCity
//
//  Created by dev on 13. 8. 20..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShotModel : NSObject{
    NSString *_id;
    NSString *create_at;
    NSDictionary *image;
    NSString *image_url;
    NSArray *tag_ids;
    NSString *text;
    NSString *updated_at;
    NSString *user_id;
}
@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *create_at;
@property (nonatomic, retain) NSDictionary *image;
@property (nonatomic, retain) NSString *image_url;
@property (nonatomic, retain) NSArray *tag_ids;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *updated_at;
@property (nonatomic, retain) NSString *user_id;

@end
