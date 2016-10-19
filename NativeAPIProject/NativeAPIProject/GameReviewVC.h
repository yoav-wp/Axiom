//
//  GameReviewVC.h
//  NativeAPIProject
//
//  Created by Nir Gaiger on 10/13/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PalconParser.h"


@interface GameReviewVC : UIViewController

@property (strong, nonatomic) PalconParser *pp;
@property (nonatomic, strong) NSMutableArray *tabbarElements;
@property (nonatomic) NSInteger activeTab;

@end
