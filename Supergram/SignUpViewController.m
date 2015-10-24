//
//  SignUpViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/22/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation SignUpViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Text Field Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

#pragma mark - Helper Methods
- (BOOL)isValidEmailAddress:(NSString *)emailAddress {
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


#pragma mark - IBAction Methods
- (IBAction)onSignUpButtonPressed:(UIButton *)sender {

    [self.spinner startAnimating];

    PFUser *user = [PFUser new];
    // TODO: validate username, password & email

    user.username = self.usernameTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;

    __block NSString *alertTitle = @"";
    __block NSString *alertMessage = @"";

    __weak SignUpViewController *weakSelf = self;
    if ([self isValidEmailAddress:self.emailTextField.text]) {
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [self.spinner stopAnimating];

            alertTitle = (error == nil) ? @"Success" :  @"Error";
            alertMessage = (error == nil) ? @"Signed Up"  : error.description;

            dispatch_async(dispatch_get_main_queue(), ^{

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle
                                                                               message:alertMessage
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Okay!"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];
                [alert addAction:okButton];

                [weakSelf presentViewController:alert animated:YES completion:nil];
            });
            
            
        }];
        
    } else {
        NSLog(@"%@ is not a valid email address", self.emailTextField.text);
    }
}


@end
