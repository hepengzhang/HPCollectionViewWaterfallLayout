//
//  DemoCell.m
//  Demo
//
//  Created by Hepeng Zhang on 10/8/13.
//  Copyright (c) 2013 zhp. All rights reserved.
//

#import "DemoCell.h"

@implementation DemoCell

-(void)setNumber:(NSUInteger)number
{
    _number = number;
    self.label.text = [NSString stringWithFormat:@"%d", number];
}

@end
