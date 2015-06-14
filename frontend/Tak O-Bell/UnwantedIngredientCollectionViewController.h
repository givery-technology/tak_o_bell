//
//  UnwantedIngredientCollectionViewController.h
//  Tak O-Bell
//
//  Created by Albert Le on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IngredientsList.h"
#import "IngredientSelectionContainerViewController.h"

@interface UnwantedIngredientCollectionViewController : UICollectionViewController


- (void)addIngredient:(Ingredient *)unwanted;
@property (nonatomic, strong) IngredientsList *ingredientsList;
@property (nonatomic, strong) IngredientSelectionContainerViewController *parent;
- (void)cellDragCompleteWithModelForUnwanted:(Ingredient *)unwanted withValidDropPoint:(BOOL)validDropPoint;
@end
