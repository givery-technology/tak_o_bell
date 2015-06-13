//
//  TakoAPIClient.h
//  Tak O-Bell
//
//  Created by Brian Quach on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface TakoAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
