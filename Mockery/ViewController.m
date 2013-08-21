//
//  ViewController.m
//  Mockery
//
//  Created by Josh Holtz on 8/21/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Any NSURLRequest with URL starting with your defined Mockery prefix with return your response
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://mockery/stuff"]];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSLog(@"Response - %d %@", httpResponse.statusCode, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    // Another example - GET
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://mockery/stuff/4/more/3"]];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSLog(@"Response - %d %@", httpResponse.statusCode, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    // Another example - POST
    request = [NSMutableURLRequest
               requestWithURL:[NSURL URLWithString:@"http://mockery/stuff"]];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSLog(@"Response - %d %@", httpResponse.statusCode, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
