//
//  NewPostViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/25/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "NewPostViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Post.h"

@interface NewPostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property UIImagePickerController *picker;
@property UIImage *chosenImage;
@end

@implementation NewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
   // self.imageView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.width);

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
        PFUser *user = [PFUser currentUser];
        PFObject *post = [PFObject objectWithClassName:@"Post"];
        [post setObject:imageFile forKey:@"media"];
        [post setObject:user forKey:@"author"];
        [post saveInBackground];

        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
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
        //[self performSegueWithIdentifier:@"unwindToProfile" sender:self];
        [self dismissViewControllerAnimated:YES completion:nil];

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
