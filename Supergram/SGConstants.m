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

    .followingCount = @"followingCount",
    .followerCount  = @"followerCount",
    .profilePic     = @"profilePic",
    .postCount      = @"postCount",
    .firstName      = @"firstName",
    .lastName       = @"lastName",
    .username       = @"userName",
    .email          = @"email",
    .bio            = @"bio"
};


// --------------------------------------------------------------------
// Post Attribute Key Constants
// --------------------------------------------------------------------
NSString *const kPostClass = @"Post";

const struct kPostAttributeKey kPostAttributeKey = {
    .post           = @"Post",
    .title          = @"title",
    .media          = @"media",
    .author         = @"author",
    .likesCount     = @"likesCount",
    .commentCount   = @"commentCount"
};

// --------------------------------------------------------------------
// Comment Attribute Key Constants
// --------------------------------------------------------------------
const struct kCommentAttributeKey kCommentAttributeKey = {
    .content    = @"content"
};

// --------------------------------------------------------------------
// Segue Identifier Constants
// --------------------------------------------------------------------
const struct kSegueIdentifiers kSegueIdentifiers = {
    .selectPhoto    = @"SelectPhotoSegue",
    .postDetail     = @"PostDetailSegue",
    .userSettings   = @"UserSettingsSegue"
};

// --------------------------------------------------------------------
// Activity Class Constants
// --------------------------------------------------------------------
NSString *const kActivityClass = @"Activity";

const struct kActivityKey kActivityKey = {
    // Field keys
    .type       = @"activityType",
    .fromUser   = @"fromUser",
    .toUser     = @"toUser",
    .post       = @"post",
    .photo      = @"photo",
};

const struct kActivityType kActivityType = {
    // Type values
    .like       = @"like",
    .post       = @"post",
    .follow     = @"follow",
    .comment    = @"comment",
    .joined     = @"joined"

};