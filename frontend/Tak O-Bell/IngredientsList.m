//
//  IngredientsList.m
//  Tak O-Bell
//
//  Created by Brian Quach on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import "IngredientsList.h"
#import "Ingredient.h"

NSString * const kWantedIngredientsKey = @"WantedIngredients";
NSString * const kUnwantedIngredientsKey = @"UnwantedIngredients";

@implementation IngredientsList

- (instancetype)init {
    self = [super init];
    if (self) {
        _allIngredients = [NSMutableArray arrayWithArray:@[[Ingredient ingredientWithName:@"Chicken" image:[UIImage imageNamed:@"chicken"]],
                                                           [Ingredient ingredientWithName:@"Beef" image:[UIImage imageNamed:@"beef"]],
                                                           [Ingredient ingredientWithName:@"Pork" image:[UIImage imageNamed:@"pork"]],
                                                           [Ingredient ingredientWithName:@"Egg" image:[UIImage imageNamed:@"egg"]],
                                                           [Ingredient ingredientWithName:@"Wheat" image:[UIImage imageNamed:@"wheat"]],
                                                           [Ingredient ingredientWithName:@"Mushroom" image:[UIImage imageNamed:@"mushroom"]],
                                                           [Ingredient ingredientWithName:@"Tomato" image:[UIImage imageNamed:@"tomato"]],
                                                           [Ingredient ingredientWithName:@"Soba" image:[UIImage imageNamed:@"soba"]],
                                                           [Ingredient ingredientWithName:@"Milk" image:[UIImage imageNamed:@"milk"]]]];
        _unwantedIngredients = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BFTask *)getUnwatedIngredients {
    BFTaskCompletionSource *t = [BFTaskCompletionSource taskCompletionSource];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *savedListOfUnwantedIngredients = [userDefaults objectForKey:kUnwantedIngredientsKey];
    [self.unwantedIngredients removeAllObjects];
    for (NSString *ingredientName in savedListOfUnwantedIngredients) {
        [self.unwantedIngredients addObject:[Ingredient ingredientWithName:ingredientName image:[UIImage imageNamed:@""]]];
    }
    return t.task;
}

- (BFTask *)getAllIngredients {
    BFTaskCompletionSource *t = [BFTaskCompletionSource taskCompletionSource];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSArray *savedListofAllIngredients = [userDefaults objectForKey:kWantedIngredientsKey];
//    [self.allIngredients removeAllObjects];
//    for (NSString *ingredientName in savedListofAllIngredients) {
//        [self.allIngredients addObject:[Ingredient ingredientWithName:ingredientName image:[UIImage imageNamed:@""]]];
//    }
    return t.task;
}
         
- (BFTask *)saveAllIngredients {
    BFTaskCompletionSource *t = [BFTaskCompletionSource taskCompletionSource];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *listOfAllIngredients = [[NSMutableArray alloc] init];
    int counter = 0;
    for (Ingredient *ingredient in self.allIngredients) {
        [listOfAllIngredients addObject:ingredient.name];
        counter ++;
    }
    NSLog(@"saveAllIngredients saved %d ingredients", counter);
    [userDefaults setObject:listOfAllIngredients forKey:kWantedIngredientsKey];
    [t setResult:@([userDefaults synchronize])];
    return t.task;
}

//- (BFTask *)saveCurrentIngredients {
//    BFTaskCompletionSource *t = [BFTaskCompletionSource taskCompletionSource];
//    
//    return t.task;
//}

- (BFTask *)saveUnwantedIngredients {
    BFTaskCompletionSource *t = [BFTaskCompletionSource taskCompletionSource];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *listOfUnwantedIngredients = [[NSMutableArray alloc] init];;
    for (Ingredient *ingredient in self.unwantedIngredients) {
        [listOfUnwantedIngredients addObject:ingredient.name];
    }
    [userDefaults setObject:listOfUnwantedIngredients forKey:kUnwantedIngredientsKey];
    [t setResult:@([userDefaults synchronize])];
    return t.task;
}

@end
