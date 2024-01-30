//
//  Example2ViewController.swift
//  ZZCarouselSwift
//
//  Created by Glianze on 2017/11/15.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit

class Example2ViewController: UIViewController,ZZCarouselDelegate {
    
    private lazy var carousel: ZZCarouselView = {
        let carousel = ZZCarouselView(width: self.view.frame.size.width, direction: .left)
        return carousel
    }()
    
    private lazy var carousel1: ZZCarouselView = {
        let carousel = ZZCarouselView(width: self.view.frame.size.width, direction: .top)
        return carousel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        setupView()
        setupConstraints()
        
        self.textCarouselDemo()
        
    }
    
    func textCarouselDemo() -> Void {
        let data = ["昨天晴天转多云0℃-100℃", "今日晴天转多云0℃-100℃", "明天晴天转多云0℃-100℃", "后天晴天转多云0℃-100℃"]
        
        carousel.registerCarouselCell(cellClass: Example2Cell.classForCoder())
        carousel.setCurrentPageColor(color: UIColor.red)
        carousel.setDefaultPageColor(color: UIColor.yellow)
        carousel.delegate = self
        carousel.setAutoScrollTimeInterval(timeInterval: 3)
        carousel.setPageControlAlignment(alignment: ZZCarouselPageAlignment.right)
        carousel.setHiddenPageControl(hidden: true)
        carousel.setDisableScroll(disableScroll: false)
        carousel.setCarouselData(carouselData: data as [AnyObject])
        
        carousel1.registerCarouselCell(cellClass: Example2Cell.classForCoder())
        carousel1.setDefaultPageColor(color: UIColor.yellow)
        carousel1.delegate = self
        carousel1.setAutoScrollTimeInterval(timeInterval: 3)
        carousel1.setPageControlAlignment(alignment: ZZCarouselPageAlignment.right)
        carousel1.setHiddenPageControl(hidden: true)
        carousel1.setDisableScroll(disableScroll: false)
        carousel1.setCarouselData(carouselData: data as [AnyObject])
    }
    
    private func setupView() {
        self.view.addSubview(carousel)
        self.view.addSubview(carousel1)
    }
    
    private func setupConstraints() {
        let views: [String: Any] = ["carousel": carousel,
                                    "carousel1": carousel1]
        var constraints: [NSLayoutConstraint] = []
        
        carousel.translatesAutoresizingMaskIntoConstraints = false
        carousel1.translatesAutoresizingMaskIntoConstraints = false
        
        let v_content = "V:|-[carousel]-84-[carousel1]"
        let h_carousel = "H:|-0-[carousel]-0-|"
        let h_carousel1 = "H:|-0-[carousel1]-0-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: v_content, options: .alignAllLeading, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: h_carousel, options: .alignAllTop, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: h_carousel1, options: .alignAllTop, metrics: nil, views: views)
        constraints += [NSLayoutConstraint(item: carousel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)]
        constraints += [NSLayoutConstraint(item: carousel1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func carouselForItemCell(carouselView: ZZCarouselView, cell: UICollectionViewCell, indexItem: AnyObject) {
        let cell1: Example2Cell = cell as! Example2Cell
        cell1.loadWebImage(imageUrl:indexItem as! String)
    }
    
    func carouselDidSelectItemAtIndex(carouselView: ZZCarouselView, index: Int) {
        
        print(index)
        
    }
    
    func totalItemPagger(total: Int) {
        
    }
    
    func updatePaggerPosition(index: Int) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
