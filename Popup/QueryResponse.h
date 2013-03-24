//
//  QueryResponse.h
//  Notifier
//
//  Created by Nick Merrill on 3/23/13.
//
//

#import <Foundation/Foundation.h>

@interface QueryResponse : NSObject

+ (NSError *)queryUrlWithString:(NSString *)urlString;

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSString *dataString;

@end
