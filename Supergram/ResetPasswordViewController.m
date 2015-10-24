//
//  ResetPasswordViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/22/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import <Parse/Parse.h>

@interface ResetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onResetPasswordButtonpressed:(UIButton *)sender {

    // TODO: validate email
    [self.spinner startAnimating];
    [PFUser requestPasswordResetForEmailInBackground:self.emailTextField.text];
    
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
