//
//  SplashScreenVC.m
//  NativeAPIProject
//
//  Created by Nir Gaiger on 12/26/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import "SplashScreenVC.h"
#import "ViewController.h"
#import "SWRevealViewController.h"
#import "NavigationManager.h"

@interface SplashScreenVC (){
    NSString *urlFromNotification;
}
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation SplashScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startAnimations];
}


-(void)startAnimations{
    NSLog(@"did appear");
    
    //    NSArray *imgArray = @[@"img1",@"img2",@"img3",@"img4",@"img5",@"img6",@"img7",@"img8"];
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    
    for(int i = 1 ;i < 43; i++){
        [imgArray addObject:[NSString stringWithFormat:@"splash%i",i]];
    }
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for(int i = 0; i < imgArray.count ; i++){
        [images addObject:[UIImage imageNamed:imgArray[i]]];
    }
    
    _imgView.animationImages = images;
    _imgView.animationDuration = 2;
    _imgView.animationRepeatCount = 1;
    _imgView.image = [_imgView.animationImages lastObject];
    [_imgView startAnimating];
    
    [self performSelector:@selector(animationDidFinish) withObject:nil
               afterDelay:_imgView.animationDuration];
}



-(void)animationDidFinish{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"HomePageSB"];
    SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:self destination:vc];
    [segue perform];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
