//
//  Activity.h
//  Supergram
//
//  Created by Rumiya Murtazina on 10/28/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import <Parse/Parse.h>

@class SuperUser;
@class Post;

@interface Activity : PFObject <PFSubclassing>

+ (NSString *)parseClassName;
@property NSString *activityType;
@property NSString *content;
@property SuperUser *toUser;
@property SuperUser *fromUser;
@property Post *post;

@end
