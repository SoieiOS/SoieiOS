//
//  AddressCell.h
//
//
//

#import <UIKit/UIKit.h>


@interface AddressCell : UIView

// Properties declaration which can be accessed (set/get) by object of this class

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;

- (id)initWithFrame:(CGRect)frame;

@end
