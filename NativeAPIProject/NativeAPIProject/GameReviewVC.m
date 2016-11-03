//
//  GameReviewVC.m
//  NativeAPIProject
//
//  Created by Nir Gaiger on 10/13/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import "GameReviewVC.h"
#import "SWRevealViewController.h"
#import "NavigationManager.h"

@interface GameReviewVC ()
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;

@end

@implementation GameReviewVC{
    //TabBar items
    NSMutableDictionary *_tags2URLs;
    NSMutableArray * accordionWVArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.revealViewController.rightViewRevealOverdraw=4;
    [self.revealViewController panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated{
    // Do any additional setup after loading the view, typically from a nib.
    [self initTabBar];
    [self setActiveTabbarItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setActiveTabbarItem{
    int i = 0;
    NSArray *ar = [_tabbar items];
    for(i = 0 ; i< ar.count ; i++){
        UITabBarItem *it = ar[i];
        if(it.tag == _activeTab){
            _tabbar.selectedItem = it;
            break;
        }
    }
}

//Handle tabBar clicks
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    //On homepage, homepage click does nothing
    if (item.tag == 42){
        [self.revealViewController rightRevealToggle:self];
    }
    else if(item.tag == _activeTab){
        return;
    }else{
        NavigationManager *nav = [[NavigationManager alloc] init];
        [nav navigateWithItemID:item.tag WithURL:nil WithURLsDict:_tags2URLs WithSourceVC:self];
    }
}


//menu tag: 42, homepage tag: 24
-(void)initTabBar{
    //contains list of : a tag and a url for it
    _tags2URLs = [[NSMutableDictionary alloc] init];
    NSMutableArray *tabBarArray;
    int i;
    self.tabbarElements = [self.pp getTabBarElements];
    tabBarArray = [[NSMutableArray alloc] init];
    UITabBarItem *homeItem;
    UITabBarItem *menuItem;
    
    //set middle items
    //Homepage and menu position in the json array doesnt matter, for the others it does.
    for(i = 0; i < self.tabbarElements.count; i++){
        NSDictionary *tabbarDict = self.tabbarElements[i];
        UITabBarItem *item;
        if([[tabbarDict valueForKey:@"id"] isEqualToString:@"menu_item"]){
            menuItem = [[UITabBarItem alloc] initWithTitle:[tabbarDict valueForKey:@"button_text"] image:nil tag:42];
            [_tags2URLs setObject:[tabbarDict valueForKey:@"link"] forKey:[NSNumber numberWithInteger:42]];
            continue;
        }
        if([[tabbarDict valueForKey:@"id"] isEqualToString:@"homepage_item"]){
            homeItem = [[UITabBarItem alloc] initWithTitle:[tabbarDict valueForKey:@"button_text"] image:nil tag:24];
            [_tags2URLs setObject:[tabbarDict valueForKey:@"link"] forKey:[NSNumber numberWithInteger:24]];
            continue;
        }
        
        item = [[UITabBarItem alloc] initWithTitle:[tabbarDict valueForKey:@"button_text"] image:nil tag:10+i];
        [_tags2URLs setObject:[tabbarDict valueForKey:@"link"] forKey:[NSNumber numberWithInteger:10+i]];
        [tabBarArray addObject:item];
    }
    //set menu and homepage items
    [tabBarArray insertObject:homeItem atIndex:0];
    [tabBarArray addObject:menuItem];
    
    [_tabbar setItems:[tabBarArray arrayByAddingObjectsFromArray:[_tabbar items]]];
    
    
    //some UI
    _tabbar.layer.shadowOffset = CGSizeMake(0, 0);
    _tabbar.layer.shadowRadius = 8;
    _tabbar.layer.shadowColor = [UIColor redColor].CGColor;
    _tabbar.layer.shadowOpacity = 0.3;
    _tabbar.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
}


@end
