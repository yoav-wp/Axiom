//
//  ViewController.m
//  scrollViewTest
//
//  Created by Design Webpals on 26/07/2016.
//  Copyright © 2016 Design Webpals. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *mainSV;
@property (weak, nonatomic) IBOutlet UIScrollView *carouselsv;
@property (weak, nonatomic) IBOutlet UITabBarItem *menuButton;
@property (weak, nonatomic) IBOutlet UIStackView *firstStack;
@property (weak, nonatomic) IBOutlet UITextView *firstWysiwyg;
@property (weak, nonatomic) IBOutlet UITextView *secondWysiwyg;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
    //for the menu
    self.revealViewController.rightViewRevealOverdraw=4;
    [self.revealViewController panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self initCarousel];
    [self initFirstWysiwyg];
    [self initFirstTableView];
}


-(void) initFirstTableView{
    
}


-(void)initCarousel{
    _carouselsv.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.width* 0.462);
    CGFloat scrollViewWidth = self.carouselsv.frame.size.width;
    CGFloat scrollViewHeight = self.carouselsv.frame.size.height;
    NSLog(@"w: %f h: %f.....",scrollViewWidth,scrollViewHeight);
    
    CGRect rect1 = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight);
    CGRect rect2 = CGRectMake(scrollViewWidth, 0, scrollViewWidth, scrollViewHeight);
    CGRect rect3 = CGRectMake(scrollViewWidth*2, 0, scrollViewWidth, scrollViewHeight);
    CGRect rect4 = CGRectMake(scrollViewWidth*3, 0, scrollViewWidth, scrollViewHeight);
    UIImageView *imgV1= [[UIImageView alloc] initWithFrame:rect1];
    UIImageView *imgV2= [[UIImageView alloc] initWithFrame:rect2];
    UIImageView *imgV3= [[UIImageView alloc] initWithFrame:rect3];
    UIImageView *imgV4= [[UIImageView alloc] initWithFrame:rect4];
    [imgV1 setContentMode:UIViewContentModeScaleAspectFill];
    [imgV2 setContentMode:UIViewContentModeScaleAspectFill];
    
    //    imgV1.image = [UIImage imageNamed:@"Slide1"];
    NSURL *imageURL = [NSURL URLWithString:@"http://2.bp.blogspot.com/-jup9W1u0gJs/VmFc2xnAYPI/AAAAAAAABdg/-7CpW4wyKe0/s320/CasinoRebate_promo_EN.jpg"];
    [imgV1 sd_setImageWithURL:imageURL];
    
    NSURL *imageURL2 = [NSURL URLWithString:@"http://i0.wp.com/casino-creatures.com/wp-content/uploads/2015/03/Casino-1.jpeg"];
    [imgV2 sd_setImageWithURL:imageURL2];
    
    NSURL *imageURL3 = [NSURL URLWithString:@"http://2.bp.blogspot.com/-jup9W1u0gJs/VmFc2xnAYPI/AAAAAAAABdg/-7CpW4wyKe0/s320/CasinoRebate_promo_EN.jpg"];
    [imgV3 sd_setImageWithURL:imageURL3];
    
    NSURL *imageURL4 = [NSURL URLWithString:@"http://i0.wp.com/casino-creatures.com/wp-content/uploads/2015/03/Casino-1.jpeg"];
    [imgV4 sd_setImageWithURL:imageURL4];
    
    [self.carouselsv addSubview:imgV1];
    [self.carouselsv addSubview:imgV2];
    [self.carouselsv addSubview:imgV3];
    [self.carouselsv addSubview:imgV4];
    
    self.carouselsv.contentSize = CGSizeMake(self.carouselsv.frame.size.width * 4, self.carouselsv.frame.size.height);
    self.carouselsv.delegate = self;
}


-(void)initFirstWysiwyg{
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    CGFloat width = screenRect.size.width;
    NSString *fontSize = @"";
    NSLog(@"screen size %f", width);
    if(width <= 400){
        fontSize = @"1em";
    }else if(width <= 500){
        fontSize = @"1.5em";
    }else{
        fontSize = @"2em";
    }
    
    NSLog(@"screen size %f, font size: %@", width, fontSize);
    
    NSString *htmlString = [NSString stringWithFormat:@"<style>h1{color:red;}</style><span style=\"font-family:arial;color:grey;font-size:%@;\">With Canada's best online casinos in 2016 only you can say goodbye to scheduling conflicts. <a href=\"http://google.com\">this is a link</a></span>", fontSize];

    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    _firstWysiwyg.attributedText = attributedString;
    _secondWysiwyg.attributedText = attributedString;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1){
        [self.revealViewController rightRevealToggle:self];
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	
//	CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
//	CGFloat currentPage = floor((scrollView.contentOffset.y - pageWidth/2)/pageWidth)+1;
	
	NSLog(@"scroll y: %f", scrollView.contentOffset.y);
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

	if(scrollView.tag == 1){
		NSLog(@"moving main");
	}
	if(scrollView.tag == 2){
		NSLog(@"moving carousel");
	}
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
