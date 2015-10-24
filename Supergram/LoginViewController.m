//
//  LoginViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/22/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "LoginViewController.h"
#import "SuperProfileViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onLoginButtonPressed:(UIButton *)sender {
    [self.spinner startAnimating];

    // TODO: validate username, password & email

    __block NSString *alertTitle = @"";
    __block NSString *alertMessage = @"";

    __weak LoginViewController *weakSelf = self;

    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {

        [self.spinner stopAnimating];

        // TODO present user friendly error description
        alertTitle = (error == nil) ? @"Success" :  @"Error";
        alertMessage = (error == nil) ? @"Logged In"  : error.description;

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
