//
//  DetailWindowViewController.h
//  StoryBoardTest
//
//  Created by Jonah Back on 5/30/13.
//  Copyright (c) 2013 Jonah Back. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface DetailWindowViewController : UIViewController <UIWebViewDelegate> {
    
Player* data;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@property (nonatomic, retain) Player *data;
@end
