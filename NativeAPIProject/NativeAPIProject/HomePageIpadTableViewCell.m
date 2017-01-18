//
//  HomePageIpadTableViewCell.m
//  NativeAPIProject
//
//  Created by Nir Gaiger on 1/18/17.
//  Copyright © 2017 Domain Planet Limited. All rights reserved.
//

#import "HomePageIpadTableViewCell.h"

@implementation HomePageIpadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _leftButtonLabel.layer.cornerRadius = 4;
    _leftButtonLabel.clipsToBounds = YES;
    _rightButtonLabel.layer.cornerRadius = 4;
    _rightButtonLabel.clipsToBounds = YES;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
