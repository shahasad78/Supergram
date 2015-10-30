//
//  CollectionViewCell.h
//  Supergram
//
//  Created by Rumiya Murtazina on 10/28/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@class PostCollectionViewCell;
@class Post;
@protocol PostCollectionViewCellDelegate <NSObject>

@optional
- (void) didTappedCell:(PostCollectionViewCell *)cell;
- (void) didTappedMore:(PostCollectionViewCell *)cell;
- (void) didTappedShare:(PostCollectionViewCell *)cell;
- (void) didTappedComment:(PostCollectionViewCell *)cell;
- (void) didTappedReport:(PostCollectionViewCell *)cell;
- (void) didTappedDelete:(PostCollectionViewCell *)cell;
@end

@interface PostCollectionViewCell : UICollectionViewCell

@property Post *post;
@property (nonatomic, assign) id <PostCollectionViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *postView;
@property (weak, nonatomic) IBOutlet PFImageView *postImage;

@property (weak, nonatomic) IBOutlet UIImageView *dangerImage;
@property (weak, nonatomic) IBOutlet UIView *likeMoreView;
@property (weak, nonatomic) IBOutlet UIButton *heartButton;
@property (weak, nonatomic) IBOutlet UILabel *heartCount;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userPic;

@end
