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
    
    UIView *navigationBarView;
    UILabel *viewTitle;
    UIView *contentView;

}

@property (readwrite, nonatomic) NSInteger zIndex;
@property (readonly, nonatomic) CGRect firstPosition;

@end
