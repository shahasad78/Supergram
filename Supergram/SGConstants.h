//
//  SGConstants.h
//  Supergram
//
//  Created by Richard Martinez on 10/24/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - PFObject Attributes

/*!
 * @namespace kPFObjectAttributeKey
 * @abstract Namespace to hold PFUser attribute keys.
 * @updated 2015-24-10
 */
extern const struct kPFObjectAttributeKey {
    __unsafe_unretained NSString *const objectId;
    __unsafe_unretained NSString *const updatedAt;
    __unsafe_unretained NSString *const createdAt;
    __unsafe_unretained NSString *const parseClassName;
    __unsafe_unretained NSString *const ACL;
} kPFObjectAttributeKey;

#pragma mark - SuperUser Attributes

extern NSString *const kSuperUserClass;

/*!
 * @namespace kSuperUserAttributeKey
 * @abstract Namespace to hold SuperUser attribute keys.
 * @updated 2015-24-10
 */
extern const struct kSuperUserAttributeKey {
    __unsafe_unretained NSString *const followingCount;
    __unsafe_unretained NSString *const followerCount;
    __unsafe_unretained NSString *const likedPosts;
    __unsafe_unretained NSString *const profilePic;
    __unsafe_unretained NSString *const postCount;
    __unsafe_unretained NSString *const firstName;
    __unsafe_unretained NSString *const lastName;
    __unsafe_unretained NSString *const username;
    __unsafe_unretained NSString *const email;
    __unsafe_unretained NSString *const bio;
} kSuperUserAttributeKey;


#pragma mark - Post Class Attributes
extern NSString *const kPostClass;
/*!
 * @namespace kPostAttributeKey
 * @abstract Namespace to hold Post attribute keys.
 * @updated 2015-29-10
 */

extern const struct kPostAttributeKey {
    __unsafe_unretained NSString *const post;
    __unsafe_unretained NSString *const likes;
    __unsafe_unretained NSString *const title;
    __unsafe_unretained NSString *const media;
    __unsafe_unretained NSString *const author;
    __unsafe_unretained NSString *const likesCount;
    __unsafe_unretained NSString *const commentCount;
} kPostAttributeKey;

/*!
 * @namespace kCommenttAttributeKey
 * @abstract Namespace to hold Comment attribute keys.
 * @updated 2015-25-10
 */
extern NSString *const kCommentClass;
extern const struct kCommentAttributeKey {
    __unsafe_unretained NSString *const parent;
    __unsafe_unretained NSString *const content;
} kCommentAttributeKey;

/*!
 * @namespace kSegueIdentifiers
 * @abstract Namespace to hold Segue Identifiers
 * @updated 2015-25-10
 */
extern const struct kSegueIdentifiers {
    __unsafe_unretained NSString *const postDetail;
    __unsafe_unretained NSString *const selectPhoto;
    __unsafe_unretained NSString *const userSettings;
} kSegueIdentifiers;

#pragma mark - Activity Class
extern NSString *const kActivityClass;
/*!
 * @namespace kActivityKey
 * @abstract Namespace to hold Activity Attribute Keys
 * @updated 2015-25-10
 */
extern const struct kActivityKey {
    // Field keys
    __unsafe_unretained NSString *const post;
    __unsafe_unretained NSString *const type;
    __unsafe_unretained NSString *const photo;
    __unsafe_unretained NSString *const toUser;
    __unsafe_unretained NSString *const fromUser;

} kActivityKey;

/*!
 * @namespace kActivityType
 * @abstract Namespace to hold Activity Type Keys such as like and follow
 * @updated 2015-25-10
 */
extern const struct kActivityType {
    // Type values
    __unsafe_unretained NSString *const like;
    __unsafe_unretained NSString *const post;
    __unsafe_unretained NSString *const follow;
    __unsafe_unretained NSString *const comment;
    __unsafe_unretained NSString *const joined;
} kActivityType;
