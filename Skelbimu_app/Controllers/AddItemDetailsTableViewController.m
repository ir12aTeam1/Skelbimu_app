//
//  AddItemDetailsTableViewController.m
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 23/06/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import "AddItemDetailsTableViewController.h"
#import "RKButton.h"
#import "ACEExpandableTextCell.h"
#import "PECropViewController.h"
#import "UIImage+Resize.h"

@interface AddItemDetailsTableViewController () <ACEExpandableTableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PECropViewControllerDelegate> {
    CGFloat _cellHeight[1];
}
@property (weak, nonatomic) IBOutlet ACEExpandableTextCell *expandableDescriptionCell;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *CityTextField;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@end

@implementation AddItemDetailsTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.expandableDescriptionCell.expandableTableView = self.tableView;
    self.expandableDescriptionCell.textView.placeholder = @"Įveskite aprašymą..";
    _cellHeight[0] = self.expandableDescriptionCell.cellHeight;
    [self.tableView reloadData];
    
    switch (self.selectedButton.rkSelection) {
        case RK_PROPOSE:
            [self.navigationItem setTitle:@"Siūlau"];
            break;
        case RK_LOOKINGFOR:
            [self.navigationItem setTitle:@"Ieškau"];
            break;
        default:
            break;
    }
}

#pragma mark - Methods

- (void)showCamera
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:controller animated:YES completion:NULL];
}

- (void)openPhotoAlbum
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:controller animated:YES completion:NULL];
}

- (void)openEditorWithImage:(UIImage*)image
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = image;
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MAX(44.0, _cellHeight[indexPath.row]);
}

- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath {
    _cellHeight[indexPath.row] = height;
}

- (void)tableView:(UITableView *)tableView updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Actions

- (IBAction)addPictureButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Foto Albumas", nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:@"Kamera"];
    }
    [actionSheet showInView:self.view];
}

- (IBAction)saveButtonPressed:(id)sender {
    NSData *imageData = UIImageJPEGRepresentation(self.itemImageView.image, 0.25);
    PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:imageData];
    //We can create HUD here
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFUser *user = [PFUser currentUser];
            PFObject *newItem = [PFObject objectWithClassName:@"Item"];
            [newItem setObject:imageFile forKey:@"image"];
            [newItem setObject:user forKey:@"user"];
            //TODO: Prideti likusius laukus
            
            [newItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //Success, close controller and refresh something
                } else {
                    NSLog(@"Error save item: %@ %@", error, [error userInfo]);
                }
            }];
            
        } else {
            NSLog(@"Error upload image: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        //Cia galima atnaujinti progresa HUD'ui
    }];
}

#pragma mark - ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self openPhotoAlbum];
            break;
        case 1:
            [self showCamera];
            break;
            
        default:
            break;
    }
}

#pragma mark - ImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditorWithImage:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:^{
        UIImage *tempImage;
        
        if (croppedImage.size.width != 250 || croppedImage.size.height != 250) {
            tempImage = [UIImage resizeImage:croppedImage withSize:CGSizeMake(250, 250)];
        } else {
            tempImage = croppedImage;
        }
        self.itemImageView.image = tempImage;
//        [RequestUpload post:self image:self.profileImageView.image];
    }];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

@end
