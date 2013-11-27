//
//  TSProgressCircle.m
//
//  Created by Mark McFarlane on 21/2/2013.
//  Copyright (c) 2013 Tacchi Studios. All rights reserved.
//

#import "TSProgressCircle.h"

@implementation TSProgressCircle

+ (Class)layerClass
{
	return [TSRoundProgressLayer class];
}

- (void)setProgress:(float)progress animatedWithDuration:(NSTimeInterval)duration
{
	[self setProgress:progress animatedWithDuration:duration animateMedal:YES];
}

- (void)setProgress:(float)progress animatedWithDuration:(NSTimeInterval)duration animateMedal:(BOOL)animateMedal
{
	[self setContentScaleFactor:[[UIScreen mainScreen] scale]];

	if (!self.medalImage){
		self.medalImage = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 20, 20)];
		[self.medalImage setImage:[UIImage imageNamed:@"study_log_medal"]];
		[self.medalImage setAlpha:0];
		[self addSubview:self.medalImage];
	}
	
	// Ensure 0 <= progress <= 1.0
	if(progress < 0.0f)
		progress = 0.0f;
	else if(progress > 1.0f)
		progress = 1.0f;
	

	TSRoundProgressLayer *layer = (TSRoundProgressLayer *)self.layer;
	
	if(duration) {
		float oldProgress = layer.progress;
		
		[CATransaction begin];
		[CATransaction setCompletionBlock:^{
			layer.progress = progress;
			
			if (animateMedal) {
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

- (void)updateMedalAnimated
{
	float duration = 0.2;
	
	[UIView animateWithDuration:duration animations:^{
		self.medalImage.layer.transform = CATransform3DMakeRotation(M_PI,0,1.0,0.0);

	} completion:^(BOOL finished) {
		[UIView animateWithDuration:duration animations:^{

		self.medalImage.layer.transform = CATransform3DMakeRotation(M_PI * 2,0,1.0,0.0);
		}];
	}];
	
	[UIView animateWithDuration:duration * 2 animations:^{
		[self updateMedal];
	}];
}

- (void)updateMedal
{
	if (self.progress >= 1.0f) {
		[self.medalImage setAlpha:1];
		[self.medalImage setFrame:CGRectInset(self.bounds, -4, -4)];
	} else {
		[self.medalImage setAlpha:0];
		[self.medalImage setFrame:CGRectInset(self.bounds, 10, 10)];

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
			
			[self setRasterizationScale:[[UIScreen mainScreen] scale]];
			[self setContentsScale:[[UIScreen mainScreen] scale]];
		}
	}
	
	return self;
}


+ (BOOL)needsDisplayForKey:(NSString *)key
{
	if([key isEqualToString:@"progress"])
		return YES;
	else
		return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)context
{
	// Drawing code

	if (self.progress >=0.999f) {
		return;
	}
	
	CGRect allRect = self.bounds;

	float outerWidth = allRect.size.width * (20.0/90.0);
	float padding = 2;
	float lineWidth = outerWidth - padding;
	float startingDegrees = 90; // 0 is ->
	
	if (YES){
		// Draw background
		CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.1); // white
		CGContextSetLineWidth(context, outerWidth);
		
		// Draw progress
		CGPoint center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
		CGFloat radius = (allRect.size.width - outerWidth) / 2;
		CGContextAddArc(context, center.x, center.y, radius, 0, M_PI * 2, 0);
		CGContextStrokePath(context);
	}
	
	// Draw background
	CGContextSetRGBStrokeColor(context, 0, 141.0/255.0, 185.0/255.0, 1); // white
	CGContextSetLineWidth(context, lineWidth);
	
	// Draw progress
	CGPoint center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
	CGFloat radius = (allRect.size.width - lineWidth - padding) / 2;
	CGFloat startAngle = startingDegrees * ((float)M_PI / 180);
	CGFloat endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
	CGContextAddArc(context, center.x, center.y, radius, startAngle,  endAngle, 0);
	CGContextStrokePath(context);
}

@end
