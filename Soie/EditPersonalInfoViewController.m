//
//  EditPersonalInfoViewController.m
//  INRVU
//
//  Created by Abhishek Tyagi on 03/06/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "EditPersonalInfoViewController.h"
#import "CustomTableViewCell.h"
#import "Utilities.h"
#import "APIHandler.h"

@interface EditPersonalInfoViewController ()

@end

@implementation EditPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [_textfieldProperties objectForKey:@"placeholder"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Tableview Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"textFieldCell";
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIColor *color = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
    
    cell.textField.placeholder = [_textfieldProperties objectForKey:@"placeholder"];
    cell.textField.text = [_textfieldProperties objectForKey:@"value"];
    cell.textField.keyboardType = [[_textfieldProperties objectForKey:@"keyboardType"] integerValue];
    cell.textField.returnKeyType = UIReturnKeyDone;
    cell.textField.tag = indexPath.row;
    [Utilities setPlaceholderColorForObject:cell.textField ofColor:color];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self saveButtonClicked:self];
    return YES;
}

- (IBAction)saveButtonClicked:(id)sender {
    [self.view endEditing:TRUE];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CustomTableViewCell *cell = (CustomTableViewCell *)[editPersonalInfoTableview cellForRowAtIndexPath:indexPath];
    if (cell.textField.text.length == 0) {
        NSString *message = [NSString stringWithFormat:@"Kindly enter your %@.",[[_textfieldProperties objectForKey:@"placeholder"] lowercaseString]];
        [APIHandler showMessage:message];
        return;
    }
    NSString *key = [[[_textfieldProperties objectForKey:@"placeholder"] stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    NSString *value = cell.textField.text;
    [self.delegate userInformationUpdatedForKey:key value:value];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
