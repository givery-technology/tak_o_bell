//
//  IngredientCollectionViewCell.m
//  Tak O-Bell
//
//  Created by Albert Le on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import "IngredientCollectionViewCell.h"

@interface IngredientCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *ingredientImage;

@end


@implementation IngredientCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"IngredientCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
}

-(void)updateCell {
    
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Assets"];
    NSString *filename = [NSString stringWithFormat:@"%@/%@", sourcePath, self.imageName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:filename];
    
    [self.ingredientImage setImage:image];
    [self.ingredientImage setContentMode:UIViewContentModeScaleAspectFit];
    
}

@end
