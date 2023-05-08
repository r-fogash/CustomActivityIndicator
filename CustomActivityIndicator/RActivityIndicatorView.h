//
//  RActivityIndicatorView.h
//  CustomActivityIndicator
//
//  Created by Robert on 3/27/17.
//  Copyright © 2017 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RActivityIndicatorView : UIView

@property (assign, nonatomic, readonly) NSInteger maxNumberOfLines;
@property (assign, nonatomic) NSInteger numberOfLines;

- (void)spin;
- (void)startAnimate;
- (void)reset;

@end
