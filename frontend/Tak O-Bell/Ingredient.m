//
//  Ingredient.m
//  Tak O-Bell
//
//  Created by Brian Quach on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import "Ingredient.h"

@implementation Ingredient

- (instancetype)initWithName:(NSString *)name image:(UIImage *)image {
    self = [super init];
    if (self) {
        if (name.length) {
            _name = name;
        }
        
        if (image) {
            _image = image;
        }
    }
    return self;
}

+ (instancetype)ingredientWithName:(NSString *)name image:(UIImage *)image {
    return [[self alloc] initWithName:name image:image];
}


@end
