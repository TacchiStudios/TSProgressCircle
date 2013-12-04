//
//  TSProgressCircle.m
//
//  Created by Mark McFarlane on 21/2/2013.
//  Copyright (c) 2013 Tacchi Studios. All rights reserved.
//

#import "TSProgressCircle.h"

@interface TSProgressCircle ()

@property (nonatomic, strong) UIImageView *completionImageView;

@end

@implementation TSProgressCircle

+ (Class)layerClass
{
	return [TSRoundProgressLayer class];
}

#pragma mark -
#pragma mark Init/Setup

- (id)init
{
	self = [super init];
	if (self) {
		[self setup];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self setup];
}

- (void)setup
{
	if (!self.progressColor) {
		self.progressColor = [UIColor blueColor];
	}
	
	if (!self.progressBackgroundColor) {
		self.progressBackgroundColor = [UIColor grayColor];
	}
	
	if (!self.trackWidth) {
		self.trackWidth = 20.0;
	}
	
	if (!self.trackPadding) {
		self.trackPadding = 0.0;
	}
}


#pragma mark -
#pragma mark Setters/Getters

- (void)setProgress:(float)progress animatedWithRate:(NSTimeInterval)rate
{
	[self setProgress:progress animatedWithDuration:rate * progress];
}

- (void)setProgress:(float)progress animatedWithDuration:(NSTimeInterval)duration
{
	[self setContentScaleFactor:[[UIScreen mainScreen] scale]];
	
	if (self.completionImage) {
		if (!self.completionImageView){
			self.completionImageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 20, 20)];
			[self.completionImageView setAlpha:0];
			[self addSubview:self.completionImageView];
		}
		
		[self.completionImageView setImage:self.completionImage];
	}
	
	// Ensure 0 <= progress <= 1.0
	if(progress < 0.0f)
		progress = 0.0f;
	else if(progress > 1.0f)
		progress = 1.0f;
	
	
	TSRoundProgressLayer *layer = (TSRoundProgressLayer *)self.layer;
	layer.progressColor = self.progressColor;
	layer.progressBackgroundColor = self.progressBackgroundColor;
	layer.trackWidth = self.trackWidth;
	layer.trackPadding = self.trackPadding;
	
	layer.shouldHideTrackOn100Percent = self.completionImage ? YES : NO;
	
	if(duration) {
		float oldProgress = layer.progress;
		
		[CATransaction begin];
		[CATransaction setCompletionBlock:^{
			layer.progress = progress;
			
			if (self.animatesCompletionImage) {
				[self performSelector:@selector(updateMedalAnimated) withObject:nil afterDelay:0.2];
			} else {
				[self updateMedal];
			}
		}];
		
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
		animation.duration = duration;
		animation.fromValue = [NSNumber numberWithFloat:oldProgress];
		animation.toValue = [NSNumber numberWithFloat:progress];
		animation.removedOnCompletion = NO;
		animation.fillMode = kCAFillModeForwards;
		animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		[layer addAnimation:animation forKey:@"progressAnimation"];
		
		[CATransaction commit];
	} else {
		layer.progress = progress;
		[self updateMedal];
		
		[layer setNeedsDisplay];
	}
}

- (float)progress
{
	TSRoundProgressLayer *layer = (TSRoundProgressLayer *)self.layer;
	return layer.progress;
}

- (void)setProgress:(float)progress
{
	[self setProgress:progress animatedWithDuration:0];
}


#pragma mark -
#pragma mark Drawing

- (void)updateMedalAnimated
{
	float duration = 0.2;
	
	[UIView animateWithDuration:duration animations:^{
		self.completionImageView.layer.transform = CATransform3DMakeRotation(M_PI,0,1.0,0.0);
		
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:duration animations:^{
			
			self.completionImageView.layer.transform = CATransform3DMakeRotation(M_PI * 2,0,1.0,0.0);
		}];
	}];
	
	[UIView animateWithDuration:duration * 2 animations:^{
		[self updateMedal];
	}];
}

- (void)updateMedal
{
	if (self.progress >= 1.0f && self.completionImage) {
		[self.completionImageView setAlpha:1];
		[self.completionImageView setFrame:CGRectInset(self.bounds, -4, -4)];
	} else {
		[self.completionImageView setAlpha:0];
		[self.completionImageView setFrame:CGRectInset(self.bounds, 10, 10)];
		
	}
}



@end



@implementation TSRoundProgressLayer

- (id)initWithLayer:(id)layer
{
	self = [super initWithLayer:layer];
	if(self)
	{
		if([layer isKindOfClass:[TSRoundProgressLayer class]])
		{
			TSRoundProgressLayer *otherLayer = layer;
			self.progress = otherLayer.progress;
			self.trackWidth = otherLayer.trackWidth;
			self.progressColor = otherLayer.progressColor;
			self.progressBackgroundColor = otherLayer.progressBackgroundColor;
			self.trackPadding = otherLayer.trackPadding;
			
			self.shouldHideTrackOn100Percent = otherLayer.shouldHideTrackOn100Percent;
			
			[self setRasterizationScale:[[UIScreen mainScreen] scale]];
			[self setContentsScale:[[UIScreen mainScreen] scale]];
		}
	}
	
	return self;
}


+ (BOOL)needsDisplayForKey:(NSString *)key
{
	if([key isEqualToString:@"progress"]) {
		return YES;
	} else {
		return [super needsDisplayForKey:key];
	}
}

- (void)drawInContext:(CGContextRef)context
{
	// Drawing code
	
	if (self.progress >=0.999f && self.shouldHideTrackOn100Percent) {
		return;
	}
	
	NSAssert(self.progressColor, @"Must set a progress color!");
	NSAssert(self.trackWidth > 0, @"Must set a progress color!");
	
	CGRect allRect = self.bounds;
	
	// Draw background
	CGContextSetStrokeColorWithColor(context, self.progressBackgroundColor.CGColor);
	CGContextSetLineWidth(context, self.trackWidth);
	
	CGPoint bgCenter = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
	CGFloat bgRadius = (allRect.size.width - self.trackWidth) / 2;
	CGContextAddArc(context, bgCenter.x, bgCenter.y, bgRadius, 0, M_PI * 2, 0);
	CGContextStrokePath(context);

	// Draw progress
	float lineWidth = self.trackWidth - self.trackPadding;
	float startingDegrees = 90; // 0 is ->
	
	CGContextSetStrokeColorWithColor(context, self.progressColor.CGColor);
	CGContextSetLineWidth(context, lineWidth);
	
	CGPoint center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
	CGFloat radius = (allRect.size.width - lineWidth - self.trackPadding) / 2;
	CGFloat startAngle = startingDegrees * ((float)M_PI / 180);
	CGFloat endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
	CGContextAddArc(context, center.x, center.y, radius, startAngle,  endAngle, 0);
	CGContextStrokePath(context);
	
}

@end
