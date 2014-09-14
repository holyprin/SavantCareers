//
//  CareersApi.m
//  SavantCareers
//
//  Created by Alicia Tams on 9/9/14.
//  Copyright (c) 2014 Alicia Tams. All rights reserved.
//

#import "CareersApi.h"
#import "TFHpple.h"
#import "Career.h"
#import <libxml/HTMLparser.h>

@interface CareersApi()

@property(nonatomic, strong) NSOperationQueue *defaultQueue;

@end

@implementation CareersApi

#pragma mark Class

//Dispatch Once Macro
SINGLETON_GCD(CareersApi)

#pragma mark Instance

- (id)init
{
	if (self = [super init]) {
		_defaultQueue = [NSOperationQueue mainQueue];
	}
	return self;
}

- (void)loadCareerListWithCompletion:(void (^)(NSArray *careers, NSError *error))completion;
{
	NSURLRequest *request = [NSURLRequest requestWithURL:CAREERS_URL];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[NSURLConnection sendAsynchronousRequest:request queue:_defaultQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
		TFHpple *search = [TFHpple hppleWithHTMLData:data encoding:@"UTF-8"];
		NSArray *resultsArray = [search searchWithXPathQuery:@"//div[contains(@class, 'view-open-positions')]//ul/li"];
		
		NSMutableArray *careers = [NSMutableArray new];
		
		if (resultsArray.count > 0) {
			for (TFHppleElement *element in resultsArray) {
				
				NSArray *titleElements = [element searchWithXPathQuery:@"//div[contains(@class,'views-field-title')]//text()[normalize-space()]"];
				
				//Check if we parsed correctly and objects within are TFHppleElements if not skip.
				if (titleElements.count == 0 && ![titleElements[0] isKindOfClass:[TFHppleElement class]])
					continue;
				
				NSArray *summaryElements = [element searchWithXPathQuery:@"//div[contains(@class,'views-field-field-summary')]//text()[normalize-space()]"];
				NSArray *linkElements = [element searchWithXPathQuery:@"//div[contains(@class,'views-field-view-node')]//a/@href"];

				//Only set to first known element text. no need for the titleElements check, but for consistency we use it.
				NSString *title = titleElements.count > 0 ? [titleElements[0] content] : @"";
				NSString *summary = summaryElements.count > 0 ? [summaryElements[0] content] : nil;
				NSString *link = linkElements.count > 0 ? [linkElements[0] text] : nil;
				
				//Fancyness to grab location
				NSString *location = nil;
				NSArray *titleArray = [title componentsSeparatedByString:@" - "];
				if (titleArray.count > 1) {
					title = [[titleArray subarrayWithRange:NSMakeRange(0, titleArray.count - 1)] componentsJoinedByString:@" - "];
					location = titleArray[titleArray.count-1];
				}
				
				Career *career = [Career new];
				career.title = title;
				career.location = location;
				career.summary = summary;
				career.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL_STRING,link]];
				
				[careers addObject:career];
			}
		}
		
		if (completion)
			completion(careers, error);
	}];
}

- (void)loadCareerDetailsWithCareer:(Career *)career withCompletion:(void (^)(Career *career, NSError *error))completion
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSError *error = nil;
		
		NSData *data = [NSData dataWithContentsOfURL:career.URL options:0 error:&error];
		
		TFHpple *search = [TFHpple hppleWithHTMLData:data encoding:@"UTF-8"];
		NSArray *resultsArray = [search searchWithXPathQuery:@"//div[contains(@class,'field-name-body')]/div/div/*[not(contains(.,'Please submit resumes to')) and normalize-space()]"];
		
		NSMutableAttributedString *finalString = [[NSMutableAttributedString alloc] init];
		for (TFHppleElement *element in resultsArray) {

			NSDictionary *titleDict = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:17], NSForegroundColorAttributeName: COLOR_DARKCYAN };
			NSDictionary *paragraphDict = @{ NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName: COLOR_DARKGRAY };
		
			NSAttributedString *string;
			if ([element.tagName isEqualToString:@"h4"])
				string = [[NSAttributedString alloc] initWithString:[self formatAndStripHtmlFromString:element.raw] attributes:titleDict];
			else
				string = [[NSAttributedString alloc] initWithString:[self formatAndStripHtmlFromString:element.raw] attributes:paragraphDict];
			
			[finalString appendAttributedString:string];
			
		}
		career.fullDescription = finalString;

		if (completion)
			completion(career, error);
	});
}

//Special case for formatting, regex is not the greatest option but in this
//particular case it's fine because it's fast enough.
- (NSString *)formatAndStripHtmlFromString:(NSString *)string
{
	string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	NSRange range;
	//br's are bad!
	while ((range = [string rangeOfString:@"<br\\s*/?>" options:NSRegularExpressionSearch | NSRegularExpressionCaseInsensitive]).location != NSNotFound)
		string = [string stringByReplacingCharactersInRange:range withString:@"\n"];
	
	while ((range = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
		string = [string stringByReplacingCharactersInRange:range withString:@""];
	
	string = [string stringByAppendingString:@"\n\n"];

	return string;
}

@end
