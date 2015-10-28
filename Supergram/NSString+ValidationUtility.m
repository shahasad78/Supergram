//
//  NSString+ValidationUtility.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/22/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "NSString+ValidationUtility.h"

@implementation NSString (ValidationUtility)

+ (BOOL) isValidEmailAddress:(NSString *)emailAddress {
    // Base Case - No text
    if (!emailAddress.length) {
        return NO;
    }

    NSError *error = nil;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    NSRange fullRange = NSMakeRange(0, emailAddress.length);
    NSArray *matches = [detector matchesInString:emailAddress options:0 range:fullRange];
    // Detector should only find one pattern match.
    if (matches.count != 1) {
        return NO;
    }

    NSTextCheckingResult *result = [matches firstObject];
    if (![result.URL.scheme isEqual:@"mailto"]) {
        return NO;
    }
    if (!NSEqualRanges(result.range, fullRange)) {
        return NO;
    }

    return YES;
}

+ (BOOL) isValidUsername:(NSString *)username {
    unichar firstCharacter = [username characterAtIndex:0];
    return ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:firstCharacter];
}

+ (BOOL) isValidPassword:(NSString *)password {
    return ((password.length > 6) &&
            ([password rangeOfString:@" "].length == 0));
}

- (BOOL) isValidEmailAddress {
    // Base Case - No text
    if (!self.length) {
        return NO;
    }

    NSError *error = nil;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    NSRange fullRange = NSMakeRange(0, self.length);
    NSArray *matches = [detector matchesInString:self options:0 range:fullRange];
    // Detector should only find one pattern match.
    if (matches.count != 1) {
        return NO;
    }

    NSTextCheckingResult *result = [matches firstObject];
    if (![result.URL.scheme isEqual:@"mailto"]) {
        return NO;
    }
    if (!NSEqualRanges(result.range, fullRange)) {
        return NO;
    }

    return YES;
}

- (BOOL) isValidUsername {
    unichar firstCharacter = [self characterAtIndex:0];
    return ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:firstCharacter];
}

- (BOOL) isValidPassword {
    return ((self.length > 6) &&
            ([self rangeOfString:@" "].length == 0));
}

@end
