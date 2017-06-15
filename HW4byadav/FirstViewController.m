//
//  FirstViewController.m
//  HW4byadav
//
//  Created by Baljeet Yadav on 6/14/17.
//  Copyright © 2017 CarnegieMellonUniversity. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

-(id)init{
    self = [super init];
    if(self)
    {
        self.events = @[@"Kick-Off Rally",
                        @"Blacktie & Tailpipes Gala",
                        @"Historics at Pitt Race Weekend ",
                        @"Walnut Street Car Show",
                        @"Waterfront Car Cruise",
                        @"Downtown Parade & Car Display",
                        @"Tune-Up Party @ Atria’s",
                        @"Countryside Tour",
                        @"Forbes Ave of Speed Race Car Parade",
                        @"Vintage Car Show & Car Races"];
        self.eventDates = @[@"Sunday, July 2 at TBD",
                            
                            @"July 7 at TBD" ,
                            
                            @"July 7-9 at Pittsburgh International Race Complex",
                            
                            @"Monday, July 10 at Walnut Street",
                            
                            @"Tuesday, July 11 at Waterfront",
                            
                            @"Wednesday, July 12 at Downtown",
                            
                            @"Wednesday, July 12 at Downtown",
                            
                            @"Thursday, July 13 at TBD",
                            
                            @"Thursday, July 14 at Forbes avenue to Squirrel Hill",
                            
                            @"Weekend, July 15/16 at Schenley Park"];
        self.title=@"PVGP Events";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self logTheEvents];
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
    //    return 0;
    return self.events.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * CellIdentifier =@"idntfr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    if (cell == nil) {
        NSLog(@"Nil condition met");
    }
    //Configure the cell...
    cell.textLabel.text =[self.events objectAtIndex:indexPath.row];
    NSString *dateString = [self.eventDates objectAtIndex:indexPath.row];
    NSString *subtitleToDisplay = dateString;
    cell.detailTextLabel.text=subtitleToDisplay;
    return cell;
}

- (void) logTheEvents{
    for(int i = 0; i < self.events.count; i++){
        NSLog(@"%@ \n %@", [self.events objectAtIndex:i], [self.eventDates objectAtIndex:i]);
    }
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //     Get the new view controller using [segue destinationViewController].
    //     Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"detail"]) {
        self.detailViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.detailViewController.itemName = _events[indexPath.row];
        self.detailViewController.itemDate = _eventDates[indexPath.row];
    }
}

@end
