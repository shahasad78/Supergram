//
//  SGPostCollectionViewCell.h
//  Supergram
//
//  Created by Rumiya Murtazina on 10/26/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface SGPostCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *heartCount;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *dangerousImage;

@property (weak, nonatomic) IBOutlet UIButton *heartButton;
@property (weak, nonatomic) IBOutlet UIView *postPropertyContainer;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIView *moreOptionsView;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;

@property (weak, nonatomic) IBOutlet UIButton *onHeartButtonPressed;

@property (weak, nonatomic) IBOutlet UIButton *onMoreButtonPressed;
@property (weak, nonatomic) IBOutlet UIButton *onShareButtonPressed;
@property (weak, nonatomic) IBOutlet UIButton *onCommentButtonPressed;
@property (weak, nonatomic) IBOutlet UIButton *onReportButtonPressed;
@property (weak, nonatomic) IBOutlet UIButton *onDeleteButtonPressed;

@end
