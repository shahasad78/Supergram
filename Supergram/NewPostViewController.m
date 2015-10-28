//
//  NewPostViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/25/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "NewPostViewController.h"
#import "Post.h"
#import "SuperUser.h"
#import "Activity.h"

@interface NewPostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// IBOutlet Properties
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

// Image properties
@property UIImagePickerController *picker;
@property UIImage *chosenImage;

// Parse objects
@property Activity *activity;
@property SuperUser *user;

@end

@implementation NewPostViewController

#pragma mark - View Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];

    // Grab current user
    self.user = [SuperUser currentUser];

    // Initialize ImagePicker Controller
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;

    self.imageView.image = [UIImage imageNamed:@"default_placeholder"];

}


#pragma mark - Helper Methods
- (void)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message andButtonName:(NSString *)buttonName{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:buttonName
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okButton];

    [self presentViewController:alert animated:YES completion:NULL];
    
}

#pragma mark - IBAction Methods
- (IBAction)onCameraButtonClicked:(UIButton *)sender {

    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:self.picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(UIButton *)sender {

    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:self.picker animated:YES completion:NULL];


}

#pragma mark - ImagePicker Controller Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    self.chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = self.chosenImage;

    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)onSaveButtonPressed:(UIBarButtonItem *)sender {

    if (self.chosenImage != nil) {
        NSData *imageData = UIImageJPEGRepresentation(self.chosenImage, 0.0);

        PFFile *imageFile = [PFFile fileWithData:imageData];
//        SuperUser *user = [SuperUser currentUser];

        Post *post = [Post objectWithClassName:@"Post"];
        post.media = imageFile;
        post.author = self.user;

        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {

                [self presentAlertControllerWithTitle:@"Error" message:@"Unable to save image" andButtonName:@"Okay!"];

            } else {

                if (succeeded) {
                    
                    [self.user incrementKey:kSuperUserAttributeKey.postCount];
                    [self.user saveInBackground];
                    self.imageView.image = [UIImage imageNamed:@"default_placeholder"];

                    // Save New Activity
                    self.activity = [Activity object];
                    self.activity[kActivityKey.fromUser]    = self.user;
                    self.activity[kActivityKey.toUser]      = self.user;
                    self.activity[kActivityKey.type]        = kActivityType.post;
                    self.activity[kActivityKey.post]        = post;

                    [self.activity saveInBackground];
                    
                    [self performSegueWithIdentifier:@"ExitToUserProfile" sender:self];
                }

            }
            
            
        }];

    } else {

        [self presentAlertControllerWithTitle:@"Error" message:@"Please select a photo" andButtonName:@"Okay!"];

    }
    
    
}


@end
