//
//  CameraViewController.m
//  Tak O-Bell
//
//  Created by Brian Quach on 2015-06-13.
//  Copyright (c) 2015 Tak O-Bell. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIButton *takePictureButton;
@property (nonatomic, weak) IBOutlet UIButton *returnToPreferencesButton;
@property (nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
        [self setModalPresentationStyle:UIModalPresentationFullScreen];
    
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
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)takePictureButtonPressed:(id)sender {
    [self.imagePickerController takePicture];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
}

@end
