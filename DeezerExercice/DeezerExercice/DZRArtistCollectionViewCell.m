//
//  DZRArtistCollectionViewCell.m
//  DeezerExercice
//  Copyright (c) 2015 Deezer. All rights reserved.
//

#import "DZRArtistCollectionViewCell.h"

@implementation DZRArtistCollectionViewCell

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if( self ) {
        NSLog(@"Plooooooooooooooopppppp");
        [self.artistImage setPlaceholderForPath:@"no_cover.jpg"];
    }
    return self;
}

- (void) prepareForReuse {
    [super prepareForReuse];
    [self.artistImage prepareForReuseItem];
    self.artistName.text = @"";
}

@end
