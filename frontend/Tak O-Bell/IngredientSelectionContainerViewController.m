//
//  IngredientSelectionContainerViewController.m
//  Tak O-Bell
//
//  Created by Brian Quach on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import "IngredientSelectionContainerViewController.h"
#import "IngredientListCollectionViewController.h"
#import "UnwantedIngredientCollectionViewController.h"
#import "CameraViewController.h"
#import "IngredientCollectionViewCell.h"

@interface IngredientSelectionContainerViewController ()<UIGestureRecognizerDelegate> {
    UIView *cell;
    Ingredient *ingredient;
}

@property (weak, nonatomic) IBOutlet UIView *unwantedViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) IngredientListCollectionViewController *ingredientListViewController;
@property (nonatomic, weak) UnwantedIngredientCollectionViewController *unwantedIngredientListViewController;
@property (weak, nonatomic) IBOutlet UIView *unwantedContainer;
@property (weak, nonatomic) IBOutlet UIView *unwantedBackground;
@property (weak, nonatomic) IBOutlet UIView *tempCell;
@property (weak, nonatomic) IBOutlet UILabel *tempCelName;
@property (weak, nonatomic) IBOutlet UIImageView *tempCellImage;

@end

@implementation IngredientSelectionContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ingredientsList = [[IngredientsList alloc] init];
    [[self.nextButton layer] setBorderWidth:2.0f];
    [[self.nextButton layer] setCornerRadius:10];
    [[self.nextButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    

    [[self.unwantedBackground layer] setBorderWidth: 0.0f];
    [[self.unwantedBackground layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [[self.unwantedBackground layer] setCornerRadius:10];
    self.unwantedIngredientListViewController.collectionView.backgroundColor = [UIColor clearColor];
    self.unwantedIngredientListViewController.collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIPanGestureRecognizer *panGesture =
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
    
    cell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 140)];
    cell.hidden = YES;
    cell.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:cell];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelectedIngredient:(Ingredient *)unwanted atPoint:(CGPoint)point {
    ingredient = unwanted;
    
    if (ingredient != nil) {
        //cell.ingredientName.text = [NSString stringWithFormat:@"%@", ingredient.name];
        cell.center = point;
        cell.hidden = NO;
        
        [self updateCellViewDragState:[self isValidDragPoint:point]];
    } else {
        cell.hidden = YES;
    }
}

#pragma mark - Validation helper methods on drag and drop
- (BOOL)isValidDragPoint:(CGPoint)point {
    return !CGRectContainsPoint(self.ingredientListViewController.collectionView.frame, point);
}

- (void)updateCellViewDragState:(BOOL)validDropPoint {
    if (validDropPoint) {
        cell.alpha = 1.0f;
    } else {
        cell.alpha = 0.2f;
    }
}

- (void)initDraggedCardView {
    cell = [[IngredientCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 120, 140)];
    cell.hidden = YES;
    //cell.highlighted = YES;
    [self.view addSubview:cell];
}


#pragma mark - Pan Gesture Recognizers/delegate
- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self.view];
    if (gesture.state == UIGestureRecognizerStateChanged
        && !cell.hidden) {
        cell.center = touchPoint;
        [self updateCellViewDragState:[self isValidDragPoint:touchPoint]];
    } else if (gesture.state == UIGestureRecognizerStateRecognized
               && ingredient != nil) {
        cell.hidden = YES;
        
        BOOL validDropPoint = [self isValidDragPoint:touchPoint];
        [self.ingredientListViewController cellDragCompleteWithModel:ingredient withValidDropPoint:validDropPoint];
        if (validDropPoint) {
            [self.unwantedIngredientListViewController addIngredient:ingredient];
        }
        ingredient = nil;
    }
}
#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    
    if ([segueName isEqualToString:@"embedIngredientList"]) {//embedUnwantedIngredientList
        NSLog(@"meow");
        self.ingredientListViewController = (IngredientListCollectionViewController *)segue.destinationViewController;
        self.ingredientListViewController.ingredientsList = self.ingredientsList;
        self.ingredientListViewController.parent = self;
    } else if ([segueName isEqualToString:@"embedUnwantedIngredientList"]) {
        NSLog(@"woof");
        self.unwantedIngredientListViewController = (UnwantedIngredientCollectionViewController *)segue.destinationViewController;
        self.unwantedIngredientListViewController.ingredientsList = self.ingredientsList;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma  mark - IBAction

- (IBAction)didTapNext:(id)sender {
    CameraViewController *cameraViewController = [[CameraViewController alloc] init];
    [self.navigationController pushViewController:cameraViewController animated:YES];
}


@end
