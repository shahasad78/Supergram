//
//  LoginViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/22/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "LoginViewController.h"
#import "SuperProfileViewController.h"
#import "SuperUser.h"
#import <Parse/Parse.h>

@interface LoginViewController () <UITextFieldDelegate>

// IBOutlet properties
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

// UI Control State properties
@property (strong, nonatomic) UIColor *disabledColor;
@property (strong, nonatomic) UIColor *enabledColor;

@end

@implementation LoginViewController

#pragma mark - View LifeCycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];

    // --------------------------------------------------------------------
    // Setup Text Fields
    // --------------------------------------------------------------------
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.usernameTextField.tag      = 1;
    self.passwordTextField.tag      = 2;
    [self.passwordTextField addTarget:self action:@selector(editingBeganOnTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.usernameTextField addTarget:self action:@selector(editingBeganOnTextField:) forControlEvents:UIControlEventEditingChanged];


    // --------------------------------------------------------------------
    // Setup Initial Button State
    // --------------------------------------------------------------------
    self.enabledColor = self.loginButton.tintColor;
    self.disabledColor = [UIColor colorWithWhite:0.6 alpha:0.2];
    self.loginButton.enabled = NO;
    [self.loginButton setTitleColor:self.disabledColor forState:UIControlStateDisabled];
    [self.loginButton setTitleColor:self.enabledColor forState:UIControlStateNormal];
}

#pragma mark - Text Field Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return [self textFieldShouldUpdate:textField];
}

#pragma mark - Helper Methods
- (BOOL)textFieldShouldUpdate:(UITextField *)textField {
    [self updateUI];
    switch (textField.tag) {
        case 1:
            return [self.usernameTextField hasText];
            break;
        case 2:
            return [self isValidPassword:self.passwordTextField.text];
            break;

        default:
            break;
    }
    return YES;
}

- (void)updateUI {
    self.loginButton.enabled = ([self.usernameTextField hasText] && [self isValidPassword:self.passwordTextField.text]);
}

- (BOOL)isValidPassword:(NSString *)password {
    return ((password.length > 6) &&
            ([password rangeOfString:@" "].length == 0));
}

#pragma mark - IBAction Methods
- (IBAction)editingBeganOnTextField:(UITextField *)textField {
    [self updateUI];
}

- (IBAction)onLoginButtonPressed:(UIButton *)sender {
    [self.spinner startAnimating];

    // TODO: validate username, password & email

    __block NSString *alertTitle = @"";
    __block NSString *alertMessage = @"";

    __weak LoginViewController *weakSelf = self;

    [SuperUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {

        [self.spinner stopAnimating];

        // TODO present user friendly error description
        alertTitle   = (error) ? @"Error" : @"Success";
        alertMessage = (error) ? error.localizedDescription : @"Logged In";

        dispatch_async(dispatch_get_main_queue(), ^{

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle
                                                                           message:alertMessage
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Okay!"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {

                                                                 NSString * storyboardName = @"Main";
                                                                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                                                                 SuperProfileViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"Profile"];

                                                                 [weakSelf presentViewController:vc animated:YES completion:nil];
                                                             }];
            [alert addAction:okButton];
            
            [weakSelf presentViewController:alert animated:YES completion:nil];
            
        });
        
    }];
    
}

- (IBAction) unwindToLogin:(UIStoryboardSegue *)segue {
    
}
@end
