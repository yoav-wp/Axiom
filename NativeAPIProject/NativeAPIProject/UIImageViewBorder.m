//
//  UIImageViewBorder.m
//  IMGBorder
//
//  Created by Design Webpals on 23/02/2017.
//  Copyright © 2017 Design Webpals. All rights reserved.
//

#import "UIImageViewBorder.h"

#import "QuartzCore/QuartzCore.h"

@interface UIImageView (private)
-(UIImage*)rescaleImage:(UIImage*)image;
-(void)configureImageViewBorder:(CGFloat)borderWidth;
@end

@implementation UIImageView (ImageViewBorder)

-(UIImage*)rescaleImage:(UIImage*)image{
    UIImage* scaledImage = image;
    
    CALayer* layer = self.layer;
    CGFloat borderWidth = layer.borderWidth;
    
    //if border is defined
    if (borderWidth > 0)
    {
        float ratio = image.size.width / image.size.height;
        //rectangle in which we want to draw the image.
        CGRect imageRect = CGRectMake(0.0, 0.0, self.bounds.size.width - 2 * borderWidth, self.bounds.size.height - 2 * borderWidth);
        //Only draw image if its size is bigger than the image rect size.
        if (image.size.width > imageRect.size.width)
        {
            imageRect = CGRectMake(0.0, 0.0, self.bounds.size.width - 2 * borderWidth, self.bounds.size.width / ratio - 2 * borderWidth);
            UIGraphicsBeginImageContext(imageRect.size);
            [image drawInRect:imageRect];
            scaledImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    return scaledImage;
}

-(void)configureImageViewBorder:(CGFloat)borderWidth{
    CALayer* layer = [self layer];
    [layer setBorderWidth:borderWidth];
    [self setContentMode:UIViewContentModeCenter];
    [layer setBorderColor:[UIColor whiteColor].CGColor];
//    [layer setShadowOffset:CGSizeMake(-3.0, 3.0)];
//    [layer setShadowRadius:3.0];
//    [layer setShadowOpacity:1.0];
}

-(void)setImage:(UIImage*)image withBorderWidth:(CGFloat)borderWidth
{
    [self configureImageViewBorder:borderWidth];
    UIImage* scaledImage = [self rescaleImage:image];
    self.image = scaledImage;
}



@end

