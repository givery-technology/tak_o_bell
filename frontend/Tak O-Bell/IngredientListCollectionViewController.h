//
//  IngredientListCollectionViewController.h
//  Tak O-Bell
//
//  Created by Albert Le on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IngredientsList.h"

@interface IngredientListCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) IngredientsList *ingredientsList;

@end
