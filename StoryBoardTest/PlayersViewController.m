//
//  PlayersViewController.m
//  StoryBoardTest
//
//  Created by Jonah Back on 5/28/13.
//  Copyright (c) 2013 Jonah Back. All rights reserved.
//

#import "PlayersViewController.h"
#import "Player.h"
#import "DetailWindowViewController.h"

#define kLatestAcmPostsURL [NSURL URLWithString:@"http://www.ceas3.uc.edu/acm/android/post/"] //2

@interface PlayersViewController ()

@end

@implementation PlayersViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_queue_t kBgQueue = dispatch_get_global_queue(
                                                          DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:kLatestAcmPostsURL];
        if(data != nil){
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        }
    });
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.players count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Player *player = [self.players objectAtIndex:indexPath.row];
    cell.textLabel.text = player.name;
    cell.detailTextLabel.text = player.game;
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
    UIStoryboard *us = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    DetailWindowViewController *dvController = [us instantiateViewControllerWithIdentifier:@"detailView"];
    //DetailWindowViewController *dvController = [[DetailWindowViewController alloc] initWithNibName:@"detailView" bundle:[NSBundle mainBundle]];
    dvController.data = [self.players objectAtIndex:indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:dvController animated:YES];
    
    
}

- (void) fetchedData:(NSData*)responseData {
    NSError *error;
    NSArray* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if(true) {
        NSMutableArray* news;
        for(int i=[json count] - 1; i>=0; i--)
        {
            NSDictionary* obj = [json objectAtIndex:i];
            Player* player = [[Player alloc] init];
        
            player.name = [obj objectForKey:@"title"];
            player.game = [obj objectForKey:@"type"];
            player.rating = [[obj objectForKey:@"id"] intValue];
            [_players addObject:player];
        
        }
        //_players = news;
    }
    [self.tableView reloadData];
    
}

-(void)refreshView:(UIRefreshControl *)refresh {
      refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];

    // custom refresh logic would be placed here...
    dispatch_queue_t kBgQueue = dispatch_get_global_queue(
                                                          DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:kLatestAcmPostsURL];
        if(data != nil){
        [self performSelectorOnMainThread:@selector(refreshedData:) withObject:data waitUntilDone:YES];
        }
    });
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                             [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
    

    
}

- (void) refreshedData:(NSData*)responseData {
    NSError *error;
    NSArray* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if(_players.count != json.count) {
        [_players removeAllObjects];
        for(int i=[json count] - 1; i>=0; i--)
        {
            NSDictionary* obj = [json objectAtIndex:i];
            Player* player = [[Player alloc] init];
            
            player.name = [obj objectForKey:@"title"];
            player.game = [obj objectForKey:@"type"];
            player.rating = [[obj objectForKey:@"id"] intValue];
            [_players addObject:player];
            
        }
        //_players = news;
    }
    
    [self.tableView reloadData];
    
}



@end
