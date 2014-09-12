//
//  Career.h
//  SavantCareers
//
//  Created by Alicia Tams on 9/9/14.
//  Copyright (c) 2014 Alicia Tams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Career : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *location;
@property(nonatomic, copy) NSString *summary;
@property(nonatomic, copy) NSAttributedString *fullDescription;
@property(nonatomic, copy) NSURL *URL;

@end
