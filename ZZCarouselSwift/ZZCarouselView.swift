//
//  ZZCarouselView.swift
//  ZZCarouselSwift
//
//  Created by Glianze on 2017/11/15.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit

public protocol ZZCarouselDelegate:class {
    func carouselForItemCell(carouselView: ZZCarouselView, cell: UICollectionViewCell, indexItem: AnyObject)
    func carouselDidSelectItemAtIndex(carouselView: ZZCarouselView, index: Int)
    func totalItemPagger(total: Int)
    func updatePaggerPosition(index: Int)
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

open class ZZCarouselView: UIView {
    
    private var _carouselData : [AnyObject] = []
    private var cellClass : AnyClass?
    private var timer : Timer?
    private var autoScrollTimeInterval : Double = 0
    private var scrollDirection : ZZCarouselScrollDirection = .left
    private var pageControlAlignment : ZZCarouselPageAlignment = ZZCarouselPageAlignment.center
    private var hiddenPageControl : Bool?
    private var currentPageColor : UIColor?
    private var defaultPageColor : UIColor?
    private var isAutoScroll : Bool = true
    
    private var coreView : UICollectionView = {
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        
        collectionView.isPagingEnabled = true
        
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    private var pageControl : UIPageControl = {
        let pageView = UIPageControl()
        return pageView
    }()
    var backgroundView : UIImageView = {
        let image = UIImageView()
        return image
    }()
    private var this_width : CGFloat = 0
    
    public weak var delegate : ZZCarouselDelegate?
    
    public init(width: Double? = nil, direction: ZZCarouselScrollDirection) {
        super.init(frame: .zero)
        
        setupView()
        setupConstraint()
        
        if let width {
            if direction == .left || direction == .right {
                this_width = width
            } else {
                
            }
            
        } else {
            
        }
        
        self.scrollDirection = direction
        
        instance()
        makeCoreUI(direction: direction)
        makePageControlUI()
    }
    
    private func instance() {
        pageControlAlignment = ZZCarouselPageAlignment.center
        isAutoScroll = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.invalidateTimer()
    }
    
    private func setupView() {
        self.addSubview(backgroundView)
        self.addSubview(coreView)
        self.addSubview(pageControl)
    }
    
    private func setupConstraint() {
        var constraints: [NSLayoutConstraint] = []
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        constraints += [NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)]
        
        coreView.translatesAutoresizingMaskIntoConstraints = false
        constraints += [NSLayoutConstraint(item: coreView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: coreView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: coreView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: coreView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: coreView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)]
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        constraints += [NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)]
        let pageControlConstraints = NSLayoutConstraint(item: pageControl, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        pageControlConstraints.identifier = "pageControlConstraints"
        constraints += [pageControlConstraints]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func makeCoreUI(direction: ZZCarouselScrollDirection) {
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.borderWidth = 0
        backgroundView.contentMode = UIView.ContentMode.scaleToFill
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        flowLayout.itemSize = CGSize(width: this_width, height: this_height)
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        
        if direction == ZZCarouselScrollDirection.left || direction == ZZCarouselScrollDirection.right {
            flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        } else if direction == ZZCarouselScrollDirection.top || direction == ZZCarouselScrollDirection.bottom {
            flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        }
        
        self.coreView.collectionViewLayout = flowLayout
        
        self.coreView.dataSource = self
        self.coreView.delegate = self
    }
    
    private func makePageControlUI(frame: CGRect) {
        self.pageControl.backgroundColor = UIColor.clear
        self.pageControl.isUserInteractionEnabled = false
        
    }
    
    private func makePageControlUI() {
        self.pageControl.backgroundColor = UIColor.clear
        self.pageControl.isUserInteractionEnabled = false
    }
    
    public func registerCarouselCell(cellClass: AnyClass) {
        self.cellClass = cellClass
        coreView.register(self.cellClass, forCellWithReuseIdentifier: String(describing: self.cellClass))
        coreView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "defaultCell")
    }
    
    public func setAutoScrollTimeInterval(timeInterval: Double) -> Void {
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
        self.coreView.performBatchUpdates(nil, completion: { [weak self] _ in
            if let curentPage = self?.fetchCurrentPage() {
                self?.pageControl.currentPage = curentPage
            }
            
        })
    }
    
    private func settingPageControlAlignment() {
        var page_x: CGFloat = 0.0
        var constraints = self.constraints
        
        if let index = constraints.firstIndex(where: {$0.identifier == "pageControlConstraints"}) {
            NSLayoutConstraint.deactivate(constraints)
            
            if pageControlAlignment == ZZCarouselPageAlignment.left {
                page_x = 5
            } else if pageControlAlignment == ZZCarouselPageAlignment.right {
                page_x = -(5)
            }
            
            if pageControlAlignment == ZZCarouselPageAlignment.left {
                constraints[index] = NSLayoutConstraint(item: pageControl, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: page_x)
            } else if pageControlAlignment == ZZCarouselPageAlignment.right {
                constraints[index] = NSLayoutConstraint(item: pageControl, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: page_x)
            } else if pageControlAlignment == ZZCarouselPageAlignment.center {
                constraints[index] = NSLayoutConstraint(item: pageControl, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            } else {
                constraints[index] = NSLayoutConstraint(item: pageControl, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            }
            constraints[index].identifier = "pageControlConstraints"
            NSLayoutConstraint.activate(constraints)
            pageControl.layoutIfNeeded()
            self.layoutIfNeeded()
        }
        
    }
    
    public func setCarouselData(carouselData: [AnyObject]) {
        if !carouselData.isEmpty {
            _carouselData = self.remakeCarouselData(data: carouselData)
            self.coreView.reloadData()
            
            self.coreView.performBatchUpdates(nil, completion: { [weak self] _ in
                
                if carouselData.count == 1 {
                    self?.pageControl.isHidden = true
                    self?.delegate?.totalItemPagger(total: 1)
                    self?.invalidateTimer()
                } else {
                    self?.pageControl.numberOfPages = carouselData.count
                    self?.delegate?.totalItemPagger(total: carouselData.count)
                    self?.settingPageControlAlignment()
                    self?.defaultContentOffset()
                    self?.createTimer()
                }
                
                if let curentPage = self?.fetchCurrentPage() {
                    self?.pageControl.currentPage = curentPage
                    self?.delegate?.updatePaggerPosition(index: curentPage)
                }
                
                if !(self?.isAutoScroll ?? false) {
                    self?.invalidateTimer()
                }
            })
        }
    }
    
    private func remakeCarouselData(data: [AnyObject]) -> [AnyObject] {
        if data.count == 1 {
            return data
        } else {
            var carousel_data : [AnyObject] = [AnyObject]()
            if let last = data.last, let first = data.first {
                carousel_data.append(last)
                for item in data {
                    carousel_data.append(item)
                }
                carousel_data.append(first)
            }
            return carousel_data
        }
    }
    
    private func defaultContentOffset() {
        if scrollDirection == ZZCarouselScrollDirection.left || scrollDirection == ZZCarouselScrollDirection.right {
            if this_width != 0 {
                self.coreView.contentOffset = CGPoint(x: this_width, y: 0)
            } else {
                self.coreView.contentOffset = CGPoint(x: self.frame.width, y: 0)
            }
            
        } else if scrollDirection == ZZCarouselScrollDirection.top || scrollDirection == ZZCarouselScrollDirection.bottom {
            self.coreView.contentOffset = CGPoint(x: 0, y: self.frame.height)
        }
    }
    
    private func createTimer() -> Void {
        self.invalidateTimer()
        let timer = Timer.scheduledTimer(timeInterval: Double(self.autoScrollTimeInterval), target: self, selector: #selector(self.autoCarouselScroll), userInfo: nil, repeats: true)
        self.timer = timer
        RunLoop.main.add(timer, forMode:RunLoop.Mode.common)
    }
    
    @objc func autoCarouselScroll() {
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
    
    private func autoCarouselScrollWithDirection(direction: ZZCarouselScrollDirection) {
        var contentPoint: CGPoint = CGPoint(x:0.0, y:0.0)
        
        if direction == ZZCarouselScrollDirection.left {
            if this_width != 0 {
                contentPoint = CGPoint(x: self.coreView.contentOffset.x + CGFloat(this_width), y: 0.0)
            } else {
                contentPoint = CGPoint(x: self.coreView.contentOffset.x + CGFloat(self.frame.width), y: 0.0)
            }
            
        } else if direction == ZZCarouselScrollDirection.right {
            if this_width != 0 {
                contentPoint = CGPoint(x: self.coreView.contentOffset.x - CGFloat(this_width), y: 0.0)
            } else {
                contentPoint = CGPoint(x: self.coreView.contentOffset.x - CGFloat(self.frame.width), y: 0.0)
            }
        } else if direction == ZZCarouselScrollDirection.top {
            contentPoint = CGPoint(x: 0.0, y: self.coreView.contentOffset.y + self.frame.height)
        } else if direction == ZZCarouselScrollDirection.bottom {
            contentPoint = CGPoint(x: 0.0, y: self.coreView.contentOffset.y - self.frame.height)
        }
        self.coreView.setContentOffset(contentPoint, animated: true)
    }
    
    private func carouselHorizontalDidScroll(scrollView: UIScrollView) {
        
        var currentWidth = this_width
        
        if currentWidth == 0 {
            currentWidth = self.frame.width
        }
        
        if scrollView.contentOffset.x <= 0 {
            scrollView.contentOffset = CGPoint(x: Int(currentWidth) * (_carouselData.count - 2), y: 0);
        } else if scrollView.contentOffset.x >= currentWidth * CGFloat(_carouselData.count - 1) {
            scrollView.contentOffset = CGPoint(x: Int(currentWidth), y: 0);
        }
    }
    
    private func carouselVerticalDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: self.frame.height * CGFloat(_carouselData.count - 2))
        } else if scrollView.contentOffset.y >= self.frame.height * CGFloat(_carouselData.count - 1) {
            scrollView.contentOffset = CGPoint(x: CGFloat(0), y: self.frame.height);
        }
    }
    
    private func fetchCurrentPage() -> Int {
        
        var contentOffset: CGFloat = 0
        var widthOrHeight: CGFloat = 0
        
        if scrollDirection == ZZCarouselScrollDirection.left || scrollDirection == ZZCarouselScrollDirection.right {
            contentOffset = coreView.contentOffset.x
            widthOrHeight = CGFloat(this_width)
            
            if widthOrHeight == 0 {
                widthOrHeight = CGFloat(self.frame.width)
            }
            
        } else if scrollDirection == ZZCarouselScrollDirection.top || scrollDirection == ZZCarouselScrollDirection.bottom {
            contentOffset = coreView.contentOffset.y
            widthOrHeight = CGFloat(self.frame.height)
        }
        
        let page: Int = Int((contentOffset + widthOrHeight * CGFloat(0.5)) / widthOrHeight) - 1
        
        if contentOffset > widthOrHeight * CGFloat(_carouselData.count - 2) + widthOrHeight * 0.5 {
            return 0
        } else if contentOffset < widthOrHeight * 0.5 {
            return _carouselData.count - 3
        }
        
        return page
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.invalidateTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoScrollTimeInterval != 0.0 && isAutoScroll {
            self.createTimer()
        }
    }
    
    private func invalidateTimer() -> Void {
        timer?.invalidate()
        timer = nil
    }
    
}

extension ZZCarouselView: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _carouselData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let _ = cellClass else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell", for: indexPath)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: self.cellClass), for: indexPath)
        if self.delegate != nil {
            self.delegate!.carouselForItemCell(carouselView: self, cell: cell, indexItem: self._carouselData[indexPath.row])
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.carouselDidSelectItemAtIndex(carouselView: self, index: indexPath.row-1)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = fetchCurrentPage()
        self.pageControl.currentPage = index
        self.delegate?.updatePaggerPosition(index: index)
        if scrollDirection == ZZCarouselScrollDirection.left || scrollDirection == ZZCarouselScrollDirection.right {
            self.carouselHorizontalDidScroll(scrollView: scrollView)
        } else if scrollDirection == ZZCarouselScrollDirection.top || scrollDirection == ZZCarouselScrollDirection.bottom {
            self.carouselVerticalDidScroll(scrollView: scrollView)
        }
    }
}

extension ZZCarouselView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if scrollDirection == .left || scrollDirection == .right {
            if this_width != 0 {
                return CGSize(width: this_width, height: self.coreView.frame.height)
            } else {
                return CGSize(width: self.coreView.frame.width, height: self.coreView.frame.height)
            }
        } else {
            return CGSize(width: self.coreView.frame.width, height: self.coreView.frame.height)
        }
    }
}
