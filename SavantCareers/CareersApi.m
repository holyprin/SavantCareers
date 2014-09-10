//
//  CareersApi.m
//  SavantCareers
//
//  Created by Alicia Tams on 9/9/14.
//  Copyright (c) 2014 Alicia Tams. All rights reserved.
//

#import "CareersApi.h"
#import <TFHpple.h>
#import "Career.h"
#import <libxml/HTMLparser.h>

//Listing
static NSString * const listCareerTitleXPath = @"//div[@class='articlediv']/h2/a/strong";
static NSString * const listCareerDateXPath = @"//div[@class='articlediv']/h1";
static NSString * const listCareerBodyXPath = @"//div[@class='articlediv']/div[@class='articlebody']";
static NSString * const listCareerDetailLinkXPath = @"//div[@class='articlebody']/a[@class='articleLink']"; //Note: Remember to get href attribute!

//Details

@interface CareersApi()

@property(nonatomic, strong) NSOperationQueue *defaultQueue;

@end

@implementation CareersApi

#pragma mark Class

//Dispatch Once Macro
SINGLETON_GCD(CareersApi)

+ (NSString *)cleanString:(NSString *)string
{
	//Broken UTF-8 / Unicode Conversion of non-breaking spaces, long hyphens, trademarks, etc. in some circumstances.
	//trimming using custom charset doesn't work here because it would just
	//remove the character all together.
	string = [string stringByReplacingOccurrencesOfString:@"â„¢" withString:@"\u2122"];
	string = [string stringByReplacingOccurrencesOfString:@"Â­" withString:@"-"];
	string = [string stringByReplacingOccurrencesOfString:@" " withString:@" "];
	string = [string stringByReplacingOccurrencesOfString:@"Â" withString:@""];
	return string;
}


#pragma mark Instance

- (id)init
{
	if (self == [super init]) {
		_defaultQueue = [NSOperationQueue mainQueue];
	}
	return self;
}

- (void)loadCareerListAtPage:(int)pageNum withCompletion:(void (^)(NSArray *careers, NSError *error))completion;
{
	NSURLRequest *request = [NSURLRequest requestWithURL:CAREERS_URL(pageNum)];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[NSURLConnection sendAsynchronousRequest:request queue:_defaultQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
		if (error && completion) {
			completion(nil, error);
			return;
		}
		else {
			if (data) {
				NSMutableArray *careers = [NSMutableArray new];

				TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
				
				NSArray *titleElements = [doc searchWithXPathQuery:listCareerTitleXPath];
				NSArray *bodyElements = [doc searchWithXPathQuery:listCareerBodyXPath];
				NSArray *detailLinkElements = [doc searchWithXPathQuery:listCareerDetailLinkXPath];
				NSArray *dateElements = [doc searchWithXPathQuery:listCareerDateXPath];
				
				for (int i = 0; i < titleElements.count; i++) {
					if ([titleElements[i] isKindOfClass:[TFHppleElement class]]
						&& bodyElements.count == titleElements.count
						&& detailLinkElements.count == titleElements.count)
					{
						Career *career = [[Career alloc] initWithTitleElement:titleElements[i]
																  bodyElement:bodyElements[i]
															detailLinkElement:detailLinkElements[i]
																  dateElement:dateElements[i]];
						
						[careers addObject:career];
					}
				}
				
				if (completion)
					completion(careers, error);
			}
		}
	}];
}

- (void)loadCareerDetailsWithCareer:(Career *)career withCompletion:(void (^)(NSString *careerDetails, NSError *error))completion;
{
	if (career) {
		NSURLRequest *request = [NSURLRequest requestWithURL:career.URL];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		[NSURLConnection sendAsynchronousRequest:request queue:_defaultQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			if (completion)
				completion([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], error);
		}];
	}
}

@end
