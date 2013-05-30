//
//  ImageViewController.h
//  Homepwner
//
//  Created by Steve Ellis on 5/29/13.
//  Copyright (c) 2013 Steve Ellis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
{
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIImageView *imageView;
}

@property (nonatomic, strong) UIImage *image;

@end
