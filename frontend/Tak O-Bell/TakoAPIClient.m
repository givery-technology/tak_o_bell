//
//  TakoAPIClient.m
//  Tak O-Bell
//
//  Created by Brian Quach on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import "TakoAPIClient.h"
#import <Bolts.h>

@implementation TakoAPIClient

+ (instancetype)sharedClient {
    static TakoAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[TakoAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    });
    return sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

- (BFTask *)sendMenu:(UIImage *)menuImage dietaryPreferences:(NSDictionary *)dietaryPreferences {
    NSData *menuImageData = [NSData dataWithData:UIImageJPEGRepresentation(menuImage, 1.0f)];
    BFTaskCompletionSource *t = [BFTaskCompletionSource taskCompletionSource];
    [self POST:@"aaa" parameters:dietaryPreferences constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:menuImageData name:@"menu_image" fileName:@"menu_image.jpg" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [t setResult:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [t setError:error];
    }];
    return t.task;
}

@end
