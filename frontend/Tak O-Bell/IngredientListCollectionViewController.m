//
//  IngredientListCollectionViewController.m
//  Tak O-Bell
//
//  Created by Albert Le on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//


#import "Ingredient.h"
#import "IngredientCollectionViewCell.h"
#import "IngredientListCollectionViewController.h"
#import "IngredientSelectionContainerViewController.h"

@interface IngredientListCollectionViewController () {
    NSMutableArray *ingredientList;
    Ingredient *ingredient;
}

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation IngredientListCollectionViewController


static NSString * const reuseIdentifier = @"IngredientCell";
- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpGestures];
    [self setupCollectionView];
    [self setupIngredients];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.ingredientsList = [(IngredientSelectionContainerViewController *)self.parentViewController ingredientsList];
    ingredientList = [NSMutableArray array];
    ingredientList = self.ingredientsList.allIngredients;
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

- (void)setupIngredients {

    
}

-(void)setupCollectionView {
//    self.ingredientsList = [[IngredientsList alloc] init];
    UINib *ingredientCell = [UINib nibWithNibName:@"IngredientCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:ingredientCell forCellWithReuseIdentifier:reuseIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRemoveUnwanted) name:@"UnwantedRemoved" object:nil];
//    
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//
//    [self.collectionView setPagingEnabled:YES];
//    [self.collectionView setCollectionViewLayout:flowLayout];
}

- (void)setUpGestures {
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(handlePress:)];
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.minimumPressDuration    = 0.1f;
    [self.collectionView addGestureRecognizer:longPressGesture];
}


- (void)cellDragCompleteWithModel:(Ingredient *)unwanted withValidDropPoint:(BOOL)validDropPoint {
    if (unwanted != nil) {
        // get indexPath for the model
        NSUInteger index = [ingredientList indexOfObject:unwanted];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        ingredientList = self.ingredientsList.allIngredients;
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.ingredientsList.allIngredients.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    IngredientCollectionViewCell *cell = (IngredientCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Ingredient *ingredient =  self.ingredientsList.allIngredients[indexPath.row];
    cell.ingredientName.text = ingredient.name;
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

#pragma mark <UICollectionViewDelegate>

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    Ingredient *unwanted = self.ingredientsList.allIngredients[indexPath.row];
//    [self.ingredientsList.allIngredients removeObjectAtIndex:indexPath.row];
//    [self.ingredientsList.unwantedIngredients addObject:unwanted];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnwantedAdded" object:self];
//    [self.collectionView reloadData];
//
//}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma  mark NSNotification

- (void)userRemoveUnwanted {
    [self.collectionView reloadData];
}

@end
