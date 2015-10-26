//
//  Post.h
//  Supergram
//
//  Created by Rumiya Murtazina on 10/25/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Foundation/Foundation.h>

@class SuperUser;
@interface Post : PFObject
@property SuperUser *author;
@property PFFile *media;
@property NSString *title;
@property NSInteger *likesCount;
@property NSInteger *commentCount;

@end
