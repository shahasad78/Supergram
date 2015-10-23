//
//  SignUpViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/22/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

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
}


@end
