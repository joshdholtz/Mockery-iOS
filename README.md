Mockery
==========

Mockery can best be described as an iOS micro web framework (similar to Ruby's Sinatra and Python's Flask). Define routes that listen for HTTP requests using GET, POST, PUT, DELETE using NSURLConnection, AFNetworking, any of your other go-to networking libraries.

### Possible Uses
The only use I have found for this (so far) is making mock APIs for rapid protyped applications. My Mockery routes read from and write to CoreData actually simulating a RESTful API which makes it pretty easy to switch the end point to a real working (server based) API.
<br/><strong>But please, let me know how you have found Mockery useful.</strong>

## Overview

```objc
// Define the URL your routes will run on
[Mockery mockeryWithURL:@"http://mockery"];
````

```objc
// Add route listeners
[Mockery get:@"/stuff" block:^MockeryResponse *(NSString *path, NSURLRequest *request, NSArray *routeParams) {
    // You should probably do more stuff than this
    NSString *responseString = @"Hey yo hey";
    NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[MockeryResponse alloc] initWithStatus:200 data:data];
}];
````

```objc
// Send a request using NSURLConnection, AFNetworking, or any other networking method of your choice
NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://mockery/stuff"]];
[NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    // Handle response in here
}];
````

## Working Example (Full example project in repo)

### AppDelegate.h
```objc

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self startTheMockery];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)startTheMockery {
    
    // Initialzes Mockery with a URL prefix for it to look for
    [Mockery mockeryWithURL:@"http://mockery"];
    
    // Defines a GET route for "/stuff/
    [Mockery get:@"/stuff" block:^MockeryResponse *(NSString *path, NSURLRequest *request, NSArray *routeParams) {
        NSString *responseString = @"Hey yo hey";
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        return [[MockeryResponse alloc] initWithStatus:200 data:data];
    }];
    
    // Defines a GET route for "/stuff/:some_number/more/:some_other_number" where :some_number and :some_other_number are stored in routeParams array
    [Mockery get:[NSRegularExpression regularExpressionWithPattern:@"^/stuff/(\\d+)/more/(\\d+)?" options:NSRegularExpressionCaseInsensitive error:nil] block:^MockeryResponse *(NSString *path, NSURLRequest *request, NSArray *routeParams) {
        NSLog(@"Route params - %@", routeParams);
        
        NSString *responseString = @"We found this regex";
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        return [[MockeryResponse alloc] initWithStatus:200 data:data];
    }];
    
    // Defines a POST route for "/stuff/
    [Mockery post:@"/stuff" block:^MockeryResponse *(NSString *path, NSURLRequest *request, NSArray *routeParams) {
        NSString *responseString = @"We could be adding an object to core data here";
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        return [[MockeryResponse alloc] initWithStatus:200 data:data];
    }];
}


```

### ViewController.h
```objc

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

```
