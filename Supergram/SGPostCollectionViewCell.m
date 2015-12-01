//
//  SGPostCollectionViewCell.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/26/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "SGPostCollectionViewCell.h"


@implementation SGPostCollectionViewCell

- (void)awakeFromNib {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap)];
    gesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:gesture];

    UISwipeGestureRecognizer* rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipe];

    // Setup a left swipe gesture recognizer
    UISwipeGestureRecognizer* leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipe];
}

- (void) onDoubleTap {
}

- (void) swipeRight{
    NSLog(@"swiped right");
    
}

- (void) swipeLeft{
    NSLog(@"swiped left");

}

- (IBAction)onHeartButtonPressed:(UIButton *)sender {

    [self.delegate didTappedCell:self];
}
- (IBAction)onMoreButtonPressed:(UIButton *)sender {
    [self.delegate didTappedMore:self];
}
- (IBAction)onCloseMVButtonPressed:(UIButton *)sender {

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

    // hide like more view
    self.likeMoreView.hidden = YES;

    [self.delegate didTappedReport:self];
}

@end
