//
//  Example3ViewController.swift
//  ZZCarouselSwift
//
//  Created by Glianze on 2017/11/15.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit

class Example3ViewController: UIViewController,ZZCarouselDelegate {
    
    private lazy var carousel: ZZCarouselView = {
        let carousel = ZZCarouselView(direction: .left)
        return carousel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.view.backgroundColor = UIColor.white
        
        setupView()
        setupConstraints()
        
        let data = [
            ["title": "标题1","image": UIImage(named:"zz1.jpg") as Any],
            ["title": "标题2","image": UIImage(named:"zz2.jpg") as Any],
            ["title": "标题3","image": UIImage(named:"zz3.jpg") as Any],
            ["title": "标题4","image": UIImage(named:"zz4.jpg") as Any],
            ["title": "标题5","image": UIImage(named:"zz5.jpg") as Any],
        ]
        
        carousel.registerCarouselCell(cellClass: Example3Cell.classForCoder())
        
        carousel.setCurrentPageColor(color: UIColor.red)
        carousel.setDefaultPageColor(color: UIColor.yellow)
        carousel.delegate = self
//        carousel.setAutoScrollTimeInterval(timeInterval: 2)
        carousel.setIsAutoScroll(isAutoScroll: false)
        carousel.setPageControlAlignment(alignment: ZZCarouselPageAlignment.right)
        carousel.setCarouselData(carouselData: data as [AnyObject])
        carousel.tag = 1001
    }
    
    private func setupView() {
        self.view.addSubview(carousel)
    }
    
    private func setupConstraints() {
        let views: [String: Any] = ["carousel": carousel]
        var constraints: [NSLayoutConstraint] = []
        
        carousel.translatesAutoresizingMaskIntoConstraints = false
        
        let v_content = "V:|-[carousel]"
        let h_carousel = "H:|-0-[carousel]-0-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: v_content, options: .alignAllLeading, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: h_carousel, options: .alignAllTop, metrics: nil, views: views)
        constraints += [NSLayoutConstraint(item: carousel, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1/3, constant: 0)]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func carouselForItemCell(carouselView: ZZCarouselView, cell: UICollectionViewCell, indexItem: AnyObject) {
        let cell1: Example3Cell = cell as! Example3Cell
        cell1.loadData(model: indexItem as! Dictionary<String, AnyObject>)
    }
    
    func carouselDidSelectItemAtIndex(carouselView: ZZCarouselView, index: Int) {
        
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
