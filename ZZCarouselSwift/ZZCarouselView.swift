//
//  ZZCarouselView.swift
//  ZZCarouselSwift
//
//  Created by Glianze on 2017/11/15.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit

protocol ZZCarouselDelegate:class {
    func carouselForItemCell(carouselView:ZZCarouselView, cell:AnyObject, indexItem:AnyObject) -> Void
    func carouselDidSelectItemAtIndex(carouselView:ZZCarouselView, index: Int) -> Void
}

enum ZZCarouselPageAlignment{
    case left
    case right
    case center
}

enum ZZCarouselScrollDirection{
    case left
    case right
    case top
    case bottom
}

class ZZCarouselView: UIView,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate {
    
    var _carouselData : [AnyObject]!
    var cellClass : AnyClass!
    var timer : Timer!
    var autoScrollTimeInterval : Float!
    var scrollDirection : ZZCarouselScrollDirection!
    var pageControlAlignment : ZZCarouselPageAlignment!
    var hiddenPageControl : Bool!
    
    var currentPageColor : UIColor?
    var defaultPageColor : UIColor!
    
    var coreView : UICollectionView!
    var pageControl : UIPageControl!
    var backgroundView : UIImageView!
    var this_width : Int!
    var this_height : Int!
    
    weak var delegate : ZZCarouselDelegate?
    
    init(frame: CGRect, direction: ZZCarouselScrollDirection) {
        super.init(frame: frame)
        
        this_width = Int(frame.size.width)
        this_height = Int(frame.size.height)
        
        self.scrollDirection = direction
        
        self.resettingSelfFrame(frame: frame)
        self.instance()
        self.makeCoreUI(direction: direction);
        self.makePageControlUI(frame: frame)
    }
    
    func resettingSelfFrame(frame: CGRect) -> Void {
        self.frame = CGRect(x: frame.origin.x,y: frame.origin.y, width: CGFloat(this_width), height: CGFloat(this_height))
    }
    
    func instance() -> Void {
        autoScrollTimeInterval = 0
        pageControlAlignment = ZZCarouselPageAlignment.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func makeCoreUI(direction: ZZCarouselScrollDirection) -> Void {
        backgroundView = UIImageView.init(frame: CGRect(x:0.0 ,y: 0.0, width: CGFloat(this_width), height: CGFloat(this_height)))
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.borderWidth = 0
        backgroundView.backgroundColor = UIColor.red
        self.backgroundView.contentMode = UIViewContentMode.scaleToFill
        self.addSubview(backgroundView)
        
        let flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize(width: this_width, height: this_height)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        if direction == ZZCarouselScrollDirection.left || direction == ZZCarouselScrollDirection.right {
            flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        }else if direction == ZZCarouselScrollDirection.top || direction == ZZCarouselScrollDirection.bottom {
            flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        }
        
        self.coreView = UICollectionView.init(frame: CGRect(x:0.0 ,y: 0.0, width: CGFloat(this_width), height: CGFloat(this_height)), collectionViewLayout: flowLayout)
        self.coreView.showsHorizontalScrollIndicator = false
        self.coreView.showsVerticalScrollIndicator = false
        self.coreView.dataSource = self
        self.coreView.delegate = self
        self.coreView.isPagingEnabled = true
        self.coreView.backgroundColor = UIColor.clear
        if #available(iOS 11.0, *) {
            self.coreView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        self.addSubview(self.coreView)
    }
    
    func makePageControlUI(frame: CGRect) -> Void {
        self.pageControl = UIPageControl.init(frame: CGRect(x:0.0 ,y: CGFloat(this_height - 20), width: CGFloat(this_width), height: 20.0))
        self.pageControl.backgroundColor = UIColor.clear
        self.addSubview(self.pageControl)
    }
    
    func setCurrentPageColor(color: UIColor) -> Void {
        self.pageControl.currentPageIndicatorTintColor = color
    }
    
    func setDefaultPageColor(color: UIColor) -> Void {
        self.pageControl.pageIndicatorTintColor = color
    }
    
    func setPageControlAlignment(alignment: ZZCarouselPageAlignment) -> Void {
        pageControlAlignment = alignment
    }
    
    func setHiddenPageControl(hidden: Bool) -> Void {
        pageControl.isHidden = hidden
    }
    
    func settingPageControlAlignment() -> Void {
        let pointSize : CGSize = pageControl.size(forNumberOfPages: _carouselData.count)
        var page_x : Float = 0.0
        if (pageControlAlignment == ZZCarouselPageAlignment.left) {
            page_x = Float((pageControl.bounds.size.width - pointSize.width) / 2) ;
        }else if (pageControlAlignment == ZZCarouselPageAlignment.right){
            page_x = Float(-(pageControl.bounds.size.width - pointSize.width) / 2) ;
        }else if (pageControlAlignment == ZZCarouselPageAlignment.center){
            page_x = 0;
        }
        pageControl.bounds = CGRect(x: CGFloat(page_x), y: pageControl.bounds.origin.y,width: pageControl.bounds.size.width, height: pageControl.bounds.size.height)
    }
    
    func setCarouselData(carouselData: [AnyObject]) -> Void {
        if !carouselData.isEmpty {
            _carouselData = self.remakeCarouselData(data: carouselData)
            self.coreView.reloadData()
            self.pageControl.numberOfPages = carouselData.count
        }
        settingPageControlAlignment()
        
        if scrollDirection == ZZCarouselScrollDirection.left || scrollDirection == ZZCarouselScrollDirection.right {
            self.coreView.contentOffset = CGPoint(x: this_width, y: 0)
        }else if scrollDirection == ZZCarouselScrollDirection.top || scrollDirection == ZZCarouselScrollDirection.bottom {
            self.coreView.contentOffset = CGPoint(x: 0, y: this_height)
        }
    }
    
    func remakeCarouselData(data: [AnyObject]) -> [AnyObject] {
        var carousel_data : [AnyObject] = [AnyObject]()
        carousel_data.append(data.last!)
        for item in data {
            carousel_data.append(item)
        }
        carousel_data.append(data.first!)
        return carousel_data
    }
    
    func registerCarouselCell(cellClass: AnyClass) -> Void {
        self.cellClass = cellClass
        coreView.register(self.cellClass, forCellWithReuseIdentifier: NSStringFromClass(self.cellClass))
    }
    
    func setAutoScrollTimeInterval(timeInterval: Float) -> Void {
        self.autoScrollTimeInterval = timeInterval
        self.createTimer()
    }
    
    func createTimer() -> Void {
        timer = Timer.scheduledTimer(timeInterval: Double(self.autoScrollTimeInterval), target: self, selector: #selector(self.autoCarouselScroll), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode:RunLoopMode.commonModes)
    }
    
    @objc func autoCarouselScroll() -> Void {
        if scrollDirection == ZZCarouselScrollDirection.left {
            self.autoCarouselScrollWithDirection(direction: ZZCarouselScrollDirection.left)
        } else if scrollDirection == ZZCarouselScrollDirection.right {
            self.autoCarouselScrollWithDirection(direction: ZZCarouselScrollDirection.right)
        } else if scrollDirection == ZZCarouselScrollDirection.top {
            self.autoCarouselScrollWithDirection(direction: ZZCarouselScrollDirection.top)
        } else if scrollDirection == ZZCarouselScrollDirection.bottom {
            self.autoCarouselScrollWithDirection(direction: ZZCarouselScrollDirection.bottom)
        }
    }
    
    func autoCarouselScrollWithDirection(direction: ZZCarouselScrollDirection) -> Void {
        var contentPoint: CGPoint = CGPoint(x:0.0, y:0.0)
        
        if direction == ZZCarouselScrollDirection.left {
            contentPoint = CGPoint(x: self.coreView.contentOffset.x + CGFloat(this_width), y: 0.0)
        } else if direction == ZZCarouselScrollDirection.right {
            contentPoint = CGPoint(x: self.coreView.contentOffset.x - CGFloat(this_width), y: 0.0)
        } else if direction == ZZCarouselScrollDirection.top {
            contentPoint = CGPoint(x: 0.0, y: self.coreView.contentOffset.y + CGFloat(this_height))
        } else if direction == ZZCarouselScrollDirection.bottom {
            contentPoint = CGPoint(x: 0.0, y: self.coreView.contentOffset.y - CGFloat(this_height))
        }
        self.coreView.setContentOffset(contentPoint, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _carouselData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(cellClass), for: indexPath)
        self.delegate?.carouselForItemCell(carouselView: self, cell: cell, indexItem: self._carouselData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.carouselDidSelectItemAtIndex(carouselView: self, index: indexPath.row-1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = fetchCurrentPage();
        if scrollDirection == ZZCarouselScrollDirection.left || scrollDirection == ZZCarouselScrollDirection.right {
            self.carouselHorizontalDidScroll(scrollView: scrollView)
        }else if scrollDirection == ZZCarouselScrollDirection.top || scrollDirection == ZZCarouselScrollDirection.bottom {
            self.carouselVerticalDidScroll(scrollView: scrollView)
        }
    }
    
    func carouselHorizontalDidScroll(scrollView: UIScrollView) -> Void {
        if scrollView.contentOffset.x <= 0 {
            scrollView.contentOffset = CGPoint(x: Int(this_width) * (_carouselData.count - 2), y: 0);
        } else if Float(scrollView.contentOffset.x) >= Float(this_width) * (Float(_carouselData.count - 1)) {
            scrollView.contentOffset = CGPoint(x: Int(this_width), y: 0);
        }
    }
    
    func carouselVerticalDidScroll(scrollView: UIScrollView) -> Void {
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: this_height * (_carouselData.count - 2))
        } else if Float(scrollView.contentOffset.y) >= Float(this_height) * (Float(_carouselData.count - 1)) {
            scrollView.contentOffset = CGPoint(x: CGFloat(0), y: CGFloat(this_height));
        }
    }
    
    func fetchCurrentPage() -> Int {
        
        var contentOffset:CGFloat = 0
        var widthOrHeight:CGFloat = 0
        
        if scrollDirection == ZZCarouselScrollDirection.left || scrollDirection == ZZCarouselScrollDirection.right {
            contentOffset = coreView.contentOffset.x
            widthOrHeight = CGFloat(this_width)
        }else if scrollDirection == ZZCarouselScrollDirection.top || scrollDirection == ZZCarouselScrollDirection.bottom {
            contentOffset = coreView.contentOffset.y
            widthOrHeight = CGFloat(this_height)
        }
        
        let page : Int = Int((contentOffset + widthOrHeight * CGFloat(0.5)) / widthOrHeight) - 1;
        
        if contentOffset > widthOrHeight * CGFloat(_carouselData.count - 2) {
            return 0
        }else if self.coreView.contentOffset.x < 0 {
            self.pageControl.currentPage = _carouselData.count - 3
            return _carouselData.count - 3
        }
        
        return page
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer.invalidate()
        timer = nil
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoScrollTimeInterval != 0.0 {
            self.createTimer()
        }
    }
    
    deinit {
        timer = nil
    }
    
}

