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
@property(nonatomic, strong) UILabel *detailLabel;

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
    // Do any additional setup after loading the view.
	self.title = @"Career Details";
	self.view.backgroundColor = [UIColor whiteColor];
	
	_scrollView = [[UIScrollView alloc] init];
	_scrollView.translatesAutoresizingMaskIntoConstraints = NO;
	_scrollView.contentSize = CGSizeMake(320.0, 3000);
	[self.view addSubview:_scrollView];
	
	_detailLabel = [[UILabel alloc] init];
	_detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
	_detailLabel.font = [UIFont systemFontOfSize:14.0f];
	_detailLabel.textColor = [UIColor grayColor];
	_detailLabel.numberOfLines = 0;
	_detailLabel.backgroundColor = [UIColor greenColor];
	[_scrollView addSubview:_detailLabel];
	
	NSDictionary *views = NSDictionaryOfVariableBindings(_scrollView, _detailLabel);
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_scrollView]-0-|" options:0 metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_scrollView]-0-|" options:0 metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_detailLabel]-10-|" options:0 metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_detailLabel]-10-|" options:0 metrics:nil views:views]];
	if (_career)
		[[CareersApi sharedCareersApi] loadCareerDetailsWithCareer:_career withCompletion:^(NSString *careerDetails, NSError *error) {
			_career.longDescription = careerDetails;
			[self updateView];
		}];
}

- (void)updateView
{
	_detailLabel.text = _career.longDescription;
	[self.view layoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
