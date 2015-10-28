//
//  Comment.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/26/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "Comment.h"
#import <Parse/PFObject+Subclass.h>

@implementation Comment

@dynamic author;
@dynamic parent;
@dynamic content;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Comment";
}

@end
