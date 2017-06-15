//
//  TweetEventViewController.m
//  Test0606
//
//  Created by Baljeet Yadav on 6/14/17.
//  Copyright © 2017 CarnegieMellonUniversity. All rights reserved.
//

#import "TweetEventViewController.h"

@interface TweetEventViewController ()

@end

@implementation TweetEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.eventDate.text = self.itemDate;
    self.eventName.text = self.itemName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void) showAlertForNoAccount{
    //Using main thread to avoid "This application is modifying the autolayout engine ..." console warning
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"User doesn't have an account!");
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No twitter account found!"
                                                                   message:@"Please asociate a twitter account in Settings>Twitter"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void) showAlertWithMessage: (NSString*) errorMessage{
    //Using main thread to avoid "This application is modifying the autolayout engine ..." console warning
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Other error message");
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                       message:errorMessage
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void) showAlertSuccess{
    //Using main thread to avoid "This application is modifying the autolayout engine ..." console warning
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Message successfully posted to Twitter!");
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success!"
                                                                       message:@"Your status was successfully posted to Twitter"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (IBAction)tweetButton:(id)sender {
    // Create an account store
    ACAccountStore *twitter = [[ACAccountStore alloc] init];
    
    // Create an account type
    ACAccountType *twAccountType = [twitter accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request Access to the twitter account
    [twitter requestAccessToAccountsWithType:twAccountType options:nil completion:^(BOOL granted, NSError *error){
        // If permission is granted
        if (granted){
            // Create an Account
            ACAccount *twAccount = [[ACAccount alloc] initWithAccountType:twAccountType];
            NSArray *accounts = [twitter accountsWithAccountType:twAccountType];
            twAccount = [accounts lastObject];
            if( twAccount == nil){
                [self showAlertForNoAccount];
            }
            // Create an NSURL instance variable as Twitter status_update end point.
            NSURL *twitterPostURL = [[NSURL alloc] initWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
            
            // Create a request
            SLRequest *requestPostTweets = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:twitterPostURL parameters:nil];
            
            // Set the account to be used with the request
            [requestPostTweets setAccount:twAccount];
            
            //Append mention with status
            _itemName = [NSString stringWithFormat:@"@08723Mapp byadav %@", _itemName];
            NSString *tweetMessage = [_itemName stringByAppendingFormat:@"%@ %@", @" on", _itemDate];
            [requestPostTweets addMultipartData:[tweetMessage dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"multipart/form-data" filename:nil];
            
            // Perform the request
            [requestPostTweets performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error2){
                if (error2!= nil) {
                    // Do Something when gets error
                    NSLog(@"error2 message not nil!");
                }
                long response = [urlResponse statusCode];
                // The output of the request is placed in the log.
                NSLog(@"HTTP Response: %li", response);
//                if(response == 400 && twAccount == nil){
//                    [self showAlertForNoAccount];
//                } else
                if (response == 200){
                    [self showAlertSuccess];
                } else {
                    NSError *error = nil;
                    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                    
                    if (error != nil) {
                        NSLog(@"Error parsing JSON.");
                    }
                    else {
//                        NSLog(@"Array: %@", jsonArray);
                        NSString *errorMessage = [jsonArray valueForKeyPath:@"errors.message"][0];
                        [self showAlertWithMessage:errorMessage];
//                        NSLog(@"Required error message: %@", [jsonArray valueForKeyPath:@"errors.message"]);
                    }
                }
            }]; // end of performRequestWithHandler: ^block
        } else {
            NSLog(@"Entered the exception handling!");
            //TODO If permission is not granted, do some error handling ...
        }
    }];
    // end of requestAccessToAccountsWithType: ^block
}
@end
