//
//  HACProgressView.h
//  HowAboutWeCouples
//
//  Created by James Paolantonio on 9/27/13.
//  Copyright (c) 2013 HowAboutWe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HACProgressView : UIView

@property (assign, nonatomic) CGFloat totalProgess;
@property (strong, nonatomic) UIColor *fillColor;
@property (assign, nonatomic) CGFloat segmentAlpha;

- (void)endSegment;
- (void)setNewSegmentProgress:(float)progress;

- (void)reset;

@end
