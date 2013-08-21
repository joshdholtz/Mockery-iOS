//
//  MockeryResponse.m
//  Mockery
//
//  Created by Josh Holtz on 8/21/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import "MockeryResponse.h"

@implementation MockeryResponse

- (id)initWithStatus:(NSInteger)status data:(NSData *)data {
    self = [super init];
    if (self) {
        _status = status;
        _data = data;
    }
    return self;
}

@end
