//
//  Career.m
//  SavantCareers
//
//  Created by Alicia Tams on 9/9/14.
//  Copyright (c) 2014 Alicia Tams. All rights reserved.
//

#import "Career.h"
#import "CareersApi.h"
#import <TFHpple.h>

@implementation Career

- (id) initWithTitleElement:(TFHppleElement *)titleElement
				bodyElement:(TFHppleElement *)bodyElement
		  detailLinkElement:(TFHppleElement *)detailLinkElement
				dateElement:(TFHppleElement *)dateElement
{
	if (self == [super init]) {
		
		//Assume locations are separated by " - " (should be after clean)
		NSArray *titleArray = [[CareersApi cleanString:titleElement.text] componentsSeparatedByString:@" - "];
		if (titleArray.count > 1) {
			//Join array back together using sub array to just before location if exists.
			_title = [((NSString *)[[titleArray subarrayWithRange:NSMakeRange(0, titleArray.count - ((titleArray.count > 2) ? 2 : 1))] componentsJoinedByString:@"-"]) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			//Last value in array _should_ be location
			_location = [((NSString *)titleArray[titleArray.count - 1]) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		}
		else {
			//Just set title if location doesn't exist
			_title = [CareersApi cleanString:titleElement.text];
		}
		
		_date = [CareersApi cleanString:dateElement.text];
		_shortDescription = [CareersApi cleanString:bodyElement.text];
		_URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL, [detailLinkElement objectForKey:@"href"]]];
		
	}
	return self;
}

@end
