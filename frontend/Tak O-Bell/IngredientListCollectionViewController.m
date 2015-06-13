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

@interface IngredientListCollectionViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation IngredientListCollectionViewController

static NSString * const reuseIdentifier = @"IngredientCell";

- (void)viewDidLoad {
    NSLog(@"vdl1");
    [super viewDidLoad];
    [self setupCollectionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.ingredientsList = [(IngredientSelectionContainerViewController *)self.parentViewController ingredientsList];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRemoveUnwanted) name:@"UnwantedRemoved" object:nil];
//    
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//
//    [self.collectionView setPagingEnabled:YES];
//    [self.collectionView setCollectionViewLayout:flowLayout];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Ingredient *unwanted = self.ingredientsList.allIngredients[indexPath.row];
    [self.ingredientsList.allIngredients removeObjectAtIndex:indexPath.row];
    [self.ingredientsList.unwantedIngredients addObject:unwanted];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnwantedAdded" object:self];
    [self.collectionView reloadData];

}

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
