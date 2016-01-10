//
//  UserModel.m
//  TestSample
//
//  Created by dev on 13. 8. 7..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

@synthesize uid, userName, name, imgUrl, gender;
@synthesize email;
@synthesize link;
@synthesize locale;
@synthesize timezone;
@synthesize follower;
@synthesize following;
@synthesize counts;
@synthesize image;

- (void)setUserDataWithUserID:(NSString *)userId userName:(NSString *)user_name Name:(NSString *)name1 imageUrl:(NSString *)url Gender:(NSString *)gender1{
    [self setUid:userId];
    [self setUserName:user_name];
    [self setName:name1];
    [self setGender:gender1];
    [self setImgUrl:url];
    
}

- (void)setUserDataWithUID:(NSString *)userId userName:(NSString *)user_name
                      Name:(NSString *)name1 imageUrl:(NSString *)url
                    Gender:(NSString *)gender1
                     Email:(NSString*)email1 Link:(NSString*)link1
                     Local:(NSString*)local1 Timezone:(NSString*)timezone1
                  Follower:(NSString*)follower1 Follwoing:(NSString*)following1 Counts:(NSDictionary*)counts1{
    [self setUid:userId];
    [self setUserName:user_name];
    [self setName:name1];
    [self setGender:gender1];
    [self setImgUrl:url];
    
    [self setEmail:email1];
    [self setLink:link1];
    [self setLocale:local1];
    [self setTimezone:timezone1];
    [self setFollower:follower1];
    [self setFollowing:following1];
    [self setCounts:counts1];
    
}
@end
