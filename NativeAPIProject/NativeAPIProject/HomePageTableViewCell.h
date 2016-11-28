//
//  HomePageTableViewCell.h
//  NativeAPIProject
//
//  Created by Nir Gaiger on 11/17/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UILabel *bonusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UIButton *leftButtonLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButtonLabel;


@end
