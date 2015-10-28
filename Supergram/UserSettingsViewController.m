//
//  UserSettingsViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/23/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "UserSettingsViewController.h"
#import "LoginViewController.h"
#import "SuperUser.h"
#import <Parse/Parse.h>

@interface UserSettingsViewController()

@property (weak, nonatomic) IBOutlet UITextField *fullnameTextField;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *bioTextField;
@property (weak, nonatomic) IBOutlet UINavigationItem *viewTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

// Parse Data properties
@property SuperUser *userView;
//@property CGPoint originalCenter;

@end


@implementation UserSettingsViewController

#pragma mark - View Life Cycle Methods
- (void) viewDidLoad{
    [super viewDidLoad];

    [self setupUI];
}



- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupUI];
}

- (void) setupUI {
    self.userView = [SuperUser currentUser];
    self.usernameLabel.text = self.userView.username;
    self.emailLabel.text = self.userView.email;

    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:self.userView.username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFObject *foundUser = object;

        self.fullnameTextField.text = [NSString stringWithFormat:@"%@ %@", foundUser[@"firstName"] , foundUser[@"lastName"]];
        self.bioTextField.text = foundUser[kSuperUserAttributeKey.bio];
    }];
}

- (IBAction)onFullNamePressed:(UITextField *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Change Full Name" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField){
        textField.placeholder = @"First Name";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField){
        textField.placeholder = @"Last Name";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){

        UITextField *firstTextField = [[alertController textFields] firstObject];
        UITextField *lastTextField = [[alertController textFields] lastObject];

        [self.spinner startAnimating];

        [self.userView setObject:firstTextField.text forKey:@"firstName"];
        [self.userView setObject:lastTextField.text forKey:@"lastName"];

        [self.userView saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

            [self.spinner stopAnimating];

            if (error) {
                //handle error
            } else {
                self.fullnameTextField.text = [NSString stringWithFormat:@"%@ %@", firstTextField.text, lastTextField.text];
            }
        }];

    }];

    [alertController addAction:cancelAction];
    [alertController addAction:updateAction];

    [self presentViewController:alertController animated:true completion:nil];

}
- (IBAction)onBioTextFieldPressed:(UITextField *)sender {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Change Bio" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField){
        textField.placeholder = @"Bio";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){

        UITextField *firstTextField = [[alertController textFields] firstObject];

        [self.spinner startAnimating];

        [self.userView setObject:firstTextField.text forKey:@"bio"];

        [self.userView saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.spinner stopAnimating];

            if (error) {
                //handle error
            } else {
                self.bioTextField.text = firstTextField.text;
            }
        }];

    }];

    [alertController addAction:cancelAction];
    [alertController addAction:updateAction];

    [self presentViewController:alertController animated:true completion:nil];
}
- (IBAction)onResetPasswordPressed:(UIButton *)sender {
    [self.spinner startAnimating];
    [PFUser requestPasswordResetForEmailInBackground:self.userView.email];

    [self.spinner stopAnimating];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Password Reset"
                                                                   message:[NSString stringWithFormat:@"An email containing information on how to reset your password has been sent to %@.", self.userView.email]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Okay!"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okButton];

    [self presentViewController:alert animated:YES completion:nil];

}


- (IBAction)onLogOutButtonPressed:(UIButton *)sender {
    // Send a request to log out a user
    [SuperUser logOutInBackground];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        LoginViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
        [self presentViewController:vc animated:YES completion:nil];
    });
}

@end
