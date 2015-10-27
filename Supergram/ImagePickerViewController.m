//
//  ImagePickerViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/23/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "ImagePickerViewController.h"
//#import <AVFoundation/AVFoundation.h>
//#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface ImagePickerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property UIImagePickerController *picker;
@property UIImage *chosenImage;
@end
@implementation ImagePickerViewController

- (void) viewDidLoad{
    [super viewDidLoad];

    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;

    PFUser *user = [PFUser currentUser];
    if (user[@"profilePic"]) {
        self.imageView.file = user[@"profilePic"];

        [self.imageView loadInBackground];
    }


    // if camera is not available
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Device has no camera"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Okay!"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alert addAction:okButton];

        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (IBAction)onCameraButtonClicked:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(UIButton *)sender {

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:picker animated:YES completion:NULL];


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
                    PFUser *user = [PFUser currentUser];
                    //user[@"profilePic"] = imageFile;
                    [user setObject:imageFile forKey:@"profilePic"];
                    [user saveInBackground];
                }
            } else {
                // Handle error
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                               message:@"Unable to save an error."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Okay!"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];
                [alert addAction:okButton];

                [self presentViewController:alert animated:YES completion:nil];
            }        
        }];

        // Execute the unwind segue and go back to the user profile screen

        [self dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"unwindToProfile" sender:self];

    } else {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Please select a photo."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Okay!"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alert addAction:okButton];

        [self presentViewController:alert animated:YES completion:nil];

    }


}


@end
