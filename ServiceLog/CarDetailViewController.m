//
//  CarDetailViewController.m
//  ServiceLog
//
//  Created by Mark Adams on 1/18/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "CarDetailViewController.h"
#import "Car.h"
#import "Car+Helpers.h"
#import "IAActionSheet.h"
#import "UIImage+ProportionalFill.h"
#import "PhotoViewerViewController.h"

@interface CarDetailViewController ()

@property (strong, nonatomic) IBOutlet UIView *vehicleView;
@property (strong, nonatomic) IBOutlet UIImageView *vehicleImageView;
@property (strong, nonatomic) IBOutlet UILabel *vehicleLabel;
@property (strong, nonatomic) IBOutlet UIView *editPhotoView;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) UIView *savingPhotoView;
@property (strong, nonatomic) IBOutlet UITextField *vinTextField;

- (IBAction)imageViewTapped:(id)sender;

- (void)viewPhoto;
- (void)editPhoto;
- (void)showCameraRoll;
- (void)showCamera;
- (void)showOptionsForPhotoSelection;

@end

#pragma mark -

@implementation CarDetailViewController

@synthesize car;

@synthesize vehicleView;
@synthesize vehicleImageView;
@synthesize vehicleLabel;
@synthesize editPhotoView;
@synthesize imagePickerController;
@synthesize savingPhotoView;
@synthesize vinTextField;

#pragma mark - Getters
- (UIImagePickerController *)imagePickerController
{
    if (!imagePickerController)
    {
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
    }
    
    return imagePickerController;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.car.makeAndModel;
    self.vehicleImageView.image = [UIImage imageWithData:self.car.thumbnail];
    self.vehicleLabel.text = self.car.makeAndModel;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.vehicleView.layer.cornerRadius = 4.0;
    self.vehicleView.layer.borderColor = [UIColor colorWithWhite:0.0f alpha:0.35f].CGColor;
    self.vehicleView.layer.borderWidth = 1.0f;
    self.vehicleView.layer.masksToBounds = YES;
}

#pragma mark - UIViewController Overrides
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.editPhotoView.alpha = (editing) ? 1.0f : 0.0f;
    }];
    
    self.vinTextField.enabled = editing;
    [self.vinTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    self.imagePickerController = nil;
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowVehiclePhoto"])
    {
        PhotoViewerViewController *pvvc = segue.destinationViewController;
        pvvc.image = [[UIImage alloc] initWithData:self.car.fullImage];
    }
}

#pragma mark - Interface Actions
- (IBAction)imageViewTapped:(id)sender
{
    if (self.editing)
    {
        [self editPhoto];
        return;
    }
    
    [self viewPhoto];
}

#pragma mark - Vehicle Image Management
- (void)viewPhoto
{
    if (!self.car.thumbnail || !self.car.fullImage)
        return;
    
    [self performSegueWithIdentifier:@"ShowVehiclePhoto" sender:self];
}

- (void)editPhoto
{
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    if (!hasCamera)
    {
        [self showCameraRoll];
        return;
    }

    [self showOptionsForPhotoSelection];
}

- (void)showCameraRoll
{
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)showCamera
{
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)showOptionsForPhotoSelection
{
    __block IAActionSheet *actionSheet = [[IAActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:[NSArray arrayWithObjects:@"Take Photo", @"Choose Existing", nil] dismissalBlock:^(NSInteger buttonIndex) {
        
        switch (buttonIndex)
        {
            case 0:
                [self showCamera];
                break;
            case 1:
                [self showCameraRoll];
            default:
                break;
        }
    }];
    [actionSheet showInView:self.view];
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{    
    UIView *view = [[UIView alloc] initWithFrame:picker.view.frame];
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.85];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 170.0f, 300.0f, 44.0f)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20.0f];
    label.text = @"Saving Photo...";
    label.textAlignment = UITextAlignmentCenter;
    [view addSubview:label];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner startAnimating];
    CGRect frame = spinner.frame;
    frame.origin.x = (CGRectGetWidth(view.frame) - CGRectGetWidth(frame)) / 2;
    frame.origin.y = (CGRectGetHeight(view.frame) - CGRectGetHeight(frame)) / 2;
    spinner.frame = frame;
    [view addSubview:spinner];
    
    view.alpha = 0.0f;
    [picker.view addSubview:view];
    
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 1.0f;
    }];
    
    CGSize screenBoundsSize = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize screenResolution = CGSizeMake(screenBoundsSize.width * scale, screenBoundsSize.height * scale);
    UIImage *originalImage = [[info objectForKey:UIImagePickerControllerOriginalImage] imageToFitSize:screenResolution method:MGImageResizeScale];
    UIImage *thumbnail = [originalImage imageToFitSize:CGSizeMake(68.0f, 68.0f) method:MGImageResizeCrop];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *fullImageData = UIImagePNGRepresentation(originalImage);
        NSData *thumbnailData = UIImagePNGRepresentation(thumbnail);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.car.fullImage = fullImageData;
            self.car.thumbnail = thumbnailData;
            self.vehicleImageView.image = thumbnail;
            
            NSError *error = nil;
            
            if (![self.car.managedObjectContext save:&error])
                NSLog(@"Couldn't save context. %@, %@", error, error.userInfo);
            
            [self dismissViewControllerAnimated:YES completion:^{
                self.imagePickerController = nil;
            }];
        });
    });
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

@end
