//
//  HACProgressView.m
//  HowAboutWeCouples
//
//  Created by James Paolantonio on 9/27/13.
//  Copyright (c) 2013 HowAboutWe. All rights reserved.
//

#import "HACProgressView.h"
#import "NSLayoutConstraint+HAWHelpers.h"
#import "UIColor+HACAdditions.h"

@interface HACProgressViewBar : UIView
@property (assign, nonatomic) float progress;
@property (assign, nonatomic) UIRectCorner roundedCorners;
@end

@implementation HACProgressViewBar


- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor localUserColor];
    }
    return self;
}

- (void)setRoundedCorners:(UIRectCorner)roundedCorners {
    _roundedCorners = roundedCorners;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:roundedCorners cornerRadii:CGSizeMake(16.0, 8.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = bezierPath.CGPath;
    self.layer.mask = maskLayer;
}

@end

@interface HACProgressView ()
@property (strong, nonatomic) NSMutableArray *segmentViewsArray;
@property (assign, nonatomic) NSUInteger currentIndex;
@property (assign, nonatomic) BOOL needsNewSegment;
@end

@implementation HACProgressView

- (id)init
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.segmentViewsArray = [[NSMutableArray alloc] init];
        self.segmentAlpha = 1;
        
        self.needsNewSegment = YES;
        self.fillColor =  [UIColor localUserColorDark];
        
    }
    return self;
}

- (void)endSegment {
    self.needsNewSegment = YES;
    
    HACProgressViewBar *view = [self.segmentViewsArray lastObject];
    view.backgroundColor = self.fillColor;
    
    [self setNeedsLayout];
}

- (void)setNewSegmentProgress:(float)progress {
    if (self.needsNewSegment) {
        self.needsNewSegment = NO;
        
        HACProgressViewBar *view = [[HACProgressViewBar alloc] init];
        [self addSubview:view];
        
        [self.segmentViewsArray addObject:view];
    }
    
    HACProgressViewBar *view = [self.segmentViewsArray lastObject];
    view.progress = progress;
    
    [self setNeedsLayout];
}

- (void)reset {
    for (HACProgressViewBar *view in self.segmentViewsArray) {
        [view removeFromSuperview];
    }
    [self.segmentViewsArray removeAllObjects];
    
    self.needsNewSegment = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat next = 0.0;
    
    int separatorBarCount = 0;
    HACProgressViewBar *lastView = [self.segmentViewsArray lastObject];
    CGFloat progess = lastView.progress;
    for (HACProgressViewBar *view in self.segmentViewsArray) {
        view.alpha = self.segmentAlpha;
        view.backgroundColor = self.fillColor;
        
        if ([view isEqual:lastView])
            break;
        
        progess += view.progress;
        
        next = CGRectGetMaxX(view.frame);
        separatorBarCount++;
    }
    
    separatorBarCount++;
    self.totalProgess = progess;
    
    CGFloat lineWidth = [UIScreen mainScreen].scale > 1.0 ? 0.5 : 1.0;
    
    CGRect frame = lastView.frame;
    
    UIRectCorner firstRectCorners;
    UIRectCorner lastRectCorners;
    
    frame.origin.x = next + lineWidth;
    frame.size.width = MAX(0.0, (width * lastView.progress) - lineWidth);
    frame.size.height = CGRectGetHeight(self.bounds);
    
    firstRectCorners = [lastView isEqual:[self.segmentViewsArray firstObject]] ? (UIRectCornerTopLeft | UIRectCornerBottomLeft) : (kNilOptions);
    lastRectCorners = [lastView isEqual:[self.segmentViewsArray lastObject]] ? (UIRectCornerTopRight | UIRectCornerBottomRight) : (kNilOptions);
    if (self.needsNewSegment && self.totalProgess < 1.0)
        lastRectCorners = kNilOptions;
    
    lastView.frame = frame;
    [lastView setRoundedCorners:firstRectCorners | lastRectCorners];
}

@end
