//
//  DetailWindowViewController.m
//  StoryBoardTest
//
//  Created by Jonah Back on 5/30/13.
//  Copyright (c) 2013 Jonah Back. All rights reserved.
//

#import "DetailWindowViewController.h"

#define kLatestAcmPostsURL @"http://www.ceas3.uc.edu/acm/android/post/%d"

@interface DetailWindowViewController ()


@end


@implementation DetailWindowViewController

@synthesize data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    self.navigationItem.title = data.name;
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:kLatestAcmPostsURL, data.rating]];
    
    dispatch_queue_t kBgQueue = dispatch_get_global_queue(
                                                          DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    @try{
    dispatch_async(kBgQueue, ^{
        NSError *error = nil;
        NSData *data = [NSData  dataWithContentsOfURL:url options: NSDataReadingUncached error:&error];
        if(data != nil){
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        }
    });}
    @catch(NSException *e) {
        
    }
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchedData:(NSData*)responseData {
    NSError *error = nil;
    NSArray* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        NSDictionary* obj = [json objectAtIndex:0];


        [self.webView loadHTMLString:[obj objectForKey:@"body"] baseURL:[NSURL URLWithString:@""]];
        
    
    
    
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end
