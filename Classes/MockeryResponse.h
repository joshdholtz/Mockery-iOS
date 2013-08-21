//
//  MockeryResponse.h
//  Mockery
//
//  Created by Josh Holtz on 8/21/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MockeryResponse : NSObject

@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) NSInteger status;

- (id)initWithStatus:(NSInteger)status data:(NSData*)data;

@end
