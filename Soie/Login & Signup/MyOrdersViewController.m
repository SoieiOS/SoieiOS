//
//  MyOrdersViewController.m
//  Soie
//
//  Created by Abhishek Tyagi on 19/08/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "CustomTableViewCell.h"
#import "APIHandler.h"

@interface MyOrdersViewController () {
    NSMutableArray      *listOfOrders;
}

@end

@implementation MyOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    listOfOrders = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    [self getListOfOrders];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getListOfOrders {
    [ActivityIndicator startAnimatingWithText:@"Loading" forView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@customerorders",API_BASE_URL];
    [APIHandler getResponseFor:nil url:[NSURL URLWithString:urlString] requestType:@"GET" complettionBlock:^(BOOL success,NSDictionary *jsonDict){
        [ActivityIndicator stopAnimatingForView:self.view];
        if (success) {
            NSLog(@"Response : %@",jsonDict);
            listOfOrders = [[[jsonDict objectForKey:@"data"] objectForKey:@"orders"] mutableCopy];
            [self.tableView reloadData];
        }
    }];
//}
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return listOfOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"ordersCell";
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *orderInfo = [listOfOrders objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",[orderInfo objectForKey:@"name"]];
    cell.orderIdLabel.text = [NSString stringWithFormat:@"%@",[orderInfo objectForKey:@"order_id"]];
    cell.statusLabel.text = [NSString stringWithFormat:@"%@",[orderInfo objectForKey:@"status"]];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@",[orderInfo objectForKey:@"date_added"]];
    cell.numberLabel.text = [NSString stringWithFormat:@"%@",[orderInfo objectForKey:@"products"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",[orderInfo objectForKey:@"total"]];

//    cell.addressLabel.text = [listOfOrders];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
