//
//  CollectionViewCell.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/28/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "PostCollectionViewCell.h"

@implementation PostCollectionViewCell
- (IBAction)onHeartButtonPressed:(UIButton *)sender {

    [self.delegate didTappedCell:self];
}
- (IBAction)onMoreButtonPressed:(UIButton *)sender {
    [self.delegate didTappedMore:self];
}

- (void)awakeFromNib {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap)];
    gesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:gesture];
}

- (void) onDoubleTap {

    [self.delegate didTappedCell:self];
}
- (IBAction)onCloseMVButtonPressed:(UIButton *)sender {
    self.moreView.hidden = YES;
}
- (IBAction)onShareButtonPressed:(UIButton *)sender {
    [self.delegate didTappedShare:self];
}
- (IBAction)onCommentButtonPressed:(UIButton *)sender {
    [self.delegate didTappedComment:self];
}
- (IBAction)onDeleteButtonPressed:(UIButton *)sender {
    [self.delegate didTappedDelete:self];
}

- (IBAction)onReportButtonPressed:(UIButton *)sender {
    // toggle "dangerous" image
    self.dangerImage.hidden = NO;

    // hide moreView view
    self.moreView.hidden = YES;

    // hide like more view
    self.likeMoreView.hidden = YES;
}

@synthesize postImage, heartButton;

@end
