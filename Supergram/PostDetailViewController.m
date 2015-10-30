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
    PFRelation *relation = [self.post relationForKey:kPostAttributeKey.comments];
    PFQuery *commentsQuery = [relation query];
    [commentsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        weakSelf.comments = objects.mutableCopy;

        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"cell comments = %@", weakSelf.comments);
            [weakSelf.tableView reloadData];
        });
    }];


//    PFQuery *commentQuery = [PFQuery queryWithClassName:kPostClass];
//    [commentQuery includeKey:kPostAttributeKey.comments];
//    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        self.comments = objects.mutableCopy;
//        NSLog(@"cell comments = %@", self.comments);
//        [weakSelf.tableView reloadData];
//    }];
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
        UITextField *commentField = [commentBox.textFields firstObject];
        [weakSelf.comments addObject:commentField.text];
        [weakSelf.post incrementKey:kPostAttributeKey.commentCount];
        Comment *newComment = [Comment object];
        newComment.content  = commentField.text;
        newComment.parent   = weakSelf.post;
        [weakSelf.post.comments addObject:newComment];
        [weakSelf.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [newComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
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

    cell.textLabel.text = self.comments[indexPath.row];
    return cell;
}

@end
