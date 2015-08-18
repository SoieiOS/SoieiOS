//
//  AddressCell.m
//
//
//

#import "AddressCell.h"

@implementation AddressCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:self options:nil] firstObject];
//        self.frame = frame;

        self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.bgView.layer.borderWidth = 1.0;
        
        self.addressButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.addressButton.layer.borderWidth = 1.0;
    }
    return self;
}


@end
