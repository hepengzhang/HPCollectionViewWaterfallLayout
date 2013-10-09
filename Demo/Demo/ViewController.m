//
//  ViewController.m
//  Demo
//
//  Created by Hepeng Zhang on 10/8/13.
//  Copyright (c) 2013 zhp. All rights reserved.
//

#import "ViewController.h"
#import "HPCollectionViewWaterfallLayout.h"
#import "DemoCell.h"

@interface ViewController () <UICollectionViewDataSource, HPCollectionViewDelegateWaterfallLayout>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // You can set up delegate in Interface Builder
    // or set it programmatically
    /**
    HPCollectionViewWaterfallLayout* layout = [[HPCollectionViewWaterfallLayout alloc] init];
    layout.delegate = self;

    self.collecitonView.collectionViewLayout = layout;
    */
}

#pragma mark - collection view related
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DemoCell" forIndexPath:indexPath];
    cell.number = indexPath.row;
    return cell;
}

#pragma mark - HPCollectionViewWaterfallLayoutDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44 + arc4random() % 88;
    CGFloat width = 10 * indexPath.section+33;

    return CGSizeMake(width, height);
}

-(NSUInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout numberOfColumnsForSection:(NSUInteger)section
{
    return section+2;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout preferredColumnSpaceForSection:(NSUInteger)section
{
    return 8;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout interItemSpaceForSection:(NSUInteger)section
{
    return 8;
}

@end
