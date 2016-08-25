//
//  ViewController.h
//  scrollViewTest
//
//  Created by Design Webpals on 26/07/2016.
//  Copyright © 2016 Design Webpals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PalconParser.h"

@interface ViewController : UIViewController <UIScrollViewDelegate, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PalconParser *pp;
@property (nonatomic, strong) NSMutableArray *tabbarElements;
@property (nonatomic) NSInteger activeTab;

@end

