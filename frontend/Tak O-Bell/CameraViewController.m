//
//  CameraViewController.m
//  Tak O-Bell
//
//  Created by Brian Quach on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import "CameraViewController.h"
#import "TakoAPIClient.h"
#import "RestrictedMenuViewController.h"

@interface CameraViewController ()

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIButton *takePictureButton;
@property (nonatomic, weak) IBOutlet UIButton *returnToPreferencesButton;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property BOOL showImagePicker;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showImagePicker = YES;
    [self.view setBackgroundColor:[UIColor clearColor]];
//        [self setModalPresentationStyle:UIModalPresentationFullScreen];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        imagePickerController.showsCameraControls = NO;

        // Device's screen size (ignoring rotation intentionally):
//        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        // iOS is going to calculate a size which constrains the 4:3 aspect ratio
        // to the screen size. We're basically mimicking that here to determine
        // what size the system will likely display the image at on screen.
        // NOTE: screenSize.width may seem odd in this calculation - but, remember,
        // the devices only take 4:3 images when they are oriented *sideways*.
        CGFloat cameraAspectRatio = 4.0f / 3.0f;
//        CGFloat imageWidth = floorf(screenSize.width * cameraAspectRatio);
//        CGFloat scale = ceilf((screenSize.height / imageWidth) * 10.0) / 10.0;
        
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 71.0); //This slots the preview exactly in the middle of the screen by moving it down 71 points
        imagePickerController.cameraViewTransform = translate;
        
        CGAffineTransform scale = CGAffineTransformScale(translate, cameraAspectRatio, cameraAspectRatio);
        imagePickerController.cameraViewTransform = scale;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
        self.takePictureButton.layer.cornerRadius = self.takePictureButton.frame.size.height / 2;
        self.returnToPreferencesButton.layer.cornerRadius = self.returnToPreferencesButton.frame.size.height / 2;
        self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
        imagePickerController.cameraOverlayView = self.overlayView;
        self.overlayView = nil;
    }
    
    self.imagePickerController = imagePickerController;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.showImagePicker) {
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
//    if (self.isExiting) { // lol
////        [self dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        [self presentViewController:self.imagePickerController animated:YES completion:nil];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePictureButtonPressed:(id)sender {
    [self.imagePickerController takePicture];
}

- (IBAction)returnToPreferencesButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage *resizedImage = [self imageWithImage:image convertToSize:CGSizeMake(image.size.width/3, image.size.height/3)];
    NSLog(@"Image dimensions are %f x %f", resizedImage.size.width, resizedImage.size.height);
    NSLog(@"Our dietary preferences: %@", self.unwantedIngredientList);
//    UIAlertController *uploadingImageController = [UIAlertController alertControllerWithTitle:@"orz" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [[[TakoAPIClient sharedClient] getRestrictedVersionOfMenu:image dietaryPreferences:@{@"moo":@"moo"}] continueWithBlock:^id(BFTask *task) {
//        [uploadingImageController dismissViewControllerAnimated:YES completion:nil];
        
        if (task.error) {
            NSLog(@"Result is %@", task.error);
            return nil;
        }
        
        NSLog(@"Result is %@", task.result);
        UIImage *restrictedMenuImage = task.result;
        self.showImagePicker = NO;
        [self dismissViewControllerAnimated:YES completion:^{
            RestrictedMenuViewController *restrictedMenuViewController = [[RestrictedMenuViewController alloc] initWithNibName:@"RestrictedMenuView" bundle:nil];
            [self presentViewController:restrictedMenuViewController animated:YES completion:^{
                restrictedMenuViewController.restrictedMenuImageView.image = restrictedMenuImage;
                self.showImagePicker = YES;
            }];
        }];
        return nil;
    }];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}
@end
