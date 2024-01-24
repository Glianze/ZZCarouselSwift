//
//  ExampleViewController.swift
//  ZZCarouselSwift
//
//  Created by Glianze on 2017/11/13.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController, ZZCarouselDelegate {
    
    private lazy var carousel: ZZCarouselView = {
        let carousel = ZZCarouselView(width: self.view.frame.size.width, direction: .top)
        return carousel
    }()
    
    private lazy var carousel1: ZZCarouselView = {
        let carousel = ZZCarouselView(width: self.view.frame.size.width, direction: .left)
        return carousel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        setupView()
        setupConstraints()
        
        let data = [UIImage(named:"zz1.jpg")!,UIImage(named:"zz2.jpg")!,UIImage(named:"zz3.jpg")!,UIImage(named:"zz4.jpg")!,UIImage(named:"zz5.jpg")!]
        
        carousel.registerCarouselCell(cellClass: Example1Cell.classForCoder())
        
        carousel.setCurrentPageColor(color: UIColor.red)
        carousel.setDefaultPageColor(color: UIColor.yellow)
        carousel.delegate = self
        carousel.setAutoScrollTimeInterval(timeInterval: 2)
        
        
        carousel.setPageControlAlignment(alignment: ZZCarouselPageAlignment.right)
        
        
        carousel.setCarouselData(carouselData: data)
        carousel.tag = 1001
        
        carousel1.registerCarouselCell(cellClass: ExampleCell.classForCoder())
        carousel1.delegate = self
        carousel1.setAutoScrollTimeInterval(timeInterval: 2)
        carousel1.setCarouselData(carouselData: data)
        
        carousel1.setPageControlAlignment(alignment: ZZCarouselPageAlignment.right)
        carousel1.tag = 1002
        
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
        constraints += [NSLayoutConstraint(item: carousel, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1/3, constant: 0)]
        constraints += [NSLayoutConstraint(item: carousel1, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1/3, constant: 0)]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func carouselForItemCell(carouselView: ZZCarouselView, cell: UICollectionViewCell, indexItem: AnyObject) {
        if cell.isKind(of: ExampleCell.self) {
            let cell1: ExampleCell = cell as! ExampleCell
            cell1.loadImage(image: indexItem as! UIImage)
        } else {
            let cell1: Example1Cell = cell as! Example1Cell
            cell1.loadImage(image: indexItem as! UIImage)
        }
    }
    
    func carouselDidSelectItemAtIndex(carouselView: ZZCarouselView, index: Int) {
        
        if carouselView.tag == 1001 {
            print("carousel 点击 %d",index)
        }else if carouselView.tag == 1002 {
            print("carousel11111 点击 %d",index)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
