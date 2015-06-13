//
//  IngredientsList.m
//  Tak O-Bell
//
//  Created by Brian Quach on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import "IngredientsList.h"
#import "Ingredient.h"

NSString * const kUnwantedIngredientsKey = @"UnwantedIngredients";

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

- (BFTask *)getUnwatedIngredients {
    BFTaskCompletionSource *t = [BFTaskCompletionSource taskCompletionSource];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.unwantedIngredients = [userDefaults objectForKey:kUnwantedIngredientsKey];
    return t.task;
}

- (BFTask *)saveUnwantedIngredients {
    BFTaskCompletionSource *t = [BFTaskCompletionSource taskCompletionSource];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.unwantedIngredients forKey:kUnwantedIngredientsKey];
    [t setResult:@([userDefaults synchronize])];
    return t.task;
}

@end
