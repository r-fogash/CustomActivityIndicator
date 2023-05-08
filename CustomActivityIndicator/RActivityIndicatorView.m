//
//  RActivityIndicatorView.m
//  CustomActivityIndicator
//
//  Created by Robert on 3/27/17.
//  Copyright © 2017 Robert. All rights reserved.
//

#import "RActivityIndicatorView.h"

static const NSInteger kInitialNumberOfLines = 1;
static const NSInteger kMaxNumberOfLines = 12;

static const CGFloat kDefaultSize = 20.f;
static const CGFloat kDefaultLineWidth = 2.f;
static const CGFloat kDefaultLineHeight = 5.f;
static const CGFloat kDefaultLineCornerRadius = 1.f;

@interface RActivityIndicatorView ()

@property (assign, nonatomic, readwrite) NSInteger maxNumberOfLines;
@property (weak, nonatomic) CAReplicatorLayer *replicationLayer;

@end

IB_DESIGNABLE
@implementation RActivityIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self commonInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    [self commonInit];
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(kDefaultSize, kDefaultSize);
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    
    self.numberOfLines = 5;
}

- (void)layoutSubviews {
    [self adjustReplicationLayerFrame];
    [super layoutSubviews];
}

#pragma mark - Properties -

- (void)setNumberOfLines:(NSInteger)step {
    if (step <= kMaxNumberOfLines) {
        _numberOfLines = step;
        self.replicationLayer.instanceCount = _numberOfLines;
    }
}

#pragma mark - public methods -

- (void)reset {
    [self.replicationLayer removeAllAnimations];
    [self.replicationLayer.sublayers.firstObject removeAllAnimations];
    self.numberOfLines = 1;
}

- (void)spin {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.replicationLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)startAnimate {
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.fromValue = @(1.0);
    fade.toValue = @(0.0);
    fade.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fade.repeatCount = HUGE_VALF;
    fade.duration = 1.0;
    
    [self.replicationLayer.sublayers.firstObject addAnimation:fade forKey:@"Opacity animation"];
    self.replicationLayer.instanceDelay = 1.f/kMaxNumberOfLines;
}

- (void)commonInit {
    _maxNumberOfLines = kMaxNumberOfLines;
    _numberOfLines = kInitialNumberOfLines;
    
    [self installReplicationLayer];
    
    CALayer *line = [self makeLayerToReplicate];
    [self.replicationLayer addSublayer:line];
    self.replicationLayer.instanceCount = _numberOfLines;
    CGFloat angle = (M_PI * 2.0) / kMaxNumberOfLines;
    self.replicationLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
}

- (void)installReplicationLayer {
    CAReplicatorLayer* replicationLayer = [[CAReplicatorLayer alloc] init];
    [self.layer addSublayer:replicationLayer];
    self.replicationLayer = replicationLayer;
}

- (void)adjustReplicationLayerFrame {
    CGFloat x = (CGRectGetWidth(self.bounds) - kDefaultSize) / 2;
    CGFloat y = (CGRectGetHeight(self.bounds) - kDefaultSize) / 2;
    self.replicationLayer.frame = CGRectMake(x, y, kDefaultSize, kDefaultSize);
}

- (CALayer*)makeLayerToReplicate {
    CALayer *line = [[CALayer alloc] init];
    line.frame = CGRectMake(kDefaultSize/2.f - kDefaultLineWidth/2.f,
                            0.f,
                            kDefaultLineWidth,
                            kDefaultLineHeight);
    
    line.cornerRadius = kDefaultLineCornerRadius;
    line.backgroundColor = [self indicatorBackgroundColor].CGColor;
    return line;
}

- (UIColor*)indicatorBackgroundColor {
    return [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray].backgroundColor;
}

@end
