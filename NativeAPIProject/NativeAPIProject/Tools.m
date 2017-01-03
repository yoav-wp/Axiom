//
//  Tools.m
//  NativeAPIProject
//
//  Created by Nir Gaiger on 12/20/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import "Tools.h"

@implementation Tools

static int number = 1;

+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+(void)prefix_addUpperBorder:(UIView *)myView
{
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [[UIColor greenColor] CGColor];
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(myView.frame), 1.0f);
    [myView.layer addSublayer:upperBorder];
}


@end
