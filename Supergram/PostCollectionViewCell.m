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
    [self toggleHeartButton];
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
    [self toggleHeartButton];
    [self.delegate didTappedCell:self];
}

// change heart button image
- (void) toggleHeartButton{

    if (self.heartButton.selected) {
        [self.heartButton setSelected:NO];
    } else {
        [self.heartButton setSelected:YES];
    }

}

@synthesize postImage, heartButton;

@end
