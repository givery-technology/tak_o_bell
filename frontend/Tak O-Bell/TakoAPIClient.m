//
//  TakoAPIClient.m
//  Tak O-Bell
//
//  Created by Brian Quach on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import "TakoAPIClient.h"

@implementation TakoAPIClient

+ (instancetype)sharedClient {
    static TakoAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[TakoAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://121.94.171.205"]];
    });
    return sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFImageResponseSerializer serializer];
    }
    return self;
}

- (BFTask *)getRestrictedVersionOfMenu:(UIImage *)menuImage dietaryPreferences:(NSDictionary *)dietaryPreferences {
    NSData *menuImageData = [NSData dataWithData:UIImageJPEGRepresentation(menuImage, 1.0f)];
    NSDictionary *parameters = dietaryPreferences;
    NSLog(@"Parameters: %@", parameters);
    BFTaskCompletionSource *t = [BFTaskCompletionSource taskCompletionSource];
    [self POST:@"/test" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:menuImageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        [t setResult:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        [t setError:error];
    }];
    return t.task;
}

@end
