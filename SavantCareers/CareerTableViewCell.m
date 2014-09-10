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
		
		_titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
		
		_titleLabel.textColor = COLOR_DARKCYAN;
		_titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
		
		_dateLabel = [[UILabel alloc] init];
		_dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_dateLabel.font = [UIFont systemFontOfSize:14.0f];
		_dateLabel.textAlignment = NSTextAlignmentRight;
		_dateLabel.textColor = [UIColor grayColor];
		_dateLabel.highlightedTextColor = [UIColor darkGrayColor];
		_dateLabel.numberOfLines = 0;
        [self.contentView addSubview:_dateLabel];
		
		_locationLabel = [[UILabel alloc] init];
		_locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_locationLabel.font = [UIFont italicSystemFontOfSize:14.0f];
		_locationLabel.adjustsFontSizeToFitWidth = YES;
		_locationLabel.minimumScaleFactor = 1.0f;
		_locationLabel.textColor = [UIColor darkGrayColor];
		_locationLabel.highlightedTextColor = [UIColor darkGrayColor];
		_locationLabel.numberOfLines = 1;
        [self.contentView addSubview:_locationLabel];
		
        _descriptionLabel = [[UILabel alloc] init];
		_descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_descriptionLabel.font = [UIFont systemFontOfSize:15.0f];
		_descriptionLabel.textColor = [UIColor grayColor];
		_descriptionLabel.highlightedTextColor = [UIColor darkGrayColor];
		_descriptionLabel.numberOfLines = 0;
        [self.contentView addSubview:_descriptionLabel];
		
		
    }
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    if (self.didSetupConstraints)
        return;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel, _descriptionLabel, _dateLabel, _locationLabel);
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_titleLabel]-10-[_dateLabel(70)]-10-|" options:0 metrics:nil views:views]];
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_dateLabel(20)]" options:0 metrics:nil views:views]];
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_locationLabel]-10-|" options:0 metrics:nil views:views]];
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_titleLabel]-3-[_locationLabel]-3-[_descriptionLabel]-10-|" options:0 metrics:nil views:views]];
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_descriptionLabel]-10-|" options:0 metrics:nil views:views]];
	
    self.didSetupConstraints = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line labels based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
	self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.descriptionLabel.frame);
    self.descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.descriptionLabel.frame);
}

- (void)updateFonts
{
	if (IS_OS_7_OR_LATER) {
		self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
		self.descriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
	}
	else {
		
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithCareer:(Career *)career
{
	self.titleLabel.text = career.title;
	self.descriptionLabel.text = career.shortDescription;
	self.dateLabel.text = career.date;
	self.locationLabel.text = career.location;
	[self updateFonts];
}

@end
