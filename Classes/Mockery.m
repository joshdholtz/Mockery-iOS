//
//  Mockery.m
//  Mockery
//
//  Created by Josh Holtz on 8/21/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import "Mockery.h"

#import "MockeryURLProtocol.h"

@interface Mockery()

@property (nonatomic, strong) NSString *urlPrefix;

@property (nonatomic, strong) NSMutableDictionary *mockResponsesGET;
@property (nonatomic, strong) NSMutableDictionary *mockResponsesPOST;
@property (nonatomic, strong) NSMutableDictionary *mockResponsesPUT;
@property (nonatomic, strong) NSMutableDictionary *mockResponsesDELETE;

@end

@implementation Mockery

static Mockery *sharedInstance = nil;

+ (Mockery *)mockeryWithURL:(NSString*)urlPrefix {
    
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] initWithURL:urlPrefix];
        
    }
    
    [NSURLProtocol registerClass:[MockeryURLProtocol class]];
    
    return sharedInstance;
}

+ (NSString *)urlPrefix {
    return sharedInstance.urlPrefix;
}

+ (MockeryResponse*)get:(NSURLRequest *)request {
    return [sharedInstance findRoute:request withMockResponse:sharedInstance.mockResponsesGET];
}

+ (void)get:(id)pathStringOrRegex block:(ResponseBlock)responseBlock {
    [sharedInstance.mockResponsesGET setObject:[responseBlock copy] forKey:pathStringOrRegex];
}

- (id)initWithURL:(NSString*)urlPrefix
{
    self = [super init];
    
    if (self) {
        _urlPrefix = urlPrefix;
        
        _mockResponsesGET = [NSMutableDictionary dictionary];
        _mockResponsesPOST = [NSMutableDictionary dictionary];
        _mockResponsesPUT = [NSMutableDictionary dictionary];
        _mockResponsesDELETE = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (MockeryResponse*)findRoute:(NSURLRequest *)request withMockResponse:(NSDictionary*)actionMockResponses {
    
    NSString *pathString = [[request URL] absoluteString];
    NSString *route = [pathString stringByReplacingOccurrencesOfString:[Mockery urlPrefix] withString:@""];
    
    if ([actionMockResponses objectForKey:route]) {
        
        ResponseBlock mockeryBlock = [actionMockResponses objectForKey:route];
        return mockeryBlock(pathString, request, nil);
        
    } else {
        
        for (id key in [actionMockResponses allKeys]) {
            
            if ([key isKindOfClass:[NSRegularExpression class]]) {
                NSRegularExpression *regEx = key;
                
                NSRange rangeOfFirstMatch = [regEx rangeOfFirstMatchInString:route options:0 range:NSMakeRange(0, [route length])];
                if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
                    NSArray *matches = [regEx matchesInString:route options:0 range:NSMakeRange(0, [route length])];
                    NSMutableArray *params = [NSMutableArray array];
                    for (NSTextCheckingResult *match in matches) {
                        NSLog(@"Number - %d", [match numberOfRanges]);
                        
                        for (int i = 1; i < match.numberOfRanges; ++i) {
                            [params addObject:[route substringWithRange:[match rangeAtIndex:i]]];
                        }
                        
                    }
                    
                    ResponseBlock mockeryBlock = [actionMockResponses objectForKey:key];
                    MockeryResponse *mockeryResponse = mockeryBlock(pathString, request, params);
                    
                    return mockeryResponse;
                }
            }
            
        }
        
    }
    
    return [[MockeryResponse alloc] initWithStatus:404 data:nil];;
    
}


@end
