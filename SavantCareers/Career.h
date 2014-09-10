//
//  Career.h
//  SavantCareers
//
//  Created by Alicia Tams on 9/9/14.
//  Copyright (c) 2014 Alicia Tams. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFHppleElement;

@interface Career : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *location;
@property(nonatomic, copy) NSString *date;
@property(nonatomic, copy) NSString *shortDescription;
@property(nonatomic, copy) NSString *longDescription;
@property(nonatomic, copy) NSURL *URL;

- (id) initWithTitleElement:(TFHppleElement *)titleElement
				bodyElement:(TFHppleElement *)bodyElement
		  detailLinkElement:(TFHppleElement *)detailLinkElement
				dateElement:(TFHppleElement *)dateElement;

@end
