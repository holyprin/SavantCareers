//
//  CareersApi.h
//  SavantCareers
//
//  Created by Alicia Tams on 9/9/14.
//  Copyright (c) 2014 Alicia Tams. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_URL_STRING @"http://www.savant.com"
#define BASE_URL [NSURL URLWithString:BASE_URL_STRING]

#define CAREERS_PATH @"/join_our_team"
#define CAREERS_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL_STRING, CAREERS_PATH]]

@class Career;

@interface CareersApi : NSObject

//Class
+ (id)sharedCareersApi;

//Instance
- (void)loadCareerListWithCompletion:(void (^)(NSArray *careers, NSError *error))completion;
- (void)loadCareerDetailsWithCareer:(Career *)career withCompletion:(void (^)(Career *career, NSError *error))completion;

@end
