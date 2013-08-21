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

    MockeryResponse *mockeryResponse = [Mockery hit:request];
    
    NSHTTPURLResponse* response = [[NSHTTPURLResponse alloc] initWithURL:[request URL] statusCode:mockeryResponse.status HTTPVersion:@"HTTP/1.1" headerFields:[NSDictionary dictionary]];

    
    [client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [client URLProtocol:self didLoadData:mockeryResponse.data];
    [client URLProtocolDidFinishLoading:self];
    
}

- (void) stopLoading {}

@end
