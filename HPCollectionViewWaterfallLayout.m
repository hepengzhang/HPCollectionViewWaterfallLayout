//
//  HPCollectionViewWaterfallLayout.m
//
//  Created by Hepeng Zhang
//  Copyright (c) 2013 Hepeng Zhang. All rights reserved.
//

#import "HPCollectionViewWaterfallLayout.h"

@interface HPCollectionViewWaterfallLayout ()
@property (nonatomic, assign) NSUInteger sectionCount;
@property (nonatomic, strong) NSMutableArray *sectionHeights;
@property (nonatomic, strong) NSMutableArray *numberOfColumnsInSection;
@property (nonatomic, strong) NSMutableArray *columnHeightsInSection; // height for column in section[i]
@property (nonatomic, strong) NSMutableArray *itemAttributesInSection; // attributes for each item
@end

@implementation HPCollectionViewWaterfallLayout

@synthesize sectionInset = _sectionInset;

#pragma mark - Life cycle
- (void)dealloc {
    [self deallocArray:_sectionHeights];
    [self deallocArray:_columnHeightsInSection];
    [self deallocArray:_itemAttributesInSection];
}

-(void)deallocArray:(NSMutableArray*)array
{
    [array removeAllObjects];
    array = nil;
}

#pragma mark - Methods to Override
- (void)prepareLayout {

    _sectionCount = [self.collectionView numberOfSections];
    _sectionHeights = [NSMutableArray arrayWithCapacity:_sectionCount];
    _numberOfColumnsInSection = [NSMutableArray arrayWithCapacity:_sectionCount];
    _columnHeightsInSection = [NSMutableArray arrayWithCapacity:_sectionCount];
    _itemAttributesInSection = [NSMutableArray arrayWithCapacity:_sectionCount];

    for (int section = 0; section < _sectionCount; section++) {
        NSUInteger _itemCount = [[self collectionView] numberOfItemsInSection:section];
        [_columnHeightsInSection addObject:[NSMutableArray arrayWithCapacity:_itemCount]];
        [_itemAttributesInSection addObject:[NSMutableArray arrayWithCapacity:_itemCount]];
        [self prepareLayoutForSection:section];
    }
}

-(void)prepareLayoutForSection:(NSUInteger)section
{
    NSUInteger numberOfColumns = [self.delegate collectionView:self.collectionView layout:self numberOfColumnsForSection:section];
    CGFloat columnSpace = [self.delegate collectionView:self.collectionView layout:self preferredColumnSpaceForSection:section];
    CGFloat collectionViewWidth = self.collectionView.bounds.size.width - _sectionInset.left - _sectionInset.right;
    CGFloat columnWidth = (collectionViewWidth- (numberOfColumns-1)*columnSpace) / numberOfColumns;
    CGFloat itemSpace = [self.delegate collectionView:self.collectionView layout:self interItemSpaceForSection:section];
    CGFloat yOffsetForSection = [self contentOffsetForSection:section];

	NSInteger idx = 0;
	NSUInteger _itemCount = [[self collectionView] numberOfItemsInSection:section];

    for (idx = 0; idx < numberOfColumns; idx++) {
        [_columnHeightsInSection[section] addObject:@(_sectionInset.top)];
    }
    // Item will be put into shortest column.
	for (idx = 0; idx < _itemCount; idx++) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
        NSUInteger columnIndex = [self shortestColumnIndexInSection:section];
        CGPoint columnLeftTop = CGPointMake(_sectionInset.left + (columnSpace + columnWidth) * columnIndex, yOffsetForSection);
        CGPoint itemLeftTop;

        CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        itemLeftTop.x = columnLeftTop.x + (columnWidth - itemSize.width)/2; // align center
        itemLeftTop.y = columnLeftTop.y + itemSpace + [_columnHeightsInSection[section][columnIndex] floatValue];

		UICollectionViewLayoutAttributes *attributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
		attributes.frame = CGRectMake(itemLeftTop.x, itemLeftTop.y, itemSize.width, itemSize.height);

		[_itemAttributesInSection[section] addObject:attributes];
		_columnHeightsInSection[section][columnIndex] = @(itemLeftTop.y - yOffsetForSection + itemSize.height);
	}
    NSUInteger columnIndex = [self longestColumnIndexInSection:section];
    _sectionHeights[section] = _columnHeightsInSection[section][columnIndex];
}

- (CGSize)collectionViewContentSize {
	if (_sectionCount == 0 || [self sumOfArray:_itemAttributesInSection]) {
		return CGSizeZero;
	}

	CGSize contentSize = self.collectionView.frame.size;
	CGFloat height = [self contentOffsetForSection:_sectionCount] + [self.delegate collectionView:self.collectionView layout:self interItemSpaceForSection:_sectionCount-1];;
	contentSize.height = height;
	return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
	return self.itemAttributesInSection[path.section][path.item];
}

-(BOOL)isSection:(NSUInteger)section intersectWithRect:(CGRect)rect
{
    CGFloat y = [self contentOffsetForSection:section];
    CGFloat height = [_sectionHeights[section] floatValue];
    CGRect sectionRect = CGRectMake(rect.origin.x, y, rect.size.width, height);
    BOOL intersected = CGRectIntersectsRect(sectionRect, rect);
    return intersected;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {

    CGFloat lowerBoundY = rect.origin.y;
    CGFloat upperBoundY = rect.origin.y + rect.size.height;

    NSArray *allAttributes = [self.itemAttributesInSection valueForKeyPath:@"@unionOfArrays.self"];

    //binary search for the item that intersects with rect
    int left = 0;
    int right = allAttributes.count-1;
    int mid = 0;
    while (left < right) {
        mid = (left + right) / 2;
        UICollectionViewLayoutAttributes* attr = allAttributes[mid];
        if ((attr.frame.origin.y+attr.frame.size.height) < lowerBoundY) {
            left = mid + 1;
        }else if (attr.frame.origin.y > upperBoundY) {
            right = mid - 1;
        }else
            break;
    }

    //constant time since rect is really small and constant
    mid = (left + right) / 2;
    left = mid;
    right = mid;
    while (left > 0) {
        UICollectionViewLayoutAttributes* extendAttr = allAttributes[left-1];
        if (CGRectIntersectsRect(extendAttr.frame, rect)) {
            left -= 1;
        }else {
            break;
        }
    }

    while (right < allAttributes.count - 1) {
        UICollectionViewLayoutAttributes* extendAttr = allAttributes[right+1];
        if (CGRectIntersectsRect(extendAttr.frame, rect)) {
            right += 1;
        }else {
            break;
        }
    }

    NSRange range = NSMakeRange(left, right - left + 1);
    return [allAttributes subarrayWithRange:range];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
	return NO;
}

#pragma mark - Private Methods
-(CGFloat)contentOffsetForSection:(NSUInteger)section
{
    CGFloat offset = 0;
    for (int i = 0; i < section; i++) {
        offset += [self.sectionHeights[i] floatValue];
    }
    return offset;
}

-(NSUInteger)sumOfArray:(NSArray*)array
{
    NSUInteger total = 0;
    if (array.count == 0) {
        return 0;
    }

    for (id num in array) {
        if ([num isKindOfClass:[NSArray class]]) {
            total += [self sumOfArray:num];
        }else if ([num isKindOfClass:[NSNumber class]]) {
            total += [num integerValue];
        }else
            total += 0;
    }

    return total;
}

-(NSUInteger)countForArrayAndSubarray:(NSArray*)array
{
    NSUInteger total = 0;
    if (array.count == 0) {
        return 0;
    }
    for (id subarray in array) {
        if ([subarray isKindOfClass:[NSArray class]]) {
            total += [self countForArrayAndSubarray:subarray];
        }else
            total += 0;
    }

    return total;
}

- (NSUInteger)shortestColumnIndexInSection:(NSUInteger) section {
	__block NSUInteger index = 0;
	__block CGFloat shortestHeight = MAXFLOAT;

	[self.columnHeightsInSection[section] enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
	    CGFloat height = [obj floatValue];
	    if (height < shortestHeight) {
	        shortestHeight = height;
	        index = idx;
		}
	}];

	return index;
}

- (NSUInteger)longestColumnIndexInSection:(NSUInteger)section {
	__block NSUInteger index = 0;
	__block CGFloat longestHeight = 0;
    
	[self.columnHeightsInSection[section] enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
	    CGFloat height = [obj floatValue];
	    if (height > longestHeight) {
	        longestHeight = height;
	        index = idx;
		}
	}];
    
	return index;
}

@end
