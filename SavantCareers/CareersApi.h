//
//  CareersApi.h
//  SavantCareers
//
//  Created by Alicia Tams on 9/9/14.
//  Copyright (c) 2014 Alicia Tams. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_URL_STRING @"http://www.savantsystems.com"

#define BASE_URL [NSURL URLWithString:BASE_URL_STRING]
#define CAREERS_URL(pageNum) [NSURL URLWithString:[NSString stringWithFormat:@"%@/careers/%i/careers.aspx",BASE_URL_STRING, pageNum]]

@class Career;

@interface CareersApi : NSObject

//Class
+ (id)sharedCareersApi;
+ (NSString *)cleanString:(NSString *)string;

//Instance
- (void)loadCareerListAtPage:(int)pageNum withCompletion:(void (^)(NSArray *careers, NSError *error))completion;
- (void)loadCareerDetailsWithCareer:(Career *)career withCompletion:(void (^)(NSString *careerDetails, NSError *error))completion;

@end
