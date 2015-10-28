//
//  Comment.h
//  Supergram
//
//  Created by Rumiya Murtazina on 10/26/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import <Parse/Parse.h>

@class SuperUser;
@class Post;
@interface Comment : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property SuperUser *author;
@property Post *parent;
@property NSString *content;

@end
