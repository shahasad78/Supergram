//
//  ResetPasswordViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/22/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "SuperUser.h"
#import "NSString+ValidationUtility.h"
#import <Parse/Parse.h>

@interface ResetPasswordViewController () <UITextFieldDelegate>

// IBOutlet properties
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

// UI Control State properties
@property (strong, nonatomic) UIColor *enabledColor;
@property (strong, nonatomic) UIColor *disabledColor;

@end

@implementation ResetPasswordViewController

#pragma mark - View Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];

    // --------------------------------------------------------------------
    // Setup Text Fields
    // --------------------------------------------------------------------
    self.emailTextField.delegate = self;
    [self.emailTextField addTarget:self action:@selector(editingBeganOnTextField:) forControlEvents:UIControlEventEditingChanged];

    // --------------------------------------------------------------------
    // Setup Initial Button State
    // --------------------------------------------------------------------
    self.enabledColor   = self.resetButton.tintColor;
    self.disabledColor  = [UIColor colorWithWhite:0.6 alpha:0.2];
    self.resetButton.enabled = NO;
    [self.resetButton setTitleColor:self.disabledColor forState:UIControlStateDisabled];
    [self.resetButton setTitleColor:self.enabledColor forState:UIControlStateNormal];
}

#pragma mark - Text Field delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Helper Methods

- (void)updateUI {
    self.resetButton.enabled = ([self.emailTextField.text isValidEmailAddress]);
}

#pragma mark - IBAction Methods
- (IBAction)editingBeganOnTextField:(UITextField *)textField {
    [self updateUI];
}

- (IBAction)onResetPasswordButtonpressed:(UIButton *)sender {

    // TODO: validate email
    [self.spinner startAnimating];
    [SuperUser requestPasswordResetForEmailInBackground:self.emailTextField.text];
    
    [self.spinner stopAnimating];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Password Reset"
                                                                   message:[NSString stringWithFormat:@"An email containing information on how to reset your password has been sent to %@.", self.emailTextField.text]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Okay!"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okButton];

    [self presentViewController:alert animated:YES completion:nil];
}

@end
