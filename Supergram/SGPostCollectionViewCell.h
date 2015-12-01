//
//  SGPostCollectionViewCell.h
//  Supergram
//
//  Created by Rumiya Murtazina on 10/26/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "Post.h"

@class SGPostCollectionViewCell;
@class Post;
@protocol SGPostCollectionViewCellDelegate <NSObject>

@optional
- (void) didTappedCell:(SGPostCollectionViewCell *)cell;
- (void) didTappedMore:(SGPostCollectionViewCell *)cell;
- (void) didTappedShare:(SGPostCollectionViewCell *)cell;
- (void) didTappedComment:(SGPostCollectionViewCell *)cell;
- (void) didTappedReport:(SGPostCollectionViewCell *)cell;
- (void) didTappedDelete:(SGPostCollectionViewCell *)cell;
@end

@interface SGPostCollectionViewCell : UICollectionViewCell
@property Post *post;
@property (nonatomic, assign) id <SGPostCollectionViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *postView;
@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@property (weak, nonatomic) IBOutlet UIImageView *dangerImage;

@property (weak, nonatomic) IBOutlet UIButton *heartButton;
@property (weak, nonatomic) IBOutlet UILabel *heartCount;



@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIView *likeMoreView;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIView *profileView;


@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userPic;

@end
