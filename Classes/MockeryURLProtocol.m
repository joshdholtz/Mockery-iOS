//
//  MockeryURLProtocol.m
//  Mockery
//
//  Created by Josh Holtz on 8/21/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import "MockeryURLProtocol.h"

#import "Mockery.h"

@implementation MockeryURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSString *pathString = [[request URL] absoluteString];
    return [pathString hasPrefix:[Mockery urlPrefix]];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void) startLoading {
    id<NSURLProtocolClient> client = [self client];
    NSURLRequest* request = [self request];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        MockeryResponse *mockeryResponse = [Mockery hit:request];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
       
            NSHTTPURLResponse* response = [[NSHTTPURLResponse alloc] initWithURL:[request URL] statusCode:mockeryResponse.status HTTPVersion:@"HTTP/1.1" headerFields:[NSDictionary dictionary]];
            
            
            [client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
            [client URLProtocol:self didLoadData:mockeryResponse.data];
            [client URLProtocolDidFinishLoading:self];
            
        });
    });
    
}

- (void) stopLoading {}

@end
