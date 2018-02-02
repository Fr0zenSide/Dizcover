//
//  DZRArtistCollectionViewCell.h
//  DeezerExercice
//  Copyright (c) 2015 Deezer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemImageView.h"

@interface DZRArtistCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet ItemImageView *artistImage;
@property (weak, nonatomic) IBOutlet UILabel *artistName;

@end
