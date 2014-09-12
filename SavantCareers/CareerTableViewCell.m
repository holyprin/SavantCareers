//
//  CareerTableViewCell.m
//  SavantCareers
//
//  Created by Alicia Tams on 9/9/14.
//  Copyright (c) 2014 Alicia Tams. All rights reserved.
//

#import "CareerTableViewCell.h"

@interface CareerTableViewCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation CareerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		self.detailTextLabel.numberOfLines = 0;
		self.textLabel.numberOfLines = 0;

		self.selectionStyle = UITableViewCellSelectionStyleGray;
		
		self.contentView.backgroundColor = [UIColor whiteColor];
		
		_titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
		_titleLabel.textColor = COLOR_DARKCYAN;
		_titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
		
		_locationLabel = [[UILabel alloc] init];
		_locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_locationLabel.font = [UIFont italicSystemFontOfSize:14.0f];
		_locationLabel.adjustsFontSizeToFitWidth = YES;
		_locationLabel.minimumScaleFactor = 1.0f;
		_locationLabel.textColor = [UIColor darkGrayColor];
		_locationLabel.highlightedTextColor = [UIColor darkGrayColor];
		_locationLabel.numberOfLines = 1;
        [self.contentView addSubview:_locationLabel];
		
        _summaryLabel = [[UILabel alloc] init];
		_summaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_summaryLabel.font = [UIFont systemFontOfSize:15.0f];
		_summaryLabel.textColor = [UIColor grayColor];
		_summaryLabel.highlightedTextColor = [UIColor darkGrayColor];
		_summaryLabel.numberOfLines = 0;
        [self.contentView addSubview:_summaryLabel];
    }
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    if (self.didSetupConstraints)
        return;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel, _summaryLabel, _locationLabel);
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_titleLabel]-10-|" options:0 metrics:nil views:views]];
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_locationLabel]-10-|" options:0 metrics:nil views:views]];
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_summaryLabel]-10-|" options:0 metrics:nil views:views]];
	
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_titleLabel]-3-[_locationLabel(>=0)]-3-[_summaryLabel]-10-|" options:0 metrics:nil views:views]];
	
    self.didSetupConstraints = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line labels based on the evaluated width of the label's frame for word-wrapping purposes.
	_titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(_titleLabel.frame) -1;
	_summaryLabel.preferredMaxLayoutWidth = CGRectGetWidth(_summaryLabel.frame) - 1;
}

- (void)updateFonts
{
	if (IS_OS_7_OR_LATER) {
		_titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
		_summaryLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
	}
}



- (void)configureCellWithCareer:(Career *)career
{
	_titleLabel.text = career.title;
	_summaryLabel.text = career.summary;
	_locationLabel.text = career.location;
	
	if (!career.location && [career.location isEqualToString:@""])
		_locationLabel.frame = CGRectMake(_locationLabel.frame.origin.x, _locationLabel.frame.origin.y, _locationLabel.frame.size.width, 0);
	else
		_locationLabel.frame = CGRectMake(_locationLabel.frame.origin.x, _locationLabel.frame.origin.y, _locationLabel.frame.size.width, 25);
	[self updateFonts];
}

@end
