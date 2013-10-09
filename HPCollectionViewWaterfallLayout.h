//
//  UICollectionViewWaterfallLayout.h
//
//  Created by Hepeng Zhang
//  Copyright (c) 2013 Hepeng Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HPCollectionViewWaterfallLayout;

@protocol HPCollectionViewDelegateWaterfallLayout

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout interItemSpaceForSection:(NSUInteger)section;
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
-(NSUInteger)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout numberOfColumnsForSection:(NSUInteger)section;
-(CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout preferredColumnSpaceForSection:(NSUInteger)section;

@end

@interface HPCollectionViewWaterfallLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) IBOutlet id<HPCollectionViewDelegateWaterfallLayout> delegate;

@end
