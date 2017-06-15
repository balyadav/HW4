//
//  TweetEventViewController.h
//  HW4byadav
//
//  Created by Baljeet Yadav on 6/14/17.
//  Copyright © 2017 CarnegieMellonUniversity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface TweetEventViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@property (weak, nonatomic) NSString *itemName;
@property (weak, nonatomic) NSString *itemDate;
- (IBAction)tweetButton:(id)sender;

@end
