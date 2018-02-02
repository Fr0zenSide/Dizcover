//
//  UIView+Helpers.m
//  Helpers
//
//  Created by Jeoffrey Thirot on 04/11/13.
//  Copyright (c) 2013 Magency. All rights reserved.
//

#import "UIView+Helpers.h"

@implementation UIView (Helpers)

#pragma mark - animation view

- (void) _animateProperties:(NSDictionary *)props withTime:(float)time afterDelay:(float)delay easing:(UIViewAnimationOptions)easing completion:(void (^)())viewcompletion
{
    NSArray *propsKey = [props allKeys];
    __block UIView *v = self;
    [UIView animateWithDuration:time delay:delay options:easing animations:^{
        SEL sel;
        NSString *propName;
        for (int i = 0; i < [propsKey count]; i++) {
            propName = [propsKey objectAtIndex:i];
            sel = NSSelectorFromString(propName);
            if( [v respondsToSelector:sel] ) {
                [v setValue:[props objectForKey:propName] forKey:propName];
            }
        }
    } completion:^(BOOL finished) {
        if( viewcompletion ) viewcompletion();
    }];
}

- (void) animateView:(UIView *)view toX:(float)posX completion:(void (^)())viewcompletion
{
    [self animateView:view toX:posX completion:viewcompletion addedView:NO];
}

- (void) animateView:(UIView *)view toX:(float)posX completion:(void (^)())viewcompletion addedView:(BOOL)added
{
    if( added ) {
        if( ![self.subviews containsObject:view] ) [self addSubview:view];
    }
    [UIView animateWithDuration:1.0
                     animations:^{
                         CGRect f = view.frame;
                         f.origin = CGPointMake(posX, f.origin.y);
                         view.frame = f;
//                         [view setX:posX];
                     }
                     completion:^(BOOL finished){
                         if( viewcompletion ) viewcompletion();
                     }];
}

- (void) addAnimatedSubView:(UIView *)view properties:(NSDictionary *)props withTime:(float)time afterDelay:(float)delay easing:(UIViewAnimationOptions)easing completion:(void (^)())viewcompletion
{
//    if( ![self.subviews containsObject:view] ) [self addSubview:view];
    [self addSubview:view];
    
    [view _animateProperties:props withTime:time afterDelay:delay easing:easing completion:viewcompletion];
}

- (void) addAnimatedSubView:(UIView *)view properties:(NSDictionary *)props withTime:(float)time easing:(UIViewAnimationOptions)easing
{
    [self addAnimatedSubView:view properties:props withTime:time afterDelay:.0 easing:easing completion:^{}];
}

- (void) addAlphaAnimatedSubView:(UIView *)view
{
    view.alpha = .0;
    [self addAnimatedSubView:view properties:@{@"alpha": @(1.)} withTime:.3 easing:UIViewAnimationOptionCurveEaseOut];
}

#pragma mark - find parent UIviewController

- (UIViewController *) firstAvailableUIViewController
{
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController
{
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

@end
