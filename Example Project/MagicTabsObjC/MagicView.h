//
//  MagicView.h
//  MagicTabsObjC
//
//  Created by Cyril Savitsky on 11/22/12.
//  Copyright (c) 2012 Synobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kSpacer 50

@interface MagicView : UIView <UIGestureRecognizerDelegate> {
    
    BOOL mainView;
    
    UINavigationBar *navigationBarView;
    UIView *contentView;
    CGRect contentViewFirstPosition;

}

@property (readwrite, nonatomic) NSInteger zIndex;
@property (readonly, nonatomic) CGRect firstPosition;

- (void) setViewTitle:(NSString *)title;
- (void) setContentView:(UIView *)newContentView;

@end
