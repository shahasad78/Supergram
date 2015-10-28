//
//  Activity.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/28/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "Activity.h"
#import <Parse/PFObject+Subclass.h>

@implementation Activity

@dynamic activityType;
@dynamic content;
@dynamic toUser;
@dynamic fromUser;
@dynamic post;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Activity";
}


@end
