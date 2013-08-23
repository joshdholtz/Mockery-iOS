//
//  MockeryHTTPURLResponse.m
//  TreasureHunt
//
//  Created by Josh Holtz on 8/22/13.
//  Copyright (c) 2013 RokkinCat. All rights reserved.
//

#import "MockeryHTTPURLResponse.h"

@implementation MockeryHTTPURLResponse

+ (id)mockeryWithURL:(NSURL *)url statusCode:(NSInteger)statusCode data:(NSData*)data headerFields:(NSDictionary *)headerFields {
    return [[MockeryHTTPURLResponse alloc] initWithURL:url statusCode:statusCode data:data headerFields:headerFields];
}

- (id)initWithURL:(NSURL *)url statusCode:(NSInteger)statusCode data:(NSData*)data headerFields:(NSDictionary *)headerFields {
    self = [super initWithURL:url statusCode:statusCode HTTPVersion:@"HTTP/1.1" headerFields:headerFields];
    if (self) {
        _data = data;
    }
    return self;
}

@end
