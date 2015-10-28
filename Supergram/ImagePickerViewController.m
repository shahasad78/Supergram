//
//  ImagePickerViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/23/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "ImagePickerViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "SuperUser.h"

@interface ImagePickerViewController () <UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

// IBOutlet properties
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property UIImagePickerController *picker;
@property UIImage *chosenImage;

@property (strong, nonatomic) SuperUser *user;

@end

@implementation ImagePickerViewController

#pragma mark - View Life Cycle Methods
- (void) viewDidLoad{
    [super viewDidLoad];

    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;

    self.user = [SuperUser currentUser];
    if (self.user[kSuperUserAttributeKey.profilePic]) {
        self.imageView.file = self.user[kSuperUserAttributeKey.profilePic];
        [self.imageView loadInBackground];
    }


    // if camera is not available
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self presentAlertControllerWithTitle:@"Error" message:@"Device has no camera" andButtonName:@"Okay!"];
    }
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
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                if (succeeded) {
                    self.user = [SuperUser currentUser];
                    [self.user setObject:imageFile forKey:kSuperUserAttributeKey.profilePic];
                    [self.user saveInBackground];
                }
            } else {
                // Handle error
                [self presentAlertControllerWithTitle:@"Error" message:@"Unable to save image" andButtonName:@"Okay!"];
            }
        }];

        // Execute the unwind segue and go back to the user profile screen

        [self dismissViewControllerAnimated:YES completion:nil];
//        [self performSegueWithIdentifier:@"unwindToProfile" sender:self];

    } else {

        [self presentAlertControllerWithTitle:@"Error" message:@"Please Select a photo" andButtonName:@"Okay!"];
        
    }
    
    
}


@end
