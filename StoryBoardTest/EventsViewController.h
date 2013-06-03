//
//  EventsViewController.h
//  StoryBoardTest
//
//  Created by Jonah Back on 6/3/13.
//  Copyright (c) 2013 Jonah Back. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray* events;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
