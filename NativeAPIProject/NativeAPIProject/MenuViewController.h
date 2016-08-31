//
//  MenuViewController.h
//  scrollViewTest
//
//  Created by Nir Gaiger on 8/8/16.
//  Copyright © 2016 Design Webpals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UITableViewController {
    
}

@property (nonatomic, retain) NSArray *firstArray;
@property (nonatomic, retain) NSArray *secondArray;


@property (nonatomic, retain) NSMutableArray *firstForTable;
@property (nonatomic, retain) NSMutableArray *secondForTable;

-(void)miniMizeFirstsRows:(NSArray*)ar;
-(void)miniMizeSecondsRows:(NSArray*)ar;

@end
