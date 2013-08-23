//
//  MockeryHTTPURLResponse.h
//  TreasureHunt
//
//  Created by Josh Holtz on 8/22/13.
//  Copyright (c) 2013 RokkinCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MockeryHTTPURLResponse : NSHTTPURLResponse

@property (nonatomic, strong) NSData *data;

+ (id)mockeryWithURL:(NSURL *)url statusCode:(NSInteger)statusCode data:(NSData*)data headerFields:(NSDictionary *)headerFields;
- (id)initWithURL:(NSURL *)url statusCode:(NSInteger)statusCode data:(NSData*)data headerFields:(NSDictionary *)headerFields;

@end
