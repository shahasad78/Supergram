//
//  SGConstants.m
//  Supergram
//
//  Created by Richard Martinez on 10/24/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "SGConstants.h"

// --------------------------------------------------------------------
// Standard PFObject Attribute Constants
// --------------------------------------------------------------------
const struct kPFObjectAttributeKey kPFObjectAttributeKey = {
    .objectId       = @"objectId",
    .updatedAt      = @"updatedAt",
    .createdAt      = @"createdAt",
    .ACL            = @"ACL",
    .parseClassName = @"parseClassName"
};

// --------------------------------------------------------------------
// Super User Attribute Key Constants
// --------------------------------------------------------------------
const struct kSuperUserAttributeKey kSuperUserAttributeKey = {
    .profilePic = @"profilePic",
    .firstName  = @"firstName",
    .lastName   = @"lastName",
    .username   = @"userName",
    .email      = @"email"
};


// --------------------------------------------------------------------
// Post Attribute Key Constants
// --------------------------------------------------------------------
const struct kPostAttributeKey kPostAttributeKey = {
    .post       = @"Post",
    .title      = @"title",
    .media      = @"media",
    .author     = @"author",
    .likesCount = @"likesCount",
    .commentCount = @"commentCount"
};