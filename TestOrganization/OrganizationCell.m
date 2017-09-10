//
//  OrganizationCell.m
//  TestOrganization
//
//  Created by xvAcid on 09/09/2017.
//
//

#import "OrganizationCell.h"

@interface OrganizationCell()
@property (nonatomic, weak) IBOutlet UILabel *captionLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@end

@implementation OrganizationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.contentView.backgroundColor = selected ? [UIColor colorWithRed:0.3f green:0.7f blue:0.2 alpha:1.0f] : [UIColor whiteColor];
}

-(void) setupCell:(NSString*) caption withDescription:(NSString*) desc {
    [self.captionLabel setText:caption];
    [self.descriptionLabel setText:desc];
}

@end
