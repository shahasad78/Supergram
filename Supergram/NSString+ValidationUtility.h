//
//  NSString+ValidationUtility.h
//  Supergram
//
//  Created by Rumiya Murtazina on 10/22/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ValidationUtility)

+ (BOOL) isValidEmailAddress:(NSString *)emailAddress;
+ (BOOL) isValidUsername:(NSString *)username;
+ (BOOL) isValidPassword:(NSString *)password;

- (BOOL) isValidEmailAddress;
- (BOOL) isValidUsername;
- (BOOL) isValidPassword;

@end
