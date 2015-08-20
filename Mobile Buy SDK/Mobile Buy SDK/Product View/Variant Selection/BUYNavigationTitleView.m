//
//  BUYNavigationTitleView.m
//  Mobile Buy SDK
//
//  Created by Rune Madsen on 2015-08-18.
//  Copyright (c) 2015 Shopify Inc. All rights reserved.
//

#import "BUYNavigationTitleView.h"
#import "BUYTheme+Additions.h"
#import "BUYPresentationControllerForVariantSelection.h"

@interface BUYNavigationTitleView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *selectedOptionsLabel;
@property (nonatomic, strong) NSArray *titleConstraints;
@property (nonatomic, strong) NSArray *titleVariantsConstraints;

@end

@implementation BUYNavigationTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		UIView *containerView = [UIView new];
		containerView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:containerView];
		
		_titleLabel = [[UILabel alloc] init];
		_titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		_titleLabel.adjustsFontSizeToFitWidth = YES;
		_titleLabel.minimumScaleFactor = 0.5;
		_titleLabel.lineBreakMode = NSLineBreakByTruncatingHead;
		_titleLabel.font = [BUYTheme variantOptionSelectionTitleFont];
		[containerView addSubview:_titleLabel];
		
		_selectedOptionsLabel = [[UILabel alloc] init];
		_selectedOptionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_selectedOptionsLabel.textAlignment = NSTextAlignmentCenter;
		_selectedOptionsLabel.adjustsFontSizeToFitWidth = YES;
		_selectedOptionsLabel.minimumScaleFactor = 0.5;
		_selectedOptionsLabel.lineBreakMode = NSLineBreakByTruncatingHead;
		_selectedOptionsLabel.font = [BUYTheme variantOptionSelectionSelectionVariantOptionFont];
		[containerView addSubview:_selectedOptionsLabel];
		
		NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel, _selectedOptionsLabel);
		CGRect insetFrame = [BUYPresentationControllerForVariantSelection insetFrameGivenBounds:frame];
		NSDictionary *metricsDictionary = @{ @"maxWidth" : @(CGRectGetWidth(insetFrame) / 1.5f) };
		
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLabel(<=maxWidth)]|"
																	 options:0
																	 metrics:metricsDictionary
																	   views:views]];
		
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_selectedOptionsLabel(<=maxWidth)]|"
																	 options:0
																	 metrics:metricsDictionary
																	   views:views]];
		
		_titleConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLabel]|"
																	options:0
																	metrics:nil
																	  views:views];
		
		_titleVariantsConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_selectedOptionsLabel]-(-2)-[_titleLabel]|"
																			options:0
																			metrics:nil
																			  views:views];
		
		[self addConstraint:[NSLayoutConstraint constraintWithItem:containerView
														 attribute:NSLayoutAttributeCenterX
														 relatedBy:NSLayoutRelationEqual
															toItem:self
														 attribute:NSLayoutAttributeCenterX
														multiplier:1.0
														  constant:0.0]];
		
		[self addConstraint:[NSLayoutConstraint constraintWithItem:containerView
														 attribute:NSLayoutAttributeCenterY
														 relatedBy:NSLayoutRelationEqual
															toItem:self
														 attribute:NSLayoutAttributeCenterY
														multiplier:1.0
														  constant:0.0]];
	}
	return self;
}

- (void)setTitleWithBuyOption:(BUYOption*)buyOption selectedBuyOptionValues:(NSArray*)selectedBuyOptions
{
	_titleLabel.text = [NSString stringWithFormat:@"Choose %@", buyOption.name];
	if ([selectedBuyOptions count] > 0) {
		[NSLayoutConstraint activateConstraints:self.titleVariantsConstraints];
		[NSLayoutConstraint deactivateConstraints:self.titleConstraints];
		_selectedOptionsLabel.text = [selectedBuyOptions componentsJoinedByString:@" • "];
	} else {
		[NSLayoutConstraint deactivateConstraints:self.titleVariantsConstraints];
		[NSLayoutConstraint activateConstraints:self.titleConstraints];
	}
}

-(void)setTheme:(BUYTheme *)theme
{
	_titleLabel.textColor = [theme navigationBarTitleVariantSelectionColor];
	_selectedOptionsLabel.textColor = [theme navigationBarTitleVariantSelectionOptionsColor];
}

@end