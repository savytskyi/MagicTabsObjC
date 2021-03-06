//
//  MagicView.m
//  MagicTabsObjC
//
//  Created by Cyril Savitsky on 11/22/12.
//  Copyright (c) 2012 Synobi. All rights reserved.
//

#import "MagicView.h"

@implementation MagicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _firstPosition = frame;
        [self setClipsToBounds:YES];
        
        // it's a bit buggy&slow with quartzCore features now, so it was disabled for some time
        /*[[self layer] setShadowColor:[[UIColor blackColor] CGColor]];
        [[self layer] setShadowOffset:CGSizeMake(10, 10)];
        [[self layer] setShadowOpacity:0.5f];
        [[self layer] setShadowRadius:10.0f];
        */
        [[self layer] setBorderColor:[[UIColor blackColor] CGColor]];
        [[self layer] setBorderWidth:1.0f];
        
        [[self layer] setCornerRadius:3.0f];
        
        
        // setting up nav bar and view title
        navigationBarView = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        [navigationBarView setTintColor:[UIColor blackColor]];
        [self addSubview:navigationBarView];
        
        UINavigationItem *item = [[UINavigationItem alloc] init];
        [navigationBarView setItems:[NSArray arrayWithObject:item]];
        
        //setting up gesture
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [panGesture setMinimumNumberOfTouches:1];
        [navigationBarView addGestureRecognizer:panGesture];
        
        mainView = NO;
    }
    return self;
}

- (void) springBack {
    if ([self frame].origin.y == _firstPosition.origin.y &&
        [self frame].size.width == _firstPosition.size.width) return;
    
    [UIView animateWithDuration:0.2f animations:^(void) {
        [self setFrame:_firstPosition];
        if ([navigationBarView frame].size.width != _firstPosition.size.width) {
            CGRect navFrame = [navigationBarView frame];
            navFrame.size.width = _firstPosition.size.width;
            [navigationBarView setFrame:navFrame];
            
            [contentView setFrame:contentViewFirstPosition];
        }
        
    }];
    
    NSArray *magicViews = [self getMagicViewsFrom:[self superview]];
    for (MagicView *view in magicViews) {
        [view springBack];
    }
}

- (void) makeMainView {
    mainView = YES;
    [UIView animateWithDuration:0.2f animations:^(void) {
        [self setFrame:[[UIScreen mainScreen] bounds]];
        [navigationBarView setFrame:CGRectMake(0, 0, [self frame].size.width, 44)];
        
        CGRect newContentFrame = [contentView frame];
        
        CGFloat border = (_firstPosition.size.width - contentViewFirstPosition.size.width);
        newContentFrame.size.width = [self frame].size.width - border;
        [contentView setFrame:newContentFrame];
    } completion:^(BOOL finished) {
        [self hideOtherViews];
    }];
}

- (void) handlePanGesture:(UIPanGestureRecognizer *)gesture {
    int pointY = [gesture translationInView:[[self superview] superview]].y;
    if (pointY < 0 && mainView) return;
    
    
    CGRect newFrame = [self frame];
    newFrame.origin.y += pointY;
    
    if ([self frame].size.width > _firstPosition.size.width) {
        newFrame.size.width -= 2;
        newFrame.origin.x += 1;
        [navigationBarView setFrame:CGRectMake(0, 0, newFrame.size.width, 44)];
        
        CGRect newContentFrame = [contentView frame];
        newContentFrame.size.width -= 2;
        [contentView setFrame:newContentFrame];
    }
    
    [self setFrame:newFrame];
    
    if (pointY > 0 && mainView) mainView = NO;
    
    [self pushOtherViewsTo:pointY];
    
    [gesture setTranslation:CGPointMake(0, 0) inView:[[self superview] superview]];
    
    if ([gesture state] == UIGestureRecognizerStateCancelled ||
        [gesture state] == UIGestureRecognizerStateEnded ||
        [gesture state] == UIGestureRecognizerStateFailed) {
        
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        if ([self frame].origin.y < screenHeight / 3) {
            [self makeMainView];
        } else {
            [self springBack];
        }
    }
}

- (void) pushOtherViewsTo:(CGFloat)pointY {
    NSArray *magicViews = [self getMagicViewsFrom:[self superview]];
    
    for (MagicView *view in magicViews) {
        CGRect newFrame = [view frame];
        newFrame.origin.y += pointY;
        CGFloat diff = [view frame].origin.y - [self frame].origin.y;
        if (pointY > 0 && newFrame.origin.y >= [view firstPosition].origin.y &&
            diff <= kSpacer * ([view zIndex] - _zIndex)) {
            
            [view setFrame:newFrame];
        } else if (newFrame.origin.y >= [view firstPosition].origin.y && pointY < 0) {
            [view setFrame:newFrame];
        }
    }
}

- (void) hideOtherViews {
    NSArray *magicViews = [self getMagicViewsFrom:[self superview]];
    
    for (MagicView *view in magicViews) {
        [UIView animateWithDuration:0.2f animations:^{
            CGRect newFrame = [view frame];
            newFrame.origin.y = [[UIScreen mainScreen] bounds].size.height + (kSpacer * ([view zIndex] - _zIndex));
            [view setFrame:newFrame];
        }];
    }
}

- (void) setViewTitle:(NSString *)title {
    [[navigationBarView topItem] setTitle:title];
}

- (NSArray *) getMagicViewsFrom:(UIView *)parentView {
    NSMutableArray *magicViews = [[NSMutableArray alloc] init];
    for (MagicView *view in [parentView subviews]) {
        if ( [[view class] isSubclassOfClass:[MagicView class]] && [view zIndex] > _zIndex ) {
            [magicViews addObject:view];
        }
    }
    return magicViews;
}

- (void) setContentView:(UIView *)newContentView {
    CGRect newFrame = [newContentView frame];
    newFrame.origin.y += [navigationBarView frame].size.height;
    newFrame.size.height -= [navigationBarView frame].size.height;
    contentViewFirstPosition = newFrame;
    [newContentView setFrame:newFrame];
    contentView = newContentView;
    [self addSubview:contentView];
}

@end
