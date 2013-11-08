//
//  QueryResponse.m
//  Notifier
//
//  Created by Nick Merrill on 3/23/13.
//
//

#import "QueryResponse.h"

@implementation QueryResponse

@synthesize error = _error;
@synthesize dataString = _dataString;


+ (QueryResponse *)queryUrlWithString:(NSString *)urlString {
    QueryResponse *queryResponse = [QueryResponse alloc];
    
    NSError *connectionError = nil;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLResponse *response = nil;
    
    NSURLRequest *request= [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&connectionError];
    
    queryResponse.error = connectionError;
    queryResponse.dataString  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];;
    
    return queryResponse;
}


@end
