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

@interface IngredientSelectionContainerViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, weak) IngredientListCollectionViewController *ingredientListViewController;
@property (nonatomic, weak) UnwantedIngredientCollectionViewController *unwantedIngredientListViewController;

@end

@implementation IngredientSelectionContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ingredientsList = [[IngredientsList alloc] init];
    [[self.nextButton layer] setBorderWidth:2.0f];
    [[self.nextButton layer] setCornerRadius:10];
    [[self.nextButton layer] setBorderColor:[UIColor whiteColor].CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    
    if ([segueName isEqualToString:@"embedIngredientList"]) {//embedUnwantedIngredientList
        NSLog(@"meow");
        self.ingredientListViewController = (IngredientListCollectionViewController *)segue.destinationViewController;
        self.ingredientListViewController.ingredientsList = self.ingredientsList;
    } else if ([segueName isEqualToString:@"embedUnwantedIngredientList"]) {
        NSLog(@"woof");
        self.unwantedIngredientListViewController = (UnwantedIngredientCollectionViewController *)segue.destinationViewController;
        self.unwantedIngredientListViewController.ingredientsList = self.ingredientsList;
    }
}

#pragma  mark - IBAction

- (IBAction)didTapNext:(id)sender {
    CameraViewController *cameraViewController = [[CameraViewController alloc] init];
    [self.navigationController pushViewController:cameraViewController animated:YES];
}


@end
