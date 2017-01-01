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

@interface SplashScreenVC ()
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation SplashScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"did appear");
    
//    NSArray *imgArray = @[@"img1",@"img2",@"img3",@"img4",@"img5",@"img6",@"img7",@"img8"];
    NSMutableArray *imgArray = [[NSMutableArray alloc]init];
    
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
    NSLog(@"block released");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"HomePageSB"];
    SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:self destination:vc];
    [segue perform];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
