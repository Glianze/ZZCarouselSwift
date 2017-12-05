//
//  ZZCarouselView.swift
//  ZZCarouselSwift
//
//  Created by Glianze on 2017/11/15.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit

public protocol ZZCarouselDelegate:class {
    func carouselForItemCell(carouselView:ZZCarouselView, cell:AnyObject, indexItem:AnyObject) -> Void
    func carouselDidSelectItemAtIndex(carouselView:ZZCarouselView, index: Int) -> Void
}

public enum ZZCarouselPageAlignment{
    case left
    case right
    case center
}

public enum ZZCarouselScrollDirection{
    case left
    case right
    case top
    case bottom
}

open class ZZCarouselView: UIView,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate {
    
    private var _carouselData : [AnyObject]!
    private var cellClass : AnyClass!
    private var timer : Timer?
    private var autoScrollTimeInterval : Float!
    private var scrollDirection : ZZCarouselScrollDirection!
    private var pageControlAlignment : ZZCarouselPageAlignment!
    private var hiddenPageControl : Bool?
    private var currentPageColor : UIColor?
    private var defaultPageColor : UIColor?
    private var isAutoScroll : Bool?
    
    private var coreView : UICollectionView!
    private var pageControl : UIPageControl!
    var backgroundView : UIImageView?
    private var this_width : Int!
    private var this_height : Int!
    
    public weak var delegate : ZZCarouselDelegate?
    
    public init(frame: CGRect, direction: ZZCarouselScrollDirection) {
        super.init(frame: frame)
        
        this_width = Int(frame.size.width)
        this_height = Int(frame.size.height)
        
        self.scrollDirection = direction
        
        self.resettingSelfFrame(frame: frame)
        self.instance()
        self.makeCoreUI(direction: direction);
        self.makePageControlUI(frame: frame)
    }
    
    private func resettingSelfFrame(frame: CGRect) -> Void {
        self.frame = CGRect(x: frame.origin.x,y: frame.origin.y, width: CGFloat(this_width), height: CGFloat(this_height))
    }
    
    private func instance() -> Void {
        autoScrollTimeInterval = 0
        pageControlAlignment = ZZCarouselPageAlignment.center
        isAutoScroll = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func makeCoreUI(direction: ZZCarouselScrollDirection) -> Void {
        backgroundView = UIImageView.init(frame: CGRect(x:0.0 ,y: 0.0, width: CGFloat(this_width), height: CGFloat(this_height)))
        backgroundView?.layer.masksToBounds = true
        backgroundView?.layer.borderWidth = 0
        backgroundView?.contentMode = UIViewContentMode.scaleToFill
        self.addSubview(backgroundView!)
        
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
        self.coreView.isScrollEnabled = true
        self.addSubview(self.coreView)
    }
    
    private func makePageControlUI(frame: CGRect) -> Void {
        self.pageControl = UIPageControl.init(frame: CGRect(x:0.0 ,y: CGFloat(this_height - 20), width: CGFloat(this_width), height: 20.0))
        self.pageControl.backgroundColor = UIColor.clear
        self.addSubview(self.pageControl)
    }
    
    public func registerCarouselCell(cellClass: AnyClass) -> Void {
        self.cellClass = cellClass
        coreView.register(self.cellClass, forCellWithReuseIdentifier: String(describing: self.cellClass))
    }
    
    public func setAutoScrollTimeInterval(timeInterval: Float) -> Void {
        self.autoScrollTimeInterval = timeInterval
    }
    
    public func setCurrentPageColor(color: UIColor) -> Void {
        self.pageControl.currentPageIndicatorTintColor = color
    }
    
    public func setDefaultPageColor(color: UIColor) -> Void {
        self.pageControl.pageIndicatorTintColor = color
    }
    
    public func setPageControlAlignment(alignment: ZZCarouselPageAlignment) -> Void {
        pageControlAlignment = alignment
    }
    
    public func setHiddenPageControl(hidden: Bool) -> Void {
        pageControl.isHidden = hidden
    }
    
    public func setDisableScroll(disableScroll: Bool) -> Void {
        self.coreView.isScrollEnabled = disableScroll
    }
    
    func setIsAutoScroll(isAutoScroll:Bool) -> Void {
        self.isAutoScroll = isAutoScroll
    }
    
    public func benginAutoScroll() -> Void {
        self.createTimer()
    }
    
    public func endAutoScroll() -> Void {
        self.invalidateTimer()
    }
    
    public func reloadData() -> Void {
        self.coreView.reloadData()
    }
    
    private func settingPageControlAlignment() -> Void {
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
    
    public func setCarouselData(carouselData: [AnyObject]) -> Void {
        if !carouselData.isEmpty {
            _carouselData = self.remakeCarouselData(data: carouselData)
            self.coreView.reloadData()
            if carouselData.count == 1 {
                self.pageControl.isHidden = true
                self.invalidateTimer()
            }else {
                self.pageControl.numberOfPages = carouselData.count
                self.settingPageControlAlignment()
                self.defaultContentOffset()
                self.createTimer()
            }
            
            if !self.isAutoScroll! {
                self.invalidateTimer()
            }
        }
    }
    
    private func remakeCarouselData(data: [AnyObject]) -> [AnyObject] {
        if data.count == 1 {
            return data
        } else {
            var carousel_data : [AnyObject] = [AnyObject]()
            carousel_data.append(data.last!)
            for item in data {
                carousel_data.append(item)
            }
            carousel_data.append(data.first!)
            return carousel_data
        }
    }
    
    private func defaultContentOffset() -> Void {
        if scrollDirection == ZZCarouselScrollDirection.left || scrollDirection == ZZCarouselScrollDirection.right {
            self.coreView.contentOffset = CGPoint(x: this_width, y: 0)
        }else if scrollDirection == ZZCarouselScrollDirection.top || scrollDirection == ZZCarouselScrollDirection.bottom {
            self.coreView.contentOffset = CGPoint(x: 0, y: this_height)
        }
    }
    
    private func createTimer() -> Void {
        self.invalidateTimer()
        let timer = Timer.scheduledTimer(timeInterval: Double(self.autoScrollTimeInterval), target: self, selector: #selector(self.autoCarouselScroll), userInfo: nil, repeats: true)
        self.timer = timer
        RunLoop.main.add(timer, forMode:RunLoopMode.commonModes)
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
    
    private func autoCarouselScrollWithDirection(direction: ZZCarouselScrollDirection) -> Void {
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
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _carouselData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: self.cellClass), for: indexPath)
        self.delegate?.carouselForItemCell(carouselView: self, cell: cell, indexItem: self._carouselData[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.carouselDidSelectItemAtIndex(carouselView: self, index: indexPath.row-1)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = fetchCurrentPage();
        if scrollDirection == ZZCarouselScrollDirection.left || scrollDirection == ZZCarouselScrollDirection.right {
            self.carouselHorizontalDidScroll(scrollView: scrollView)
        }else if scrollDirection == ZZCarouselScrollDirection.top || scrollDirection == ZZCarouselScrollDirection.bottom {
            self.carouselVerticalDidScroll(scrollView: scrollView)
        }
    }
    
    private func carouselHorizontalDidScroll(scrollView: UIScrollView) -> Void {
        if scrollView.contentOffset.x <= 0 {
            scrollView.contentOffset = CGPoint(x: Int(this_width) * (_carouselData.count - 2), y: 0);
        } else if Float(scrollView.contentOffset.x) >= Float(this_width) * (Float(_carouselData.count - 1)) {
            scrollView.contentOffset = CGPoint(x: Int(this_width), y: 0);
        }
    }
    
    private func carouselVerticalDidScroll(scrollView: UIScrollView) -> Void {
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: this_height * (_carouselData.count - 2))
        } else if Float(scrollView.contentOffset.y) >= Float(this_height) * (Float(_carouselData.count - 1)) {
            scrollView.contentOffset = CGPoint(x: CGFloat(0), y: CGFloat(this_height));
        }
    }
    
    private func fetchCurrentPage() -> Int {
        
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
        
        if contentOffset > widthOrHeight * CGFloat(_carouselData.count - 2) + widthOrHeight * 0.5 {
            return 0
        }else if contentOffset < widthOrHeight * 0.5 {
            return _carouselData.count - 3
        }
        
        return page
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.invalidateTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoScrollTimeInterval != 0.0 && isAutoScroll!{
            self.createTimer()
        }
    }
    
    private func invalidateTimer() -> Void {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        self.invalidateTimer()
    }
    
}

