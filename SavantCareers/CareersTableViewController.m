//
//  CareersTableViewController.m
//  SavantCareers
//
//  Created by Alicia Tams on 9/9/14.
//  Copyright (c) 2014 Alicia Tams. All rights reserved.
//

#import "CareersTableViewController.h"
#import "CareerTableViewCell.h"
#import "CareersApi.h"
#import "CareerDetailViewController.h"

@interface CareersTableViewController ()
{
	int pageNum;
	int currentPageCount;
}

@property (nonatomic, weak) CareersApi *api;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) CareerTableViewCell *stubCell;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation CareersTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Savant Careers";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//Register CareerTableViewCell class for reuse.
	[self.tableView registerClass:[CareerTableViewCell class] forCellReuseIdentifier:@"CareerCell"];
	
	//Remove extra separators
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	_activityIndicator.hidesWhenStopped = YES;
	[_activityIndicator startAnimating];
	_activityIndicator.frame = CGRectMake(_activityIndicator.frame.origin.x, _activityIndicator.frame.origin.y, 40, 40);
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicator];
	
	//Refresh control
	self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
							action:@selector(loadCareers)
                  forControlEvents:UIControlEventValueChanged];
	
	//prevent calling heightForRowAtIndexPath on hidden cells
	if (IS_OS_7_OR_LATER)
		self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
	
	_api = [CareersApi sharedCareersApi];
	
	//Cheater cell for calculating cell height
	_stubCell = [[CareerTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CareerCell"];
	
	//No data message
	UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
	
	messageLabel.text = @"No data is currently available.\nPlease pull down to refresh.";
	messageLabel.textColor = [UIColor blackColor];
	messageLabel.numberOfLines = 0;
	messageLabel.textAlignment = NSTextAlignmentCenter;
	messageLabel.font = [UIFont italicSystemFontOfSize:20];
	[messageLabel sizeToFit];
	
	self.tableView.backgroundView = messageLabel;
	
	[self loadCareers];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
	if (IS_OS_7_OR_LATER)
		[[NSNotificationCenter defaultCenter] addObserver:self.tableView
												 selector:@selector(reloadData)
													 name:UIContentSizeCategoryDidChangeNotification
												   object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
	
    if (IS_OS_7_OR_LATER)
		[[NSNotificationCenter defaultCenter] removeObserver:self.tableView
														name:UIContentSizeCategoryDidChangeNotification
													  object:nil];
}

- (void)loadCareers
{
	if (!_data)
		_data = [NSMutableArray new];
	
	[_data removeAllObjects];
	[self.tableView reloadData];
	
	[_activityIndicator startAnimating];
	[_api loadCareerListWithCompletion:^(NSArray *careers, NSError *error) {
		
		//Refreshing stuff
		[self->_activityIndicator stopAnimating];
		if ([self.refreshControl isRefreshing])
			[self.refreshControl endRefreshing];
		
		if (careers.count > 0) {
			
			NSMutableArray *indexPaths = [NSMutableArray new];
			for (int i = (int)self->_data.count; i < (int)self->_data.count + careers.count; i++) {
				[indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
			}
			
			[self->_data addObjectsFromArray:careers];
			[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
		
		}
		else {
			self->_data = nil;
			[self.tableView reloadData];
		}
		
	}];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	_data = nil;
	[self.tableView reloadData];
}

#pragma mark - Table view data source / delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	[_stubCell configureCellWithCareer:_data[indexPath.row]];
	
	//Auto height stuff
	[_stubCell setNeedsUpdateConstraints];
    [_stubCell updateConstraintsIfNeeded];
    _stubCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(_stubCell.bounds));
    [_stubCell setNeedsLayout];
    [_stubCell layoutIfNeeded];
	
    // Get the actual height required for the cell
    CGFloat height = [_stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Add an extra point to the height to account for the cell separator, which is added between the bottom
    // of the cell's contentView and the bottom of the table view cell.
    height += 1;
    
    return height;
	//return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CareerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CareerCell" forIndexPath:indexPath];
    
    // Configure the cell...
    [cell configureCellWithCareer:_data[indexPath.row]];

	[cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	CareerDetailViewController *controller = [[CareerDetailViewController alloc] initWithCareer:_data[indexPath.row]];
	
	[self.navigationController pushViewController:controller animated:YES];
}


@end
