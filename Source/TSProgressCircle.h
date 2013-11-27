//
//  TSProgressCircle.h
//
//  Created by Mark McFarlane on 21/2/2013.
//  Copyright (c) 2013 Tacchi Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSProgressCircle : UIView;

@property (nonatomic) float progress;
@property (nonatomic, strong) UIImageView *medalImage;

- (void)setProgress:(float)progress animatedWithDuration:(NSTimeInterval)duration;
- (void)setProgress:(float)progress animatedWithDuration:(NSTimeInterval)duration animateMedal:(BOOL)animateMedal;

@end

@interface TSRoundProgressLayer : CALayer

@property (nonatomic) float progress;

@end
