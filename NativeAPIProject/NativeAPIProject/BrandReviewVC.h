//
//  BrandReviewVC.h
//  NativeAPIProject
//
//  Created by Nir Gaiger on 8/31/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PalconParser.h"

@interface BrandReviewVC : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) PalconParser *pp;
@property (nonatomic, strong) NSMutableArray *tabbarElements;
@property (nonatomic) NSInteger activeTab;

@property (weak, nonatomic) IBOutlet UIImageView *paymentMethodImgV2;
@property (weak, nonatomic) IBOutlet UIImageView *paymentMethodImgV1;
@property (weak, nonatomic) IBOutlet UIImageView *paymentMethodImgV3;
@property (weak, nonatomic) IBOutlet UIImageView *paymentMethodImgV4;
@property (weak, nonatomic) IBOutlet UIImageView *paymentMethodImgV5;
@property (weak, nonatomic) IBOutlet UIImageView *paymentMethodImgV6;
@property (weak, nonatomic) IBOutlet UIImageView *paymentMethodImgV7;
@property (weak, nonatomic) IBOutlet UIImageView *paymentMethodImgV8;
@property (weak, nonatomic) IBOutlet UIImageView *paymentMethodImgV9;
@property (weak, nonatomic) IBOutlet UIImageView *swProviderImgV1;
@property (weak, nonatomic) IBOutlet UIImageView *swProviderImgV2;
@property (weak, nonatomic) IBOutlet UIImageView *swProviderImgV3;
@property (weak, nonatomic) IBOutlet UIImageView *swProviderImgV4;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBrandInfoImgV1;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBrandInfoImgV2;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBrandInfoImgV3;

@end
