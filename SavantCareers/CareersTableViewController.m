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

@end

@implementation CareersTableViewController

static const int ItemsPerPage = 10;

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
	
	//prevent calling heightForRowAtIndexPath on hidden cells
	if (IS_OS_7_OR_LATER)
		self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
	
	//Initialize data
	_data = [NSMutableArray new];
	pageNum = 1;
	
	_api = [CareersApi sharedCareersApi];
	
	_stubCell = [[CareerTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CareerCell"];
	
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
//	OGNode *page = [ObjectiveGumbo parseDocumentWithUrl:[NSURL URLWithString:[NSString stringWithFormat:CAREERS_URL, pageNum]]];
	
//	NSArray *articleDiv = [page elementsWithClass:@"articlediv"];
//	NSArray *dates = [((OGElement *)articleDiv[0]) elementsWithTag:GUMBO_TAG_H1];
//	NSArray *titles = [((OGElement *)articleDiv[0]) elementsWithTag:GUMBO_TAG_H2];
//	NSArray *bodies = [((OGElement *)articleDiv[0]) elementsWithClass:@"articlebody"];
//	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:CAREERS_URL, pageNum++]]];
//	TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
//	//NSArray *elements = [doc searchWithXPathQuery:@"//div[@class='articlediv']/h2/a/strong"];
//	//NSArray *elements = [doc searchWithXPathQuery:@"//div[@class='articlebody']"];
//	NSArray *elements = [doc searchWithXPathQuery:@"//div[@class='articlebody']/a[@class='articleLink']"];
//	for (TFHppleElement *element in elements) {
//		NSLog(@"%@", [element objectForKey:@"href"]);
//	}
//	currentPageCount = titles.count;
//	
//					
//					
//	for (int i = 0; i < titles.count; i++) {
//		OGElement *title = titles[i];
//		OGElement *body = bodies[i];
//		Career *career = [[Career alloc] init];
//		career.title = title.text;
//		NSLog(@"%@", ((OGElement *)body.children[1]).tag);
//		career.shortDescription = ((OGElement *)body.children[1]).text;
//		GumboTag
//		[_data addObject:career];
//	}
	
	[_api loadCareerListAtPage:pageNum++ withCompletion:^(NSArray *careers, NSError *error) {
		[_data addObjectsFromArray:careers];
		[self.tableView reloadData];
	}];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
	return 100.0f;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (_data.count % ItemsPerPage == 0 && indexPath.row == _data.count -1)
		[self loadCareers];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	CareerDetailViewController *controller = [[CareerDetailViewController alloc] initWithCareer:_data[indexPath.row]];
	
	[self.navigationController pushViewController:controller animated:YES];
}


@end
