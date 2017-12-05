# ZZCarouselSwift

### Gif 来先解释

![ZZCarouselSwift](ZZCarouselSwift.gif)

### 更新内容

* 添加数据源等于1的情况判断。隐藏pagecontrol，禁用自动滚动
* 添加主动刷新的reloaddata 方法。
* 添加主动开始/停止轮播器的方法

### 轮播器优势：

- 基于UICollectionView，真无限轮播器
- 自定义UICollectionViewCell方式定制轮播器。
- 可支持纯图片轮播，纯文字轮播，以及各种自定义Cell形式轮播。
- 支持Kingfisher加载图片
- 支持cocoapods
- 点击轮播器delegte方法执行
- Demo中添加仿淘宝样式的效果

### 方法说明

注册UICollectionviewCell，PS：必须实现的方法，如不实现肯定Crash

```
registerCarouselCell(cellClass: AnyClass)
```

设置自动滚动间隔时间

```
setAutoScrollTimeInterval(timeInterval: Float)
```

数据源，AnyObject类型。PS：必实现的方法。轮播中的所有数据都通过此方法来传递

```
setCarouselData(carouselData: [AnyObject])
```

UIPageControl Default颜色

```
setDefaultPageColor(color: UIColor)
```

UIPageControl Current颜色

```
setCurrentPageColor(color: UIColor)
```

设置UIPageControl 对齐方式 ， 枚举类型：左、中、右

```
setPageControlAlignment(alignment: ZZCarouselPageAlignment)
```

设置是否隐藏PageControl。PS：通常在文字轮播中设置此方法

```
setHiddenPageControl(hidden: Bool)
```

是否关闭滚动手势，PS：一般在文字轮播的情况下调用此方法

```
setDisableScroll(disableScroll: Bool)
```

### 枚举说明

```
ZZCarouselPageAlignment  UIPageControl对齐方式设置
	case left      // 居左
    case right     // 居右
    case center    // 居中
    
ZZCarouselScrollDirection  Carousel滚动方向设置
	case left      // 从左到右
    case right     // 从右到左
    case top       // 从上到下
    case bottom    // 从下到上
```

### 使用方法

```objective-c
/// <#Description#>
///
/// - Parameters:
///   - frame: <#frame description#>
///   - direction: 指定滚动滚动方向
let carousel = ZZCarouselView.init(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height:self.view.frame.size.height / 3), direction: ZZCarouselScrollDirection.left)
// 注册自定义的Cell，PS：非常有必要，一定要实现的方法
carousel.registerCarouselCell(cellClass: Example1Cell.classForCoder())
carousel.setCurrentPageColor(color: UIColor.red)
carousel.setDefaultPageColor(color: UIColor.yellow)
carousel.delegate = self
// 设置自动滚动的间隔时间
carousel.setAutoScrollTimeInterval(timeInterval: 2)
carousel.setPageControlAlignment(alignment: ZZCarouselPageAlignment.right)
carousel.tag = 1001;
self.view.addSubview(carousel)
// 非常有必要，给实例的CarouselView传递数据，数组<任意Object>  
carousel.setCarouselData(carouselData: data as [AnyObject])
```

### 安装方法

- 手动安装：拖拽ZZCarouselSwift文件夹到工程内即可
- 自动安装：pod 'ZZCarouselSwift', '~> 1.0.6'

### PS

如有问题，可以给我各种贡献代码。逐步完善，还是需要各路ioser。

