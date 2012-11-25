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
        navigationBarView = [[UIView alloc] initWithFrame:
                             CGRectMake(0, 0, [self frame].size.width, 44)];
        [navigationBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation_bar_texture.png"]]];
        [self addSubview:navigationBarView];
        
        viewTitle = [[UILabel alloc] initWithFrame:
                     CGRectMake(0, 0, [self frame].size.width, 44)];
        [viewTitle setCenter:CGPointMake([self frame].size.width * 0.5f, [navigationBarView frame].size.height * 0.5f)];
        [viewTitle setTextAlignment:NSTextAlignmentCenter];
        [viewTitle setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        [viewTitle setTextColor:[UIColor whiteColor]];
        [viewTitle setBackgroundColor:[UIColor clearColor]];
        [navigationBarView addSubview:viewTitle];
        
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
            //navFrame.origin.x = 0;
            [navigationBarView setFrame:navFrame];
            
            CGRect contentFrame = [contentView frame];
            contentFrame.size.width = _firstPosition.size.width;
            [contentView setFrame:contentFrame];
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
        [viewTitle setCenter:CGPointMake([self frame].size.width * 0.5f, [viewTitle center].y)];
        [navigationBarView setFrame:CGRectMake(0, 0, [self frame].size.width, 44)];
        
        CGRect newContentFrame = [contentView frame];
        newContentFrame.size.width = [self frame].size.width;
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
        
        [viewTitle setCenter:CGPointMake(newFrame.size.width * 0.5f, [viewTitle center].y)];
        [navigationBarView setFrame:CGRectMake(0, 0, newFrame.size.width, 44)];
        
        CGRect newContentFrame = [contentView frame];
        newContentFrame.size.width = newFrame.size.width;
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
    [viewTitle setText:title];
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
    [newContentView setFrame:CGRectMake(0, [navigationBarView frame].size.height, [self frame].size.width, [self frame].size.height - [navigationBarView frame].size.height)];
    contentView = newContentView;
    [self addSubview:contentView];
}

@end
