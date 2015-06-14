//
//  IngredientSelectionContainerViewController.h
//  Tak O-Bell
//
//  Created by Brian Quach on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IngredientsList.h"
#import "Ingredient.h"

@interface IngredientSelectionContainerViewController : UIViewController

@property (nonatomic, strong) IngredientsList *ingredientsList;

- (void)setSelectedIngredient:(Ingredient *)unwanted atPoint:(CGPoint)point;
@end
