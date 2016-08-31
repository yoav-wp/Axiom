//
//  WebViewVC.h
//  scrollViewTest
//
//  Created by Nir Gaiger on 8/10/16.
//  Copyright © 2016 Design Webpals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PalconParser.h"

@interface WebViewVC : UIViewController <UITabBarDelegate>

@property (strong, nonatomic) PalconParser *pp;
@property (nonatomic, strong) NSMutableArray *tabbarElements;
@property (nonatomic) NSInteger activeTab;

@end
