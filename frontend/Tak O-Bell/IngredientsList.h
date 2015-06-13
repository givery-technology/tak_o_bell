//
//  IngredientsList.h
//  Tak O-Bell
//
//  Created by Brian Quach on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts.h>

@interface IngredientsList : NSObject

@property (nonatomic, readonly, strong) NSArray *allIngredients;
@property (nonatomic, strong) NSMutableSet *unwantedIngredients;

- (BFTask *)saveUnwantedIngredients;

@end