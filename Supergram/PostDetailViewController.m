//
//  PostDetailViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/26/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "PostDetailViewController.h"
#import "Post.h"
#import "Comment.h"
#import "SuperUser.h"
#import "Activity.h"

@interface PostDetailViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


// Parse properties
@property (strong, nonatomic) NSMutableArray *comments;
@end

@implementation PostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.postImage.file = self.post.media;
    self.commentCountLabel.text = [@(self.post.commentCount) stringValue];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    __weak PostDetailViewController *weakSelf = self;

    PFQuery *commentQuery = [PFQuery queryWithClassName:kCommentClass];
    [commentQuery whereKey:kCommentAttributeKey.parent equalTo:self.post];
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        weakSelf.comments = objects.mutableCopy;

        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"cell comments = %@", weakSelf.comments);
            [self setupUI];
            [weakSelf.tableView reloadData];
        });
    }];

}

#pragma mark - Helper Methods
- (void) setupUI {
    self.commentCountLabel.text = [@(self.comments.count) stringValue];
}

- (IBAction)onAddButtonPressed:(UIButton *)sender {
    [self presentCommentDialogBox];
}

- (void)presentCommentDialogBox {
    UIAlertController *commentBox = [UIAlertController alertControllerWithTitle:@"Add Comment"
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];

    __weak PostDetailViewController *weakSelf = self;
    [commentBox addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = weakSelf;
    }];

    UIAlertAction *save = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        // Grab the text from the comment field and populate a new Comment object
        UITextField *commentField = [commentBox.textFields firstObject];
        [weakSelf.comments addObject:commentField.text];
        Comment *newComment = [Comment object];
        newComment.content = commentField.text;
        newComment.parent = weakSelf.post;
        [newComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [weakSelf setupUI];
            [weakSelf.post.comments addObject:newComment];
            [weakSelf.post incrementKey:kPostAttributeKey.commentCount];
            [weakSelf.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {


            }];
            // Save new Activity
            Activity *activity  = [Activity object];
            activity.toUser     = weakSelf.post.author;
            activity.fromUser   = [SuperUser currentUser];
            activity.post       = weakSelf.post;
            activity.activityType = kActivityType.comment;
            [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                }
            }];

        }];


        // Save new Activity
        Activity *activity  = [Activity object];
        activity.toUser     = weakSelf.post.author;
        activity.fromUser   = [SuperUser currentUser];
        activity.post       = weakSelf.post;
        activity.activityType = kActivityType.comment;
        [activity saveInBackground];

        NSLog(@"cell comments = %@", self.comments);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [commentBox addAction:cancel];
    [commentBox addAction:save];

    [self presentViewController:commentBox animated:YES completion:nil];
}

#pragma mark - Text Field Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

#pragma mark - Table View Delegate Methods

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Comment *comment = self.comments[indexPath.row];
    cell.textLabel.text = comment.content;
    return cell;
}

@end
