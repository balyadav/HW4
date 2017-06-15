//
//  TimelineTableViewController.m
//  HW4byadav
//
//  Created by Baljeet Yadav on 6/15/17.
//  Copyright © 2017 CarnegieMellonUniversity. All rights reserved.
//

#import "TimelineTableViewController.h"

@interface TimelineTableViewController ()

@end

@implementation TimelineTableViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readTime];
//    NSLog(@"in view did load");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
//    NSLog(@"in view DID appear");
    [self readTime];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self.timelineData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twitterCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *timelineObject = [self.timelineData
                                    objectAtIndex: indexPath.row];
    NSDictionary *entities = timelineObject[@"user"];
//    NSString *name = [entities objectForKey:@"name"];
    NSString *createdAt = [timelineObject valueForKey:@"created_at"];
    
    NSArray *screenNameArray = [timelineObject valueForKeyPath:@"entities.user_mentions.screen_name"];
    NSString *screenName = @"";
    if([screenNameArray count] > 0){
        screenName = screenNameArray[0];
    }
    
    NSString *mentionPlusCreatedAt = [NSString stringWithFormat:@"%@ %@", createdAt, screenName];
    cell.textLabel.text = timelineObject[@"text"];
    cell.detailTextLabel.text= mentionPlusCreatedAt;
    cell.detailTextLabel.textColor = [UIColor blueColor];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) readTime {
    // Create an account store
    ACAccountStore *twitter = [[ACAccountStore alloc] init];
    // Create an account type
    ACAccountType *twAccountType = [twitter
                                    accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    // Request Access to the twitter account
    [twitter requestAccessToAccountsWithType:twAccountType options:nil
                                  completion:^(BOOL granted, NSError *error){
                                      if (granted)
                                      {
                                          // Create an Account
                                          ACAccount *twAccount = [[ACAccount alloc]
                                                                  initWithAccountType:twAccountType];
                                          NSArray *accounts = [twitter accountsWithAccountType:twAccountType];
                                          twAccount = [accounts lastObject];
                                          
                                          if(twAccount == nil){
                                              [self showAlertForNoAccount];
                                              return;
                                          }
                                          // Create an NSURL instance variable
                                          NSURL *twitterURL = [[NSURL alloc]
                                                               initWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
                                          NSDictionary *param =@{@"count":@"100", @"include_entities":@"true"};
                                          // Create a Http request
                                          SLRequest *requestUsersTweets = [SLRequest
                                                                           requestForServiceType:SLServiceTypeTwitter
                                                                           requestMethod:SLRequestMethodGET
                                                                           URL:twitterURL
                                                                           parameters:param];
                                          // Set the account to be used with the request
                                          [requestUsersTweets setAccount:twAccount];
                                          // Perform the request
                                          [requestUsersTweets performRequestWithHandler:^(NSData *responseData,
                                                                                          NSHTTPURLResponse *urlResponse, NSError *error2){
                                              
                                              long responseStatus = [urlResponse statusCode];
                                              if(responseStatus == 200){
                                                  //if error show proper message to the user, if success json
                                                  self.timelineData= [NSJSONSerialization
                                                                      JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves
                                                                      error:&error2];
                                                  //JSON output serialization
                                                  NSDictionary *jsonResponse = [NSJSONSerialization
                                                                                JSONObjectWithData:responseData options:kNilOptions error:nil];
                                                  if(self.timelineData.count > 0) {
//                                                      NSLog(@"%@", jsonResponse);
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self.tableView reloadData];});
                                                  } //end of if
                                              } else {
                                                  NSError *error = nil;
                                                  NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                                                  
                                                  if (error != nil) {
                                                      NSLog(@"Error parsing JSON.");
                                                  }
                                                  else {
                                                      NSString *errorMessage = [jsonArray valueForKeyPath:@"errors.message"][0];
                                                      [self showAlertWithMessage:errorMessage];
                                                      //NSLog(@"Required error message: %@", [jsonArray valueForKeyPath:@"errors.message"]);
                                                  }
                                              }

                                          }];//end of performRequestWithHandler: block
                                      } //end of if granted , if not do something [HW4]
                                  }]; //end of requestAccessToAccountsWithType: completion^{} block
} //end of readTimeline block

@end
