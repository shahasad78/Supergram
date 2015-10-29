//
//  SuperUser.h
//  Supergram
//
//  Created by Rumiya Murtazina on 10/22/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "SGConstants.h"

@interface SuperUser : PFUser <PFSubclassing>
@property PFFile *profilePic;
@property NSString *firstName;
@property NSString *lastName;
@property NSString *bio;
@property NSNumber *postCount;
@property NSMutableArray *likedPosts;
@property NSNumber *followingCount;
@property NSNumber *followerCount;

@end
