//
//  IngredientsList.h
//  Tak O-Bell
//
//  Created by Brian Quach on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts.h>

extern NSString * const kUnwantedIngredientsKey;

@interface IngredientsList : NSObject

@property (nonatomic, readonly, strong) NSMutableArray *allIngredients;
@property (nonatomic, strong) NSMutableSet *unwantedIngredients;

- (BFTask *)getUnwatedIngredients;
- (BFTask *)saveUnwantedIngredients;

@end
