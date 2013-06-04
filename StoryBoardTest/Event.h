//
//  Event.h
//  StoryBoardTest
//
//  Created by Jonah Back on 6/4/13.
//  Copyright (c) 2013 Jonah Back. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSDate* startTime;
@property (nonatomic,copy) NSDate* endTime;
@end
