//
//  DemoCell.h
//  Demo
//
//  Created by Hepeng Zhang on 10/8/13.
//  Copyright (c) 2013 zhp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoCell : UICollectionViewCell

@property (assign, nonatomic) NSUInteger number;
@property (strong, nonatomic) IBOutlet UILabel* label;

@end
