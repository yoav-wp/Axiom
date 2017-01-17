//
//  NavigationManager.h
//  NativeAPIProject
//
//  Created by Nir Gaiger on 10/5/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NavigationManager : NSObject


-(void) navigateWithItemID: (NSInteger) tag WithURL:(NSString *)destURL WithURLsDict: (NSMutableDictionary *)tags2URLs WithSourceVC:(UIViewController*)sourceVC;


-(void)navigateToHomepageWithVC:(UIViewController *)sourceVC;


-(void)navigateToAffLink:(NSString *)urlStr;

@end
