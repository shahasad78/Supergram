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

@property (strong, nonatomic) UIAlertController *commentDialogBox;

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

- (void)presentCommentDialogBox {
    self.commentDialogBox = [UIAlertController alertControllerWithTitle:@"Add Comment"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];

    __weak PostDetailViewController *weakSelf = self;
    __weak UIAlertController *weakCommentDialog = self.commentDialogBox;

    UIAlertAction *save = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        action.enabled = NO;

        // Grab the text from the comment field and populate a new Comment object
        UITextField *commentField = [weakSelf.commentDialogBox.textFields firstObject];
        Comment *newComment = [Comment object];
        newComment.content = commentField.text;
        [weakSelf.comments addObject:newComment];
        newComment.parent = weakSelf.post;
        
        [newComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [weakSelf updateComments:newComment];
        }];

    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [self.commentDialogBox addAction:cancel];
    [self.commentDialogBox addAction:save];

    [self.commentDialogBox addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter new comment";
        textField.delegate = weakSelf;
        [textField addTarget:weakSelf action:@selector(setEnabled:) forControlEvents:UIControlEventEditingChanged];

        weakCommentDialog.actions[1].enabled = NO;
    }];

    
    [self presentViewController:self.commentDialogBox animated:YES completion:nil];
}

- (void)updateComments:(Comment *)newComment {
    PFRelation *relation = [self.post relationForKey:kPostAttributeKey.comments];
    [relation addObject:newComment];
    [self.post incrementKey:kPostAttributeKey.commentCount];
    [self.post saveInBackground];

    // Save new Activity
    Activity *activity  = [Activity object];
    activity.toUser     = self.post.author;
    activity.fromUser   = [SuperUser currentUser];
    activity.post       = self.post;
    activity.activityType = kActivityType.comment;
    [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];

    [self.tableView reloadData];
    [self setupUI];

}

#pragma mark - IBAction Methods
- (IBAction)onAddButtonPressed:(UIButton *)sender {
    [self presentCommentDialogBox];
}



#pragma mark - Text Field Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (void) setEnabled:(UITextField *)textField {
    self.commentDialogBox.actions[1].enabled = textField.hasText;
}

#pragma mark - Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Comment *comment = self.comments[indexPath.row];
    cell.textLabel.text = comment.content;
    return cell;
}

#pragma mark - Table View Delegate Methods
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Comment *commentToDelete = self.comments[indexPath.row];
        [commentToDelete deleteInBackground];
        [self.comments removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.commentCountLabel.text = [@(self.comments.count) stringValue];
    }
}


@end
