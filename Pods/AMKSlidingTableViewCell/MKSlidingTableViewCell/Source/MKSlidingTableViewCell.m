//
//  MKSlidingTableViewCell.m
//  MKSlidingTableViewCell
//
//  Created by Michael Kirk on 8/15/13.
//  Copyright (c) 2013 Michael Kirk. All rights reserved.
//

#import "MKSlidingTableViewCell.h"
#import "MKActionTableViewCell.h"

NSString * const MKDrawerDidOpenNotification = @"MKDrawerDidOpenNotification";
NSString * const MKDrawerDidCloseNotification = @"MKDrawerDidCloseNotification";

@interface MKSlidingTableViewCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *containerScrollView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (weak, nonatomic) MKActionTableViewCell *actionCell;
@property (weak, nonatomic) MKActionTableViewCell *mainActionCell;
@property (assign, nonatomic) IBInspectable BOOL bounceLeft;
@property (assign, nonatomic) IBInspectable BOOL autoClose;
@property (assign, nonatomic) IBInspectable CGFloat autoCloseDelay;
@property (nonatomic, assign) CGFloat mainDrawerRevealAmount;

@end

@implementation MKSlidingTableViewCell

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self initializeCell];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self initializeCell];
}

- (void)initializeCell
{
    self.open = NO;
}

- (void)prepareForReuse
{
    self.open = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutContainerScrollView];
    [self layoutDrawerView];
    [self layoutForegroundView];
    [self setScrollViewOffsetIfDrawerIsOpen];
}

- (void)setScrollViewOffsetIfDrawerIsOpen
{
    if (self.isOpen)
    {
        self.containerScrollView.contentOffset = CGPointMake(self.drawerRevealAmount, 0.0f);
    }
}

- (void)layoutContainerScrollView
{
    CGRect scrollViewRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGSize scrollViewContentSize = CGSizeMake(CGRectGetWidth(self.bounds) + self.drawerRevealAmount, CGRectGetHeight(self.bounds));
    UIScrollView *containerScrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
    
    containerScrollView.contentSize = scrollViewContentSize;
    containerScrollView.delegate = self;
    containerScrollView.showsHorizontalScrollIndicator = NO;
    containerScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.containerScrollView = containerScrollView;
    
    [self.contentView addSubview:containerScrollView];
}

- (void)layoutForegroundView
{
    self.containerScrollView.backgroundColor = self.backgroundColor;
    
    CGRect foregroundRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.foregroundView.frame = foregroundRect;
    
    [self.containerScrollView addSubview:self.foregroundView];
    [self addGestureRecognizerToForegroundView];
}

- (void)addGestureRecognizerToForegroundView
{
    [self.foregroundView removeGestureRecognizer:self.tapGestureRecognizer];
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.tapGestureRecognizer.numberOfTapsRequired = 1;
    self.tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.foregroundView addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectSlidingTableViewCell:)])
    {
        [self.delegate didSelectSlidingTableViewCell:self];
    }
}

- (void)layoutDrawerView
{
    CGRect drawerRect = CGRectMake(CGRectGetWidth(self.bounds) - self.drawerRevealAmount, 0, self.drawerRevealAmount, CGRectGetHeight(self.bounds));
    self.drawerView.frame = drawerRect;
    
    [self.containerScrollView addSubview:self.drawerView];
}

#pragma mark - Custom Setters

- (void)setContainerScrollView:(UIScrollView *)containerScrollView
{
    [self.containerScrollView removeFromSuperview];
    _containerScrollView = containerScrollView;
}

- (void)setDrawerView:(UIView *)drawerView
{
    [self.drawerView removeFromSuperview];
    _drawerView = drawerView;
    
    if([drawerView isKindOfClass:[MKActionTableViewCell class]])
    {
        MKActionTableViewCell *actionCell = (MKActionTableViewCell*)drawerView;
        actionCell.isBackground = YES;
        [self setDrawerRevealAmount:actionCell.actionBounds.size.width];
        self.actionCell = actionCell;
    }
    
    [self setNeedsLayout];
}

- (void)setForegroundView:(UITableViewCell *)foregroundView
{
    [_foregroundView removeFromSuperview];
    _foregroundView = foregroundView;
    
    if([foregroundView isKindOfClass:[MKActionTableViewCell class]])
    {
        MKActionTableViewCell *actionCell = (MKActionTableViewCell*)foregroundView;
        actionCell.isBackground = NO;
        _mainDrawerRevealAmount = actionCell.actionBounds.size.width;
        self.mainActionCell = actionCell;
    }
    
    [self setNeedsLayout];
}

- (void)setDrawerRevealAmount:(CGFloat)drawerRevealAmount
{
    _drawerRevealAmount = drawerRevealAmount;
    [self setNeedsLayout];
}

- (void)setOpen:(BOOL)open
{
    _open = open;
    if (open) {
        [self installCloseDrawerAction];
    } else {
        [self installOpenDrawerAction];
    }
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.containerScrollView.contentOffset.x < 0)
    {
        scrollView.contentOffset = CGPointZero;
    }
    else if (self.containerScrollView.contentOffset.x > self.drawerRevealAmount && !self.bounceLeft)
    {
        scrollView.contentOffset = CGPointMake(self.drawerRevealAmount, 0);
    }
    
    CGFloat drawerX = scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - self.drawerRevealAmount);
    self.drawerView.frame = CGRectMake(drawerX, 0, self.drawerRevealAmount, CGRectGetHeight(self.bounds));
    
    CGFloat progress = self.containerScrollView.contentOffset.x / self.drawerRevealAmount;
    
    [self.actionCell setRevealProgress:progress];
    CGFloat multiplier = (self.mainDrawerRevealAmount != 0) ? self.drawerRevealAmount / self.mainDrawerRevealAmount : 0;
    CGFloat mainCellProgress = progress * multiplier;
    [self.mainActionCell setRevealProgress:mainCellProgress];
    
    // Check steps
    NSInteger step = [self computeCurrentStepForOffset:scrollView.contentOffset];
    [self.actionCell didChangedToStep:step];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.drawerRevealSteps <= 1) {
        if (scrollView.contentOffset.x > (self.drawerRevealAmount / 2))
        {
            if (velocity.x < -0.4)
            {
                *targetContentOffset = CGPointZero;
            }
            else
            {
                [self openDrawerWithTargetContentOffset:targetContentOffset];
            }
        }
        else if (scrollView.contentOffset.x == 0)
        {
            [self postCloseDrawerNotification];
        }
        else
        {
            if (velocity.x > 0.4)
            {
                [self openDrawerWithTargetContentOffset:targetContentOffset];
            }
            else
            {
                *targetContentOffset = CGPointZero;
            }
        }
    }
    else {
        // Check steps
        NSInteger step = [self computeCurrentStepForOffset:scrollView.contentOffset];
        CGFloat stepRevealAmount = self.drawerRevealAmount / self.drawerRevealSteps;
        
        if (scrollView.contentOffset.x == 0)
        {
            [self postCloseDrawerNotification];
        }
        else if(step == 0)
        {
            *targetContentOffset = CGPointZero;
        }
        else if(step != NSNotFound)
        {
            [scrollView setContentOffset:CGPointMake(step * stepRevealAmount, 0) animated:YES];
            [self postOpenDrawerNotification];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(self.autoClose) {
        [self performAutoCloseAfterDelay:self.autoCloseDelay];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0)
    {
        [self postCloseDrawerNotification];
    }
    else if(self.autoClose) {
        [self performAutoCloseAfterDelay:self.autoCloseDelay];
    }
}

- (void)openDrawerWithTargetContentOffset:(inout CGPoint *)targetContentOffset
{
    targetContentOffset->x = self.drawerRevealAmount;
    [self postOpenDrawerNotification];
}

- (void)openDrawerWithTargetContentOffset:(inout CGPoint *)targetContentOffset andStep:(NSInteger)step
{
    targetContentOffset->x = self.drawerRevealAmount * (step / self.drawerRevealSteps);
    [self postOpenDrawerNotification];
}

- (void)postOpenDrawerNotification
{
    if (!self.isOpen)
    {
        self.open = YES;
        
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self);
        NSNotification *notification = [NSNotification notificationWithName:MKDrawerDidOpenNotification object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

- (void)postCloseDrawerNotification
{
    if (self.isOpen)
    {
        self.open = NO;
        
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self);
        NSNotification *notification = [NSNotification notificationWithName:MKDrawerDidCloseNotification object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

- (void)animateDrawerClose:(void(^)())completion
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.containerScrollView.contentOffset = CGPointZero;
    } completion:^(BOOL finished) {
        [self postCloseDrawerNotification];
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - Step methods

- (NSInteger)computeCurrentStepForOffset:(CGPoint)offset
{
    if(self.actionCell && self.drawerRevealSteps > 0)
    {
        if(offset.x < 0)
        {
            return 0;
        }
        
        CGFloat stepRevealAmount = self.drawerRevealAmount / self.drawerRevealSteps;
        NSInteger currentStep = self.actionCell.currentStep;
        currentStep = MAX(0, MIN(self.drawerRevealSteps, currentStep));
        NSInteger offsetStep = (NSInteger) ((offset.x + stepRevealAmount/2) / stepRevealAmount);
        offsetStep = MAX(0, MIN(self.drawerRevealSteps, offsetStep));
        NSInteger offsetHardStep = (NSInteger) ((offset.x - stepRevealAmount/4) / stepRevealAmount);
        offsetHardStep = MAX(0, MIN(self.drawerRevealSteps, offsetHardStep));
        
        if (ABS(offsetStep - currentStep)>1)
        {
            return offsetStep;
        }
        if(offsetStep == offsetHardStep || offsetStep == self.drawerRevealSteps)
        {
            return offsetStep;
        }
        
        return currentStep;
    }
    
    return NSNotFound;
}

#pragma mark - Auto Close methods

- (void)performAutoCloseAfterDelay:(NSTimeInterval)delay
{
    [self cancelAutoClose];
    
    [self performSelector:@selector(closeDrawer) withObject:nil afterDelay:delay];
}

- (void)cancelAutoClose
{
    [UIView cancelPreviousPerformRequestsWithTarget:self selector:@selector(closeDrawer) object:nil];
}

#pragma mark - Public Methods

- (void)openDrawer
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.containerScrollView.contentOffset = CGPointMake(150, 0);
    } completion:^(BOOL finished) {
        [self postOpenDrawerNotification];
    }];
}

- (void)closeDrawer
{
    [self animateDrawerClose:nil];
}

- (void)closeDrawer:(void(^)())completion
{
    [self animateDrawerClose:completion];
}

#pragma mark - Invocation Handling

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.foregroundView;
}

#pragma mark - Accessibility

- (NSInteger)accessibilityElementCount
{
    return 1;
}

- (id)accessibilityElementAtIndex:(NSInteger)index
{
    if (index == 0) {
        if (self.open) {
            return self.drawerView;
        } else {
            return self.foregroundView;
        }
    }
    return nil;
}

- (NSInteger)indexOfAccessibilityElement:(id)element
{
    if (element == self.drawerView || element == self.foregroundView) {
        return 0;
    }
    return NSNotFound;
}

- (void)installOpenDrawerAction
{
    // UIAccessibilityCustomAction was just added in iOS 8.
    if (NSClassFromString(@"UIAccessibilityCustomAction") != nil) {
        UIAccessibilityCustomAction *action = [[UIAccessibilityCustomAction alloc] initWithName:@"More options"
                                                                                         target:self
                                                                                       selector:@selector(openDrawer)];
        self.accessibilityCustomActions = @[action];
    }
}

- (void)installCloseDrawerAction
{
    // UIAccessibilityCustomAction was just added in iOS 8.
    if (NSClassFromString(@"UIAccessibilityCustomAction") != nil) {
        UIAccessibilityCustomAction *action = [[UIAccessibilityCustomAction alloc] initWithName:@"Fewer options"
                                                                                         target:self
                                                                                       selector:@selector(closeDrawer)];
        self.accessibilityCustomActions = @[action];
    }
}

@end
