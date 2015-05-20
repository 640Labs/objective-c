/**
 @author Sergey Mamontov
 @since 4.0
 @copyright © 2009-2015 PubNub, Inc.
 */
#import "PNResult+Private.h"
#import "PNRequest+Private.h"
#import "PNPrivateStructures.h"
#import "PNResponse.h"
#import "PNStatus.h"
#import "PNJSON.h"


#pragma mark Interface implementation

@implementation PNResult


#pragma mark - Initialization and configuration

+ (instancetype)resultForRequest:(PNRequest *)request {
    
    return [[self alloc] initForRequest:request];
}

+ (instancetype)resultFromStatus:(PNStatus *)status withData:(id)data {
    
    // Create result object based on status with new pre-processed data.
    PNResult *result = [self new];
    result->_clientRequest = [status.clientRequest copy];
    result->_response = [status.response copy];
    result->_origin = [status.origin copy];
    result->_statusCode = status.statusCode;
    result->_operation = status.operation;
    result->_data = [data copy];
    
    return result;
}

- (instancetype)initForRequest:(PNRequest *)request {
    
    // Check whether initialization has been successful or not
    if ((self = [super init])) {

        self.requestObject = request;

        self.clientRequest = request.response.clientRequest;
        self.response = request.response.serviceResponse;
        self.statusCode = (request.response.response ? request.response.response.statusCode : 200);
        self.operation = request.operation;
        self.origin = [[_clientRequest URL] host];

        // Call parse block which has been passed by calling API to pre-process
        // received data before returning it to te user.
        if (self.response) {
            
            if (self.requestObject.parseBlock) {
                
                self.data = (self.requestObject.parseBlock(request.response.data)?:
                             [self dataParsedAsError:request.response.data]);
            }
            else {
                
                self.data = [self dataParsedAsError:request.response.data];
            }
        }
    }
    
    return self;
}

- (instancetype)copyWithData:(id)data {
    
    PNResult *result = [[self class] resultForRequest:self.requestObject];
    result->_data = [data copy];
    
    return result;
}


#pragma mark - Processing

- (NSDictionary *)dataParsedAsError:(id <NSObject, NSCopying>)data {
    
    NSMutableDictionary *errorData = nil;
    if ([data isKindOfClass:[NSDictionary class]]) {
        
        errorData = [NSMutableDictionary new];
        if (data[@"message"]) {
            
            errorData[@"information"] = data[@"message"];
        }
        else if (data[@"error"]) {
            
            errorData[@"information"] = data[@"error"];
        }
        if (data[@"payload"]) {
            
            if (data[@"payload"][@"channels"]) {
                
                errorData[@"channels"] = data[@"payload"][@"channels"];
            }
            if (data[@"payload"][@"channel-groups"]) {
                
                errorData[@"channel-groups"] = data[@"payload"][@"channel-groups"];
            }
            if (!errorData[@"channels"] && !errorData[@"channel-groups"]) {
                
                errorData[@"data"] = data[@"payload"];
            }
        }
    }
    
    return [errorData copy];
}


#pragma mark - Misc

- (NSDictionary *)dictionaryRepresentation {
    
    return @{@"Operation": PNOperationTypeStrings[[self operation]],
             @"Request": @{@"Method": (self.clientRequest.HTTPMethod?: @"GET"),
                           @"URL": ([self.clientRequest.URL absoluteString]?: @"null"),
                           @"POST Body size": @([self.clientRequest.HTTPBody length]),
                           @"Origin": (self.origin?: @"unknown")},
             @"Response": @{@"Status code": @(self.statusCode),
                            @"Raw data": (self.response?: @"no response"),
                            @"Processed data": (self.data?: @"no data")}};
}

- (NSString *)stringifiedRepresentation {
    
    return [PNJSON JSONStringFrom:[self dictionaryRepresentation] withError:NULL];
}

- (NSString *)debugDescription {
    
    return [[self dictionaryRepresentation] description];
}

#pragma mark -


@end
