HPCollectionViewWaterfallLayout
===============================

**HPCollectionViewWaterfallLayout** is inspired by **[CHTCollectionViewWaterfallLayout]** and [Pinterest], and it's a subclass of [UICollectionViewLayout].

It provides a delegate style to config the layout, which is kind of more iOS flavor.

Improvements
------------
* Support multiple sections with different number of columns
* Use binary search to boost performance

Screen Shots
------------
![2 columns](https://raw.github.com/chiahsien/UICollectionViewWaterfallLayout/master/Screenshots/2-columns.png)
![3 columns](https://raw.github.com/chiahsien/UICollectionViewWaterfallLayout/master/Screenshots/3-columns.png)

Prerequisite
------------
* ARC
* Xcode 4.5+
* iOS 6+

How to Use
----------
Read the demo codes for detail information.

#### Setup `delegate`
``` objc
HPCollectionViewWaterfallLayout *layout = [[HPCollectionViewWaterfallLayout alloc] init];
layout.delegate = self;
```

####Implement `HPCollectionViewDelegateWaterfallLayout`
``` objc
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout interItemSpaceForSection:(NSUInteger)section;
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
-(NSUInteger)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout numberOfColumnsForSection:(NSUInteger)section;
-(CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout preferredColumnSpaceForSection:(NSUInteger)section;
```

Limitation
----------
* Only vertical scrolling is supported.
* No supplementary view and decoration view.

License
-------
HPCollectionViewWaterfallLayout is available under the MIT license. See the LICENSE file for more info.

Contact
-------
Weibo: [@Teeeerry大师兄黑曼巴]

gmail: hepeng.zhang1

[CHTCollectionViewWaterfallLayout]: https://github.com/chiahsien/CHTCollectionViewWaterfallLayout
[UICollectionView]: http://developer.apple.com/library/ios/#documentation/uikit/reference/UICollectionView_class/Reference/Reference.html
[UICollectionViewLayout]: http://developer.apple.com/library/ios/#documentation/uikit/reference/UICollectionViewLayout_class/Reference/Reference.html
[Pinterest]: http://pinterest.com/
[@Teeeerry大师兄黑曼巴]: http://weibo.com/1801824931/
