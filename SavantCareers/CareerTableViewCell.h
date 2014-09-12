//
//  CareerTableViewCell.h
//  SavantCareers
//
//  Created by Alicia Tams on 9/9/14.
//  Copyright (c) 2014 Alicia Tams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Career.h"

@interface CareerTableViewCell : UITableViewCell

@property (nonatomic, readonly, strong) UILabel *titleLabel;
@property (nonatomic, readonly, strong) UILabel *summaryLabel;
@property (nonatomic, readonly, strong) UILabel *locationLabel;

- (void)configureCellWithCareer:(Career *)career;

@end
