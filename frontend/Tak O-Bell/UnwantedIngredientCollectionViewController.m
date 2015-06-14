//
//  UnwantedIngredientCollectionViewController.m
//  Tak O-Bell
//
//  Created by Albert Le on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import "Ingredient.h"
#import "IngredientCollectionViewCell.h"
#import "UnwantedIngredientCollectionViewController.h"
#import "IngredientSelectionContainerViewController.h"

@interface UnwantedIngredientCollectionViewController () {
    NSMutableArray *ingredientList;
    Ingredient *ingredient;
}

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation UnwantedIngredientCollectionViewController

static NSString * const reuseIdentifier = @"IngredientCell";

- (void)viewDidLoad {
    NSLog(@"vdl2");
    [super viewDidLoad];
    [self setupCollectionView];
    [self setUpGestures];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.ingredientsList = [(IngredientSelectionContainerViewController *)self.parentViewController ingredientsList];
    ingredientList = self.ingredientsList.unwantedIngredients;
    [self.collectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadImages {
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Assets"];
    self.dataArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath error:NULL];
}

-(void)setupCollectionView {
//    self.ingredientsList = [[IngredientsList alloc] init];
    
    UINib *ingredientCell = [UINib nibWithNibName:@"IngredientCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:ingredientCell forCellWithReuseIdentifier:reuseIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAddedUnwanted) name:@"UnwantedAdded" object:nil];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setSectionInset:UIEdgeInsetsMake(20, 40, 20, 40)];
    [self.collectionView setCollectionViewLayout:flowLayout];
}

- (void)addIngredient:(Ingredient *)unwanted {
    [self.ingredientsList.unwantedIngredients addObject:unwanted];
    
    [self.collectionView reloadData];
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.ingredientsList.unwantedIngredients.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IngredientCollectionViewCell *cell = (IngredientCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Ingredient *ingredient =  self.ingredientsList.unwantedIngredients[indexPath.row];
    cell.ingredientName.text = ingredient.name;
    cell.ingredientImage.image = ingredient.image;
    //cell.frame = CGRectMake(20, 20, 100, 100);
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 5, 20, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(90, 90);
}


//#pragma mark <UICollectionViewDelegate>
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    Ingredient *unwanted = self.ingredientsList.unwantedIngredients[indexPath.row];
//    [self.ingredientsList.unwantedIngredients removeObjectAtIndex:indexPath.row];
//    [self.ingredientsList.allIngredients addObject:unwanted];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnwantedRemoved" object:self];
//    [self.collectionView reloadData];
//}

#pragma mark NSNotication

- (void)userAddedUnwanted {
    [self.collectionView reloadData];
}

- (void)setUpGestures {
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(handlePress:)];
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.minimumPressDuration    = 0.1f;
    [self.collectionView addGestureRecognizer:longPressGesture];
}


- (void)cellDragCompleteWithModelForUnwanted:(Ingredient *)unwanted withValidDropPoint:(BOOL)validDropPoint {
    if (unwanted != nil) {
        // get indexPath for the model
        NSUInteger index = [ingredientList indexOfObject:unwanted];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        ingredientList = self.ingredientsList.unwantedIngredients;
        if (validDropPoint && indexPath != nil) {
            [ingredientList removeObjectAtIndex:index];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            
            [self.collectionView reloadData];
        } else {
            
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            cell.alpha = 1.0f;
        }
    }
}

#pragma mark - Gesture Recognizer
- (void)handlePress:(UILongPressGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.collectionView];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        if (indexPath != nil) {
            ingredient = [ingredientList objectAtIndex:indexPath.item];
            
            // calculate point in parent view
            point = [gesture locationInView:self.parent.view];
            
            [self.parent setSelectedIngredient:ingredient atPoint:point];
            
            // hide the cell
            [self.collectionView cellForItemAtIndexPath:indexPath].alpha = 0.0f;
        }
    }
}

@end
