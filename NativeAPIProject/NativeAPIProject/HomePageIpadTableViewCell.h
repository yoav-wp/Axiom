//
//  HomePageIpadTableViewCell.h
//  NativeAPIProject
//
//  Created by Nir Gaiger on 1/18/17.
//  Copyright © 2017 Domain Planet Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageIpadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UILabel *bonusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UIButton *leftButtonLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButtonLabel;


@end
