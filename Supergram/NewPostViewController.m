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
#import "SuperUser.h"

@interface NewPostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property UIImagePickerController *picker;
@property UIImage *chosenImage;
@end

@implementation NewPostViewController

#pragma mark - View Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;

    self.imageView.image = [UIImage imageNamed:@"default_placeholder"];
   // self.imageView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.width);

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
        SuperUser *user = [SuperUser currentUser];

        Post *post = [Post objectWithClassName:@"Post"];
        post.media = imageFile;
        post.author = user;

        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {

                [self presentAlertControllerWithTitle:@"Error" message:@"Unable to save image" andButtonName:@"Okay!"];

            } else {

                if (succeeded) {

                    [user incrementKey:kSuperUserAttributeKey.postCount];
                    [user saveInBackground];
                    self.imageView.image = [UIImage imageNamed:@"default_placeholder"];
                    [self performSegueWithIdentifier:@"ExitToUserProfile" sender:self];
                }

            }
            
            
        }];

    } else {

        [self presentAlertControllerWithTitle:@"Error" message:@"Please select a photo" andButtonName:@"Okay!"];

    }
    
    
}


@end
