//
//  IngredientsList.m
//  Tak O-Bell
//
//  Created by Brian Quach on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import "IngredientsList.h"
#import "Ingredient.h"

@implementation IngredientsList

- (instancetype)init {
    self = [super init];
    if (self) {
        _allIngredients = @[[Ingredient ingredientWithName:@"Fish" image:[UIImage imageNamed:@""]],
                            [Ingredient ingredientWithName:@"Peanuts" image:[UIImage imageNamed:@""]],
                            [Ingredient ingredientWithName:@"Pork" image:[UIImage imageNamed:@""]],
                            [Ingredient ingredientWithName:@"Caffeine" image:[UIImage imageNamed:@""]],
                            [Ingredient ingredientWithName:@"Gluten" image:[UIImage imageNamed:@""]]];
        _unwantedIngredients = [[NSMutableSet alloc] init];
    }
    return self;
}

- (BFTask *)saveUnwantedIngredients {
    return nil;
}

@end
