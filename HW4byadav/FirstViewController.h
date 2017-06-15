//
//  FirstViewController.h
//  HW4byadav
//
//  Created by Baljeet Yadav on 6/14/17.
//  Copyright © 2017 CarnegieMellonUniversity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetEventViewController.h"
@interface FirstViewController : UITableViewController

@property NSArray *events;
@property NSArray *eventDates;

@property (weak, nonatomic) TweetEventViewController *detailViewController;
@end


