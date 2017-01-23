//
//  HomePageTableViewCell.m
//  NativeAPIProject
//
//  Created by Nir Gaiger on 11/17/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import "HomePageTableViewCell.h"

@implementation HomePageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _leftButtonLabel.layer.cornerRadius = 3;
    _leftButtonLabel.clipsToBounds = YES;
    _rightButtonLabel.layer.cornerRadius = 3;
    _rightButtonLabel.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
