//
//  ItemImageView.h
//  RenaultDemo
//
//  Created by Jeoffrey Thirot on 13/02/2015.
//  Copyright (c) 2015 Magency. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ItemImageView : UIView

@property (nonatomic, strong) UIImageView *placeholder;
@property (nonatomic, strong) UIImageView *picture;
@property (nonatomic, strong) UIColor *colorProgress;
@property (nonatomic, assign) float progressWidth;
@property (nonatomic, strong) NSMutableDictionary *userInfo;

- (id) initWithFrame:(CGRect)frame andPlaceholder:(UIImage *)placeholder;
- (id) initWithFrame:(CGRect)frame andPlaceholder:(UIImage *)placeholder isCircular:(BOOL)isCircular;
- (id) initWithFrame:(CGRect)frame andImagePath:(NSString *)imagePath andPlaceholder:(UIImage *)placeholder isCircular:(BOOL)isCircular;
- (id) initWithFrame:(CGRect)frame andImage:(UIImage *)image andPlaceholder:(UIImage *)placeholder;
- (id) initWithFrame:(CGRect)frame andImage:(UIImage *)image andPlaceholder:(UIImage *)placeholder isCircular:(BOOL)isCircular;

- (void) setPictureForPath:(NSString *)imagePath;
- (void) setPlaceholderForPath:(NSString *)placeholderPath;
- (void) showPicture;
- (void) hidePicture;
- (void) showPlaceholder;
- (void) hidePlaceholder;

- (void) changeProgress;
- (void) showProgress;
- (void) inProgress:(float)progress;
- (void) hideProgress;

- (void) prepareForReuseItem;
- (BOOL) isWaitingBeforeDisplay;

@end
