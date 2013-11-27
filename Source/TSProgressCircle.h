//
//  TSProgressCircle.h
//
//  Created by Mark McFarlane on 21/2/2013.
//  Copyright (c) 2013 Tacchi Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSProgressCircle : UIView;

- (void)setProgress:(float)progress animatedWithDuration:(NSTimeInterval)duration; // Seconds to animate for any progress value
- (void)setProgress:(float)progress animatedWithRate:(NSTimeInterval)rate; // Seconds to animate to 100%. i.e. rate * progress

@property (nonatomic) float progress;

@property (nonatomic, strong) UIImage *completionImage;
@property BOOL animatesCompletionImage;

@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) UIColor *progressBackgroundColor; // TrackColor?

@property (nonatomic) float trackWidth;
@property (nonatomic) float trackPadding;

@end


@interface TSRoundProgressLayer : CALayer

@property (nonatomic) float progress;

@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) UIColor *progressBackgroundColor;

@property (nonatomic) float trackWidth;
@property (nonatomic) float trackPadding;

@property BOOL shouldHideTrackOn100Percent;

@end
