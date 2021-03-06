//
//  SuperUser.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/22/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "SuperUser.h"
#import <Parse/PFObject+Subclass.h>

@implementation SuperUser

@dynamic profilePic;
@dynamic firstName;
@dynamic lastName;
@dynamic likedPosts;
@dynamic bio;
@dynamic postCount;
@dynamic followerCount;
@dynamic followingCount;

+ (void) load {
    [self registerSubclass];
}
//+ (NSString *)parseClassName {
//    return @"SuperUser";
//}
@end
