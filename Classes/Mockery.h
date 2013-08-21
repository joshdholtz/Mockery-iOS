//
//  Mockery.h
//  Mockery
//
//  Created by Josh Holtz on 8/21/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MockeryResponse.h"

typedef MockeryResponse* (^ResponseBlock)(NSString *, NSURLRequest*, NSArray *routeParams);

@interface Mockery : NSObject

+ (Mockery *)mockeryWithURL:(NSString*)urlPrefix;
+ (NSString*)urlPrefix;

+ (void)get:(id)pathStringOrRegex block:(ResponseBlock)responseBlock;

+ (MockeryResponse*)get:(NSURLRequest*)request;

@end
