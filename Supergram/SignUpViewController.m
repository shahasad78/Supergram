//
//  SignUpViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/22/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "SignUpViewController.h"
#import "NSString+ValidationUtility.h"
#import "SuperUser.h"
#import <Parse/Parse.h>

@interface SignUpViewController () <UITextFieldDelegate>

// IBOutlet properties
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

// UI Control state properties
@property (strong, nonatomic) UIColor *disabledColor;
@property (strong, nonatomic) UIColor *enabledColor;

@end

@implementation SignUpViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];

    // --------------------------------------------------------------------
    // TextField Setup
    // --------------------------------------------------------------------
    self.emailTextField.delegate    = self;
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.emailTextField.tag         = 1;
    self.usernameTextField.tag      = 2;
    self.passwordTextField.tag      = 3;
    [self.emailTextField addTarget:self action:@selector(editingBeganOnTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.usernameTextField addTarget:self action:@selector(editingBeganOnTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(editingBeganOnTextField:) forControlEvents:UIControlEventEditingChanged];

    // --------------------------------------------------------------------
    // Setup Initial Button State
    // --------------------------------------------------------------------
    self.enabledColor = self.signUpButton.tintColor;
    self.disabledColor = [UIColor colorWithWhite:0.6 alpha:0.2];
    self.signUpButton.enabled = NO;
    [self.signUpButton setTitleColor:self.disabledColor forState:UIControlStateDisabled];
    [self.signUpButton setTitleColor:self.enabledColor forState:UIControlStateNormal];
}

#pragma mark - Text Field Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 1:
            return [textField.text isValidEmailAddress];
            break;
        case 2:
            return [textField.text isValidUsername];
            break;
        case 3:
            return [textField.text isValidPassword];
            break;

        default:
            break;
    }
    return YES;
}

#pragma mark - Helper Methods
- (void) updateUI {
    self.signUpButton.enabled = ([self.emailTextField.text isValidEmailAddress] &&
                                 [self.passwordTextField.text isValidPassword]  &&
                                 [self.usernameTextField.text isValidUsername]);
}

#pragma mark - IBAction Methods
- (IBAction)editingBeganOnTextField:(UITextField *)textField {
    [self updateUI];
}

- (IBAction)onSignUpButtonPressed:(UIButton *)sender {

    [self.spinner startAnimating];

    SuperUser *user = [SuperUser new];

    user.username = self.usernameTextField.text;
    user.password = self.passwordTextField.text;
    user.email    = self.emailTextField.text;

    __block NSString *alertTitle = @"";
    __block NSString *alertMessage = @"";

    __weak SignUpViewController *weakSelf = self;
    if ([NSString isValidEmailAddress:self.emailTextField.text]) {
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
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     if (!error) {
                                                                         [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                                     }
                                                                 }];
                [alert addAction:okButton];

                [weakSelf presentViewController:alert animated:YES completion:nil];
            });


        }];

    } else {
        NSLog(@"%@ is not a valid email address", self.emailTextField.text);
    }
}


@end