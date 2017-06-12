//
//  TBKeyboardToolbar.m
//
//  Created by Rudd Fawcett on 12/3/13.
//  Copyright (c) 2013 Rudd Fawcett. All rights reserved.
//

#import "TBKeyboardToolbar.h"

#define kToolbarHeight 44


@interface TBKeyboardToolbar ()

/// The fake top border to replicate the toolbar.
@property (nonatomic) CALayer      *topBorder;
@property (nonatomic) UIView       *toolbarView;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIVisualEffectView *blurView;
@end

@implementation TBKeyboardToolbar

+ (instancetype)toolbarWithButtons:(NSArray *)buttons {
    return [[self alloc] initWithButtons:buttons];
}

- (id)initWithButtons:(NSArray *)buttons {
    self = [super initWithFrame:CGRectMake(0, 0, self.window.rootViewController.view.bounds.size.width, kToolbarHeight)];
    if (self) {
        _buttons = [buttons copy];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.appearance = UIKeyboardAppearanceLight;
    }
    
    return self;
}

- (void)setAppearance:(UIKeyboardAppearance)appearance {
    _appearance = appearance;
    
    if (self.toolbarView) {
        [self.toolbarView removeFromSuperview];
    }
    
    [self addSubview:self.inputAccessoryView];
}

- (void)layoutSubviews {
    CGRect frame = _toolbarView.bounds;
    frame.size.height = 0.5f;
    
    _topBorder.frame = frame;
}

- (UIView *)inputAccessoryView {
    _topBorder       = [CALayer layer];
    _topBorder.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width, 0.5f);
    
    switch (_appearance) {
        case UIKeyboardAppearanceDefault:
        case UIKeyboardAppearanceLight: {
            _toolbarView = [UIView new];
            _toolbarView.backgroundColor = [UIColor colorWithRed:0.799 green:0.814 blue:0.847 alpha:1.000];
            _topBorder.backgroundColor   = [UIColor clearColor].CGColor;
            [_toolbarView.layer addSublayer:_topBorder];
            [_toolbarView addSubview:[self fakeToolbar]];
            break;
        }
        case UIKeyboardAppearanceDark: {
            UIVisualEffect *darkBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            _blurView = [[UIVisualEffectView alloc] initWithEffect:darkBlur];
            _toolbarView = _blurView;
            _topBorder.backgroundColor = [UIColor colorWithWhite:0.100 alpha:1.000].CGColor;
            [_blurView.contentView.layer addSublayer:_topBorder];
            [_blurView.contentView addSubview:[self fakeToolbar]];
            break;
        }
    }
    
    _toolbarView.frame = CGRectMake(0, 0, self.bounds.size.width, kToolbarHeight);
    _toolbarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    return _toolbarView;
}

- (UIScrollView *)fakeToolbar {
    _scrollView                  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kToolbarHeight)];
    _scrollView.backgroundColor  = [UIColor clearColor];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.contentInset     = UIEdgeInsetsMake(8.0f, 0.0f, 4.0f, 6.0f);
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    [self addButtons];
    
    return _scrollView;
}

- (void)addButtons {
    NSUInteger spacing = 6;
    NSUInteger originX = spacing;
    
    CGRect originFrame;
    CGFloat top    = _scrollView.contentInset.top;
    CGFloat bottom = _scrollView.contentInset.bottom;
    
    for (TBToolbarButton *button in _buttons) {
        button.appearance = self.appearance;
        
        originFrame             = button.frame;
        originFrame.origin.x    = originX;
        originFrame.origin.y    = 0;
        originFrame.size.height = kToolbarHeight - (top + bottom);
        button.frame            = originFrame;
        
        [_scrollView addSubview:button];
        
        originX += button.bounds.size.width + spacing;
    }
    
    CGSize contentSize = _scrollView.contentSize;
    contentSize.width  = originX - spacing;
    _scrollView.contentSize = contentSize;
}

- (void)setButtons:(NSArray *)buttons {
    [_buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _buttons = buttons.copy;
    
    [self addButtons];
}

- (void)setButtons:(NSArray *)buttons animated:(BOOL)animated {
    if (!animated) {
        self.buttons = buttons;
        return;
    }
    
    NSMutableSet *buttonstoRemove = [NSMutableSet setWithArray:_buttons];
    [buttonstoRemove minusSet:[NSSet setWithArray:buttons]];
    NSMutableSet *buttonsToAdd = [NSMutableSet setWithArray:buttons];
    [buttonsToAdd minusSet:[NSSet setWithArray:_buttons]];
    _buttons = [buttons copy];
    
    // Calculate end frames
    NSUInteger originX = 8;
    NSMutableArray *buttonFrames = [NSMutableArray arrayWithCapacity:_buttons.count];
    
    for (TBToolbarButton *button in _buttons) {
        button.appearance = self.appearance;
        
        CGRect frame = CGRectMake(originX, 0, CGRectGetWidth(button.frame), CGRectGetHeight(button.frame));
        [buttonFrames addObject:[NSValue valueWithCGRect:frame]];
        
        originX += button.bounds.size.width + 8;
    }
    
    CGSize contentSize = _scrollView.contentSize;
    contentSize.width = originX - 8;
    if (contentSize.width > _scrollView.contentSize.width) {
        _scrollView.contentSize = contentSize;
    }
    
    // Make added buttons appear from the right
    [buttonsToAdd enumerateObjectsUsingBlock:^(TBToolbarButton *button, BOOL *stop) {
        button.frame = CGRectMake(originX, 0, CGRectGetWidth(button.frame), CGRectGetHeight(button.frame));
        [_scrollView addSubview:button];
    }];
    
    // Animate
    [UIView animateWithDuration:0.2 animations:^{
        [buttonstoRemove enumerateObjectsUsingBlock:^(TBToolbarButton *button, BOOL *stop) {
            button.alpha = 0;
        }];
        
        [_buttons enumerateObjectsUsingBlock:^(TBToolbarButton *button, NSUInteger idx, BOOL *stop) {
            button.frame = [buttonFrames[idx] CGRectValue];
        }];
        
        _scrollView.contentSize = contentSize;
    } completion:^(BOOL finished) {
        [buttonstoRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
}

@end
