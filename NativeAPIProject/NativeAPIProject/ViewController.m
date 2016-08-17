//
//  ViewController.m
//  scrollViewTest
//
//  Created by Design Webpals on 26/07/2016.
//  Copyright © 2016 Design Webpals. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"
#import "CategoryVC.h"
#import "WebViewVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *mainSV;
@property (weak, nonatomic) IBOutlet UIScrollView *carouselsv;
@property (weak, nonatomic) IBOutlet UITabBarItem *menuButton;
@property (weak, nonatomic) IBOutlet UIStackView *firstStack;
@property (weak, nonatomic) IBOutlet UITextView *firstWysiwyg;
@property (weak, nonatomic) IBOutlet UITextView *secondWysiwyg;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@end

static NSString * homepageID = @"HomePageSB";
static NSString * webviewID = @"webviewVC";
static NSString * categoryID = @"categoryVC";

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    self.pp = [[PalconParser alloc] init];
    [self.pp initWithFullURL:@"http://www.onlinecasinos.expert/homepage.js"];
    self.tabBar.selectedItem= self.tabBar.items[0];
    //for the menu
    self.revealViewController.rightViewRevealOverdraw=4;
    [self.revealViewController panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];
}


//better view WILL appear, did appear for debug
-(void)viewDidAppear:(BOOL)animated{
    // Do any additional setup after loading the view, typically from a nib.
    [self initFirstWysiwyg];
    [self initSecondWysiwyg];
    [self initCarousel];
    [self initTableView];
}

-(void) initTableView{
    
}


-(void)initCarousel{
    
    //init carousel UI
    _carouselsv.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.width* 0.462);
    CGFloat scrollViewWidth = self.carouselsv.frame.size.width;
    CGFloat scrollViewHeight = self.carouselsv.frame.size.height;
    //finish UI
    self.carouselsv.contentSize = CGSizeMake
    (self.carouselsv.frame.size.width * 4, self.carouselsv.frame.size.height);
    self.carouselsv.delegate = self;
    
    //get carousel from API
    NSMutableArray *carousel = [self.pp categoryGetCarousel];
    //Set carousel data in the imageViews
    NSMutableArray *carouselImageViewsArray = [NSMutableArray array];
    int i = 0;
    for(i = 0; i< carousel.count ; i++){
        NSDictionary * carouselDict = carousel[i];
        //NSLog(@"yoav Ya: %@",[carouselDict valueForKey:@"label"] );
        
        carouselImageViewsArray[i] = [[UIImageView alloc]initWithFrame:CGRectMake(i * scrollViewWidth, 0, scrollViewWidth, scrollViewHeight)];
        NSURL *imgURL = [NSURL URLWithString:[carouselDict valueForKey:@"image_url"]];
        [carouselImageViewsArray[i] sd_setImageWithURL:imgURL];
        [self.carouselsv addSubview:carouselImageViewsArray[i]];
        
    }
}


-(void)initTabBar{
    int i = 0;
    self.tabbarElements = [self.pp getTabBarElements];
    for(i = 0 ; i< self.tabbarElements.count; i++){
        NSDictionary *tabbarDict = self.tabbarElements[i];
        NSInteger itemID = [[tabbarDict valueForKey:@"id"] integerValue];
        NSString *targetURL = [tabbarDict valueForKey:@"link"];
        NSLog(@"item id : %ld with url %@", itemID, targetURL);
    }
}

-(void)initFirstWysiwyg{
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    CGFloat width = screenRect.size.width;
    NSString *fontSize = @"";
//    NSLog(@"screen size %f", width);
    if(width <= 400){
        fontSize = @"1em";
    }else if(width <= 500){
        fontSize = @"1.5em";
    }else{
        fontSize = @"2em";
    }
    
//    NSLog(@"screen size %f, font size: %@", width, fontSize);
    
    NSString *htmlString = [NSString stringWithFormat:@"<span style=\"font-family:arial;color:grey;font-size:%@\">%@</spann>",fontSize,[self.pp homepageGetFirstWysiwyg]];

    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    self.firstWysiwyg.attributedText = attributedString;
}



-(void)initSecondWysiwyg{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGFloat width = screenRect.size.width;
    NSString *fontSize = @"";
//    NSLog(@"screen size %f", width);
    if(width <= 400){
        fontSize = @"1em";
    }else if(width <= 500){
        fontSize = @"1.5em";
    }else{
        fontSize = @"2em";
    }
    
    //    NSLog(@"screen size %f, font size: %@", width, fontSize);
    
    NSString *htmlString = [NSString stringWithFormat:@"<span style=\"font-family:arial;color:grey;font-size:%@\">%@</spann>",fontSize,[self.pp homepageGetSecondWysiwyg]];
    
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    self.secondWysiwyg.attributedText = attributedString;
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1){
        [self.revealViewController rightRevealToggle:self];
    }
    if (item.tag == 5){
    }
    if (item.tag == 3){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        WebViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:webviewID];
        
        SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:self destination:vc];
        [segue perform];
        
    }//TODO : read about self.var vs _var, make an enum for ViewControllers identifiers, put next block in a func
    if (item.tag == 4){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        CategoryVC *vc = [storyboard instantiateViewControllerWithIdentifier:categoryID];
        PalconParser *destPP = [[PalconParser alloc] init];
        [destPP initWithFullURL:@"http://www.onlinecasinos.expert/page2.js"];
        vc.pp = destPP;
        SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:self destination:vc];
        [segue perform];
        
    }
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	
//	CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
//	CGFloat currentPage = floor((scrollView.contentOffset.y - pageWidth/2)/pageWidth)+1;
	
	NSLog(@"scroll y: %f", scrollView.contentOffset.y);
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//	if(scrollView.tag == 1){
//		NSLog(@"moving main");
//	}
//	if(scrollView.tag == 2){
//		NSLog(@"moving carousel");
//	}
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *appCell = [tableView dequeueReusableCellWithIdentifier:@"homePageCell"];
    return appCell;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
