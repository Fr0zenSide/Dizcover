//
//  ItemImageView.m
//  RenaultDemo
//
//  Created by Jeoffrey Thirot on 13/02/2015.
//  Copyright (c) 2015 Magency. All rights reserved.
//

#import "ItemImageView.h"
#import "UIView+Helpers.h"

#define rad(degrees) ((degrees) / (180.0 / M_PI))
#define kBorder 0. 
#define kProgressWidth 2.

@interface ItemImageView() {
    BOOL _isCircle;
    float _progress;
    UIView *_progressBar;
    CAShapeLayer *_circlebackgroundProgress;
    CAShapeLayer *_circleProgress;
    int cpt;
    BOOL _waitingBeforeDisplay;
    UIColor *_defaultColorProgress;
}

- (UIImageView *) _createImageView;
- (CAShapeLayer *) _createCircleMask;

- (CGRect) _getProgressLineFrame:(float)progress;
- (void) _showProgressLine;
- (void) _hideProgressLine;
- (void) _inProgressLine;

@end

@implementation ItemImageView

- (id) initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame andPlaceholder:nil];
    if( self ) {
        _defaultColorProgress = [UIColor colorWithRed:0.00 green:0.76 blue:1.00 alpha:1.0];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame andPlaceholder:(UIImage *)placeholder
{
    self = [self initWithFrame:frame andPlaceholder:placeholder isCircular:NO];
    if( self ) {
        
    }
    return self;
}


- (id) initWithFrame:(CGRect)frame andPlaceholder:(UIImage *)placeholder isCircular:(BOOL)isCircular
{
    self = [super initWithFrame:frame];
    if( self ) {
        self.userInfo = [NSMutableDictionary dictionary];
        _waitingBeforeDisplay = YES;
        _isCircle = isCircular;
        self.progressWidth = kProgressWidth;
        
        self.placeholder = [self _createImageView];
        if (placeholder) self.placeholder.image = placeholder;
        [self addSubview:self.placeholder];
        
        self.picture = [self _createImageView];
        [self addSubview:self.picture];
        
        
        if( _isCircle ) {
            self.placeholder.layer.mask = [self _createCircleMask];
            self.picture.layer.mask = [self _createCircleMask];
        }
        
//        cpt = 0;
//        [self changeProgress];
    }
    return self;
}


- (id) initWithFrame:(CGRect)frame andImagePath:(NSString *)imagePath andPlaceholder:(UIImage *)placeholder isCircular:(BOOL)isCircular
{
    self = [self initWithFrame:frame andImage:nil andPlaceholder:placeholder isCircular:isCircular];
    if( self ) {
        [self setPictureForPath:imagePath];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame andImage:(UIImage *)image andPlaceholder:(UIImage *)placeholder isCircular:(BOOL)isCircular
{
    self = [self initWithFrame:frame andPlaceholder:placeholder isCircular:isCircular];
    if( self ) {
        if( image ) self.picture.image = image;
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame andImage:(UIImage *)image andPlaceholder:(UIImage *)placeholder
{
    self = [self initWithFrame:frame andImage:image andPlaceholder:placeholder isCircular:NO];
    if( self ) {
        
    }
    return self;
}

- (void) prepareForReuseItem
{
    self.userInfo = nil;
    self.userInfo = [NSMutableDictionary dictionary];
    if( _progressBar ) {
        _progressBar.alpha = 0.;
        [_progressBar removeFromSuperview];
    }
    [self hidePicture];
    [self showPlaceholder];
}

- (void) changeProgress
{
    _progress += 0.05;
    
    [self inProgress:_progress];
    
    if( _progress >= 1) {
        cpt++;
        if( cpt <= 3 ) {
            _progress = 0.;
        } else {
            [self hideProgress];
            return;
        }
    }
    
    [self performSelector:@selector(changeProgress) withObject:nil afterDelay:0.1];
}

- (void) showProgress
{
    if( _isCircle )
    {
        [self _showProgressCircle];
    }
    else
    {
        [self _showProgressLine];
    }
}

- (void) hideProgress
{
    if( _isCircle )
    {
        [self _hideProgressCircle];
    }
    else
    {
        [self _hideProgressLine];
    }
}

- (void) inProgress:(float)progress
{
    _progress = progress;
    if( _isCircle )
    {
        [self _inProgressCircle];
    }
    else
    {
        [self _inProgressLine];
    }
}

#pragma mark - Getter and Setter

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.placeholder.frame = self.bounds;
    self.picture.frame = self.bounds;
    
    if( _isCircle ) {
        self.placeholder.layer.mask = [self _createCircleMask];
        self.picture.layer.mask = [self _createCircleMask];
        
        // update progressbar
        if( _circlebackgroundProgress && _circleProgress ) {
            UIBezierPath *path = [self _getCirclePath];
            _circlebackgroundProgress.path  = path.CGPath;
            _circleProgress.path            = path.CGPath;
        }
    } else {
        if( _progressBar ) {
            _progressBar.frame = [self _getProgressLineFrame:_progress];
        }
    }
}
/*
- (void) layoutSubviews
{
    [super layoutSubviews];
    
    _bg.frame = [self _bgFrame];
    _border.frame = [self _borderFrame];
    [self _drawCorner:((UIColor *)[_colors objectAtIndex:_indexColor]).CGColor];
    [self _drawArrow:Theme.gray.CGColor];
    
    self.proposition.frame = [self _propositionFrame];
    self.name.frame = [self _nameFrame];
    self.avatar.frame = [self _avatarFrame];
}
- (void) _drawCorner:(CGColorRef)color
{
    if( _corner ) {
        [_corner removeFromSuperlayer];
    }
    float margin = 1.;
    float width = CGRectGetHeight(_bg.frame) * .5 - margin;
    
    UIBezierPath *cornerPath = [UIBezierPath bezierPath];
    [cornerPath moveToPoint:CGPointZero];
    [cornerPath addLineToPoint:CGPointMake(width, 0.)];
    [cornerPath addLineToPoint:CGPointMake(width, width)];
    [cornerPath addLineToPoint:CGPointZero];
    
    
    _corner = [CAShapeLayer layer];
    _corner.path = cornerPath.CGPath;
    _corner.fillColor = color;
    
    
    CGRect cornerF = CGPathGetBoundingBox(cornerPath.CGPath);
    _corner.frame = CGRectMake(CGRectGetWidth(_bg.frame) - CGRectGetWidth(cornerF) - margin, margin, CGRectGetWidth(cornerF), CGRectGetHeight(cornerF));
    [_bg.layer addSublayer:_corner];
}
*/

#pragma mark - Method to manage progression of square image

- (CGRect) _getProgressLineFrame:(float)progress
{
    return CGRectMake(kBorder, self.bounds.size.height - kBorder - self.progressWidth, (self.bounds.size.width - (kBorder * 2)) * progress, self.progressWidth);
}

- (void) _showProgressLine
{
    CGRect f = [self _getProgressLineFrame:0.];
    if( !_progressBar ) {
        _progressBar = [[UIView alloc] initWithFrame:f];
    }
    if( !self.colorProgress ) self.colorProgress = _defaultColorProgress;
    _progressBar.backgroundColor = self.colorProgress;
    _progressBar.alpha = 0.;
    [self insertSubview:_progressBar belowSubview:self.picture];
    [_progressBar _animateProperties:@{@"alpha": @(1.)} withTime:0.3 afterDelay:0. easing:UIViewAnimationOptionCurveEaseOut completion:^{
        
    }];
}

- (void) _hideProgressLine
{
    if( !_progressBar ) return;
    [_progressBar _animateProperties:@{@"alpha": @(0.)} withTime:0.3 afterDelay:0. easing:UIViewAnimationOptionCurveEaseOut completion:^{
        [_progressBar removeFromSuperview];
        _progressBar = nil;
    }];
}

- (void) _inProgressLine
{
    if( !_progressBar || _progressBar.alpha == 0. ) [self _showProgressLine];
    _progressBar.frame = [self _getProgressLineFrame:_progress];
//    NSLog(@"frame : %@   != %@", NSStringFromCGRect(_progressBar.frame), NSStringFromCGRect(self.bounds));
}

#pragma mark - Method to manage progression of square image

- (UIBezierPath *) _getCirclePath
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                        radius:MIN(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                    startAngle:-rad(90)
                                                      endAngle:rad(360-90)
                                                     clockwise:YES];
    return path;
}

- (void) _showProgressCircle
{
    if( !_circlebackgroundProgress ) {
        UIBezierPath *circlePath = [self _getCirclePath];
        
        _circlebackgroundProgress = [CAShapeLayer layer];
        _circlebackgroundProgress.path           = circlePath.CGPath;
        _circlebackgroundProgress.strokeColor    = [UIColor whiteColor].CGColor;
        _circlebackgroundProgress.fillColor      = [UIColor clearColor].CGColor;
        _circlebackgroundProgress.lineWidth      = self.progressWidth;
        
        
        _circleProgress = [CAShapeLayer layer];
        _circleProgress.path             = circlePath.CGPath;
//        _circleProgress.strokeColor      = self.colorProgress.CGColor;
        _circleProgress.fillColor        = [UIColor clearColor].CGColor;
        _circleProgress.lineWidth        = self.progressWidth;
        _circleProgress.strokeEnd        = 0.;
        
        [self.placeholder.layer addSublayer:_circlebackgroundProgress];
        [self.placeholder.layer addSublayer:_circleProgress];
    }
    
    if( !self.colorProgress ) self.colorProgress = _defaultColorProgress;
    _circleProgress.strokeColor = self.colorProgress.CGColor;
}

- (void) _hideProgressCircle
{
    if( !_circlebackgroundProgress ) return;
    _circlebackgroundProgress.strokeStart = 0.;
    
    CABasicAnimation *progressAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    progressAnim.duration = .4;
    progressAnim.beginTime = CACurrentMediaTime() + .1;
    progressAnim.removedOnCompletion = NO;
    progressAnim.fillMode = kCAFillModeForwards;
    progressAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    progressAnim.fromValue = @(_circleProgress.opacity);
    progressAnim.toValue = @(0.);
    [_circleProgress addAnimation:progressAnim forKey:progressAnim.keyPath];
}

- (void) _inProgressCircle
{
    if( !_circlebackgroundProgress || _circlebackgroundProgress.opacity == 0. ) [self _showProgressCircle];
    
    CABasicAnimation *progressAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    progressAnim.duration = .1;
    progressAnim.removedOnCompletion = NO;
    progressAnim.fillMode = kCAFillModeForwards;
    
    
    progressAnim.fromValue = [NSNumber numberWithFloat:_circleProgress.strokeEnd];
    progressAnim.toValue = [NSNumber numberWithFloat:_progress];
    _circleProgress.strokeEnd = _progress;
    [_circleProgress addAnimation:progressAnim forKey:progressAnim.keyPath];
    
    
    
    CABasicAnimation *bgAnim = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    bgAnim.duration = .1;
    bgAnim.removedOnCompletion = NO;
    bgAnim.fillMode = kCAFillModeForwards;
    
    
    bgAnim.fromValue = [NSNumber numberWithFloat:_circlebackgroundProgress.strokeStart];
    bgAnim.toValue = [NSNumber numberWithFloat:_progress];
    _circlebackgroundProgress.strokeStart = _progress;
    [_circlebackgroundProgress addAnimation:bgAnim forKey:bgAnim.keyPath];
}

#pragma mark - Method util to init image

- (UIImageView *) _createImageView
{
    UIImageView *picture = [[UIImageView alloc] initWithFrame:self.bounds];
    picture.contentMode = UIViewContentModeScaleAspectFill;
    picture.clipsToBounds = YES;
    return picture;
}

- (CAShapeLayer *) _createCircleMask
{
    CAShapeLayer *circle = [CAShapeLayer layer];
    CGRect f = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    UIBezierPath *circularPath = [UIBezierPath bezierPathWithRoundedRect:f cornerRadius:MAX(self.bounds.size.width, self.bounds.size.height)];
    circle.path = circularPath.CGPath;
    // Configure the apperence of the circle
    circle.fillColor = [UIColor blackColor].CGColor;
    circle.strokeColor = [UIColor blackColor].CGColor;
    circle.lineWidth = 0;
    return circle;
}

- (void) showPicture
{
    _waitingBeforeDisplay = NO;
    self.picture.alpha = 0.;
    self.picture.hidden = NO;
    [self.picture.layer removeAllAnimations];
    [UIView animateWithDuration:.3 delay:.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.picture.alpha = 1.;
    } completion:^(BOOL finished) {
        [self hideProgress];
        // Hide placeholder
        [self hidePlaceholder];
    }];
}

- (void) hidePicture
{
    _waitingBeforeDisplay = YES;
    self.picture.hidden = YES;
}

- (void) showPlaceholder
{
    self.placeholder.hidden = NO;
}

- (void) hidePlaceholder
{
    self.placeholder.hidden = YES;
}

- (void) setPictureForPath:(NSString *)imagePath
{
    if( !self.picture ) return;
    
    if (imagePath && [[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        self.picture.image = [UIImage imageWithContentsOfFile:imagePath];
    }
}

- (void) setPlaceholderForPath:(NSString *)placeholderPath
{
    if( !self.placeholder ) return;
    
    if (placeholderPath && [[NSFileManager defaultManager] fileExistsAtPath:placeholderPath]) {
        self.placeholder.image = [UIImage imageWithContentsOfFile:placeholderPath];
    }
}

- (BOOL) isWaitingBeforeDisplay
{
    return _waitingBeforeDisplay;
}

@end
