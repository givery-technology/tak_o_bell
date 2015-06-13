//
//  Ingredient.h
//  Tak O-Bell
//
//  Created by Brian Quach on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Ingredient : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithName:(NSString *)name image:(UIImage *)image;
+ (instancetype)ingredientWithName:(NSString *)name image:(UIImage *)image;
    
@end
