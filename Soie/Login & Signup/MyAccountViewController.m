//
//  MyAccountViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 25/07/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "MyAccountViewController.h"
#import "EditPersonalInfoViewController.h"
#import "CustomTableViewCell.h"
#import "UserInformation.h"
#import "Constants.h"
#import "APIHandler.h"

@interface MyAccountViewController () <UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UserInformationUpdated> {
    
    UIImagePickerController     *pickerController;
    IBOutlet UITableView        *personalInfoTableview;
    NSMutableDictionary                *userInformation;
}
@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:78/255.0 green:85/255.0 blue:91/255.0 alpha:1.0]];
    
    // Set the gesture
    // Do any additional setup after loading the view.
    
    [self setUpPickerViewController];
    [self getUserInformation];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked)];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)cancelButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUpPickerViewController {
    pickerController = [[UIImagePickerController alloc]  init];
    pickerController.allowsEditing = YES;
    pickerController.delegate = self;
    [pickerController.navigationBar setBarTintColor:self.navigationController.navigationBar.barTintColor];
    [pickerController.navigationBar setTintColor:[UIColor whiteColor]];
    pickerController.title = @"Select Picture";
    pickerController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark get user information ----

- (void)getUserInformation {
    userInformation = [[[UserInformation getUserInformation] objectForKey:@"user"] mutableCopy];
//    userInformation = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                       @"Abhishek Tyagi",@"name",
//                       @"abhishek.tyagi@quovantis.com",@"email",
//                       @"9999030380",@"phonenumber",
//                       nil];
}

#pragma mark edit information delegate

- (void)userInformationUpdatedForKey:(NSString *)key value:(NSString *)value {
    [userInformation setObject:value forKey:key];
    [personalInfoTableview reloadData];
}

#pragma mark Tableview Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    personalDetailsCell
    //    uploadThumbnailCell
    NSString *cellIdentifier = @"personalDetailsCell";
    CustomTableViewCell *cell;
    if (indexPath.row == 0) {
        cellIdentifier = @"uploadThumbnailCell";
        cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        return cell;
    }
    else {
        cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (indexPath.row == 1) {
            cell.titleLabel.text = @"Name";
            cell.subTitleLabel.text = [userInformation objectForKey:@"firstname"];
            if ([userInformation objectForKey:@"lastname"]) {
                cell.subTitleLabel.text = [NSString stringWithFormat:@"%@ %@",[userInformation objectForKey:@"firstname"],[userInformation objectForKey:@"lastname"]];
            }
        }
        if (indexPath.row == 2) {
            cell.titleLabel.text = @"Phone Number";
            cell.subTitleLabel.text = [userInformation objectForKey:@"telephone"];
        }
        if (indexPath.row == 3) {
            cell.titleLabel.text = @"Email Address";
            cell.subTitleLabel.text = [userInformation objectForKey:@"email"];
        }
        else if (indexPath.row == 4) {
            cell.titleLabel.text = @"Change Password";
            cell.subTitleLabel.text = @"";
        }
        else if (indexPath.row == 5) {
            cell.titleLabel.text = @"My Addresses";
            cell.subTitleLabel.text = @"";
        }
        else if (indexPath.row == 6) {
            cell.titleLabel.text = @"My Orders";
            cell.subTitleLabel.text = @"";
        }
        else if (indexPath.row == 7) {
            cell.titleLabel.text = @"Logout";
            cell.subTitleLabel.text = @"";
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose from Library", @"Take Picture", nil];
        [actionSheet showInView:self.view];
        return;
    }
    if (indexPath.row == 5) {
        NAVIGATE_TO_VIEW(addressListView);
        return;
    }
    if (indexPath.row == 6) {
//        NAVIGATE_TO_VIEW(addressView);
        return;
    }
    if (indexPath.row == 7) {
        NSString *urlString = [NSString stringWithFormat:@"%@logout",API_BASE_URL];
        
        [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"POST" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
            [ActivityIndicator stopAnimatingForView:self.view];
            
            if (success) {
                NSLog(@"Response : %@",jsonDict);
                //            NAVIGATE_TO_VIEW(myAccountViews);
                NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
                [userDefaults1 setBool:NO forKey:@"isloggedin"];
                [userDefaults1 synchronize];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        
        return;
    }
    if (indexPath.row == 4) {
//        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"changePasswordView"] animated:YES];
//        NAVIGATE_TO_VIEW(changePasswordView);
        return;
    }
//    EditPersonalInfoViewController *editPersonalInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"editPersonalInfoView"];
//    editPersonalInfoView.userInformation = [userInformation copy];
//    editPersonalInfoView.textfieldProperties = [self getTextfieldProperties:indexPath.row];
//    editPersonalInfoView.delegate = self;
//    [self.navigationController pushViewController:editPersonalInfoView animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerController animated:YES completion:nil];
    }
    else if (buttonIndex == 1) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerController animated:YES completion:nil];
    }
}

#pragma mark image picker controller delegate --------

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *finalImg = [self imageWithImage:img scaledToWidth:320];
    
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(finalImg) forKey:@"profilePicture"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //    CustomTableViewCell *cell = (CustomTableViewCell *)[personalInfoTableview cellForRowAtIndexPath:newIndexPath];
    [self dismissViewControllerAnimated:pickerController completion:nil];
}

-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark personal info get methods ------

- (NSDictionary *)getTextfieldProperties:(NSInteger)row {
    NSString *placeholder = @"";
    NSString *value = @"";
    NSInteger keyboardType = 0;
    
    if (row == 1) {
        placeholder = @"Name";
        value = [userInformation objectForKey:@"name"];
        keyboardType = UIKeyboardTypeASCIICapable;
    }
    else if (row == 2) {
        placeholder = @"Phone Number";
        value = [userInformation objectForKey:@"phonenumber"];
        keyboardType = UIKeyboardTypePhonePad;
    }
    else if (row == 3) {
        placeholder = @"Email";
        value = [userInformation objectForKey:@"email"];
        keyboardType = UIKeyboardTypeEmailAddress;
    }
    
    return [[NSDictionary alloc] initWithObjectsAndKeys:placeholder,@"placeholder",[NSNumber numberWithInteger:keyboardType],@"keyboardType",value,@"value", nil];
}

- (NSString *)getPlaceholderText:(NSInteger)row {
    NSString *value;
    
    return value;
}

- (NSInteger)getKeyboardType:(NSInteger)row {
    return 0;
}

- (NSInteger)getReturnKeyType:(NSInteger)row {
    return 0;
}

@end
