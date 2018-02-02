//
//  UIView+Helpers.h
//  Helpers
//
//  Created by Jeoffrey Thirot on 04/11/13.
//  Copyright (c) 2013 Magency. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Helpers)

- (void) _animateProperties:(NSDictionary *)props withTime:(float)time afterDelay:(float)delay easing:(UIViewAnimationOptions)easing completion:(void (^)())viewcompletion;
- (void) animateView:(UIView *)view toX:(float)posX completion:(void (^)())viewcompletion addedView:(BOOL)added;
- (void) animateView:(UIView *)view toX:(float)posX completion:(void (^)())viewcompletion;

- (void) addAnimatedSubView:(UIView *)view properties:(NSDictionary *)props withTime:(float)time afterDelay:(float)delay easing:(UIViewAnimationOptions)easing completion:(void (^)())viewcompletion;
- (void) addAnimatedSubView:(UIView *)view properties:(NSDictionary *)props withTime:(float)time easing:(UIViewAnimationOptions)easing;
- (void) addAlphaAnimatedSubView:(UIView *)view;

- (UIViewController *) firstAvailableUIViewController;
- (id) traverseResponderChainForUIViewController;

@end
