//
//  BrandReviewVC.h
//  NativeAPIProject
//
//  Created by Nir Gaiger on 8/31/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PalconParser.h"

@interface BrandReviewVC : UIViewController

@property (strong, nonatomic) PalconParser *pp;
@property (nonatomic, strong) NSMutableArray *tabbarElements;
@property (nonatomic) NSInteger activeTab;

@end
