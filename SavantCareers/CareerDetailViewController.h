//
//  CareerDetailViewController.h
//  SavantCareers
//
//  Created by Alicia Tams on 9/10/14.
//  Copyright (c) 2014 Alicia Tams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class Career;

@interface CareerDetailViewController : UIViewController<MFMailComposeViewControllerDelegate>

- (id)initWithCareer:(Career *)career;

@end
