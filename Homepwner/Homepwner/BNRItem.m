//
//  BNRItem.m
//  Homepwner
//
//  Created by Steve Ellis on 5/30/13.
//  Copyright (c) 2013 Steve Ellis. All rights reserved.
//

#import "BNRItem.h"


@implementation BNRItem

@dynamic itemName;
@dynamic serialNumber;
@dynamic valueInDollars;
@dynamic dateCreated;
@dynamic imageKey;
@dynamic thumbnailData;
@dynamic thumbnail;
@dynamic orderingValue;
@dynamic assetType;

- (void)awakeFromFetch {
    [super awakeFromFetch];
    
    UIImage *tn = [UIImage imageWithData:self.thumbnailData];
    [self setPrimitiveValue:tn forKey:@"thumbnail"];
}

- (void)awakeFromInsert {
    [super awakeFromInsert];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSinceReferenceDate];
    [self setDateCreated:time];
}

- (void)setThumbnailDataFromImage:(UIImage *)image {
    CGSize originalImageSize = [image size];
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    //figure out scaling ratio
    float ratio = MAX(newRect.size.width / originalImageSize.width,
                      newRect.size.height / originalImageSize.height);
    //create a transparent bitmap context with a scaling factor equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    //create a rounded rectangle path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    //make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    //center the image
    CGRect projectRect;
    projectRect.size.width = ratio * originalImageSize.width;
    projectRect.size.height = ratio * originalImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    //draw image
    [image drawInRect:projectRect];
    //get image from the image context, keep it as thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    //get the PNG representation of the image and set it as our archivable data
    NSData *data = UIImagePNGRepresentation(smallImage);
    self.thumbnailData = data;
    //cleanup image context resources
    UIGraphicsEndImageContext();
}

@end
