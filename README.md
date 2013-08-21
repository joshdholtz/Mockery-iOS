Mockery
==========

iOS Web Framework??? Not sure what to call yet but I'm using it to mock an API locally


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
}


```

### ViewController.h
```objc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Any NSURLRequest with URL starting with your defined Mockery prefix with return your response
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mockery/stuff/4/more/3"]];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSLog(@"Response - %d %@", httpResponse.statusCode, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
}

```
