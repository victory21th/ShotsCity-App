//
//  UserModel.h
//  TestSample
//
//  Created by dev on 13. 8. 7..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject{
    NSString *uid;
    NSString *userName;
    NSString *name;
    NSString *imgUrl;
    NSString *gender;
    
    NSString *email;
    NSString *link;
    NSString *locale;
    NSString *timezone;
    NSString *follower;
    NSString *following;
    NSDictionary *counts;
}
@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *imgUrl;
@property (nonatomic, retain) NSString *gender;

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *locale;
@property (nonatomic, retain) NSString *timezone;
@property (nonatomic, retain) NSString *follower;
@property (nonatomic, retain) NSString *following;
@property (nonatomic, retain) NSDictionary *counts;

@property (nonatomic, retain) UIImage *image;

- (void) setUserDataWithUserID:(NSString*)userId userName:(NSString*)user_name Name:(NSString*)name1 imageUrl:(NSString*)url Gender:(NSString*)gender1;

- (void)setUserDataWithUID:(NSString *)userId userName:(NSString *)user_name
                      Name:(NSString *)name1 imageUrl:(NSString *)url
                    Gender:(NSString *)gender1
                     Email:(NSString*)email1 Link:(NSString*)link1
                     Local:(NSString*)local1 Timezone:(NSString*)timezone1
                  Follower:(NSString*)follower1 Follwoing:(NSString*)following1 Counts:(NSDictionary*)counts1;

@end
