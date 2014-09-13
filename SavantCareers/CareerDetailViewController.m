//
//  CareerDetailViewController.m
//  SavantCareers
//
//  Created by Alicia Tams on 9/10/14.
//  Copyright (c) 2014 Alicia Tams. All rights reserved.
//

#import "CareerDetailViewController.h"
#import "CareersApi.h"
#import "Career.h"

@interface CareerDetailViewController ()

@property(nonatomic, strong) Career *career;

@property(nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIButton *applyButton;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation CareerDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCareer:(Career *)career
{
    self = [super init];
    if (self) {
        _career = career;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.title = @"Career Details";
	self.view.backgroundColor = [UIColor whiteColor];
	
	_scrollView = [UIScrollView new];
	_scrollView.translatesAutoresizingMaskIntoConstraints = NO;
	_scrollView.contentSize = CGSizeMake(300, 3000);
	[self.view addSubview:_scrollView];
	
	_titleLabel = [UILabel new];
	_titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	_titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
	_titleLabel.textColor = COLOR_DARKCYAN;
	_titleLabel.numberOfLines = 0;
	_titleLabel.text = [_career.title uppercaseString];
	
	_locationLabel = [UILabel new];
	_locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
	_locationLabel.font = [UIFont italicSystemFontOfSize:15.0f];
	_locationLabel.adjustsFontSizeToFitWidth = YES;
	_locationLabel.minimumScaleFactor = 1.0f;
	_locationLabel.textColor = [UIColor darkGrayColor];
	_locationLabel.highlightedTextColor = [UIColor darkGrayColor];
	_locationLabel.numberOfLines = 1;
	_locationLabel.text = _career.location;
	
	_detailLabel = [UILabel new];
	_detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
	_detailLabel.font = [UIFont systemFontOfSize:14.0f];
	_detailLabel.textColor = [UIColor grayColor];
	_detailLabel.numberOfLines = 0;
	[_scrollView addSubview:_detailLabel];
	
	_applyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_applyButton.translatesAutoresizingMaskIntoConstraints = NO;
	_applyButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
	[_applyButton setTitle:@"Apply Now" forState:UIControlStateNormal];
	_applyButton.tintColor = COLOR_DARKCYAN;
	[_applyButton addTarget:self action:@selector(applyTouched:) forControlEvents:UIControlEventTouchUpInside];
	[_scrollView addSubview:_applyButton];
	
	//Fix for iOS 6 overlapping negative margins - add title and location last
	[_scrollView addSubview:_titleLabel];
	[_scrollView addSubview:_locationLabel];
	
	_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	_activityIndicator.hidesWhenStopped = YES;
	[_activityIndicator startAnimating];
	_activityIndicator.frame = CGRectMake(_activityIndicator.frame.origin.x, _activityIndicator.frame.origin.y, 40, 40);
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicator];
	
	NSDictionary *views = NSDictionaryOfVariableBindings(_scrollView, _titleLabel, _locationLabel, _detailLabel, _applyButton);
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_scrollView]-0-|" options:0 metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_scrollView]-0-|" options:0 metrics:nil views:views]];

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_titleLabel]-10-|" options:0 metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_locationLabel]-10-|" options:0 metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_detailLabel]-10-|" options:0 metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_applyButton]-40-|" options:0 metrics:nil views:views]];
	
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_titleLabel]-3-[_locationLabel(>=0)]-10-[_detailLabel]-10-[_applyButton(==30)]-10-|" options:0 metrics:nil views:views]];
	
	_scrollView.alpha = 0.0f;
	
	if (_career) {
		[_activityIndicator startAnimating];
		[[CareersApi sharedCareersApi] loadCareerDetailsWithCareer:_career withCompletion:^(Career *career, NSError *error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[self->_activityIndicator stopAnimating];
				self->_detailLabel.attributedText = career.fullDescription;
				[UIView animateWithDuration:0.3f animations:^{
					self->_scrollView.alpha = 1.0f;
				}];
			});
		}];
	}
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
	
	_titleLabel.preferredMaxLayoutWidth = self.view.frame.size.width - 25;
	_locationLabel.preferredMaxLayoutWidth = self.view.frame.size.width - 25;
	_detailLabel.preferredMaxLayoutWidth = self.view.frame.size.width - 25;
	
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)applyTouched:(id)sender
{
	NSString *emailTitle = [NSString stringWithFormat:@"Inquery - %@ - %@", _career.title, _career.location];
    NSArray *toRecipents = [NSArray arrayWithObject:@"careers@savantsystems.com"];
    
    MFMailComposeViewController *mailComposeController = [[MFMailComposeViewController alloc] init];
    mailComposeController.subject = emailTitle;
    mailComposeController.toRecipients = toRecipents;
	
	mailComposeController.mailComposeDelegate = self;

	if (IS_OS_7_OR_LATER) {
		mailComposeController.navigationBar.tintColor = [UIColor whiteColor];
		mailComposeController.navigationBar.titleTextAttributes = @{ UITextAttributeTextColor:[UIColor whiteColor] };
	}

    [self presentViewController:mailComposeController animated:YES completion:NULL];
}

#pragma mark MFMailComposeViewControllerDelegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
