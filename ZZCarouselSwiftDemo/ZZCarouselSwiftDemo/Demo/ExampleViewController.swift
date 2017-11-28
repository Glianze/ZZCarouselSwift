//
//  ExampleViewController.swift
//  ZZCarouselSwift
//
//  Created by Glianze on 2017/11/13.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController,ZZCarouselDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        
        let data = [UIImage(named:"zz1.jpg")!,UIImage(named:"zz2.jpg")!,UIImage(named:"zz3.jpg")!,UIImage(named:"zz4.jpg")!,UIImage(named:"zz5.jpg")!]
        
        let carousel = ZZCarouselView.init(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height:self.view.frame.size.height / 3), direction: ZZCarouselScrollDirection.top)
        carousel.registerCarouselCell(cellClass: Example1Cell.classForCoder())
        
        carousel.setCurrentPageColor(color: UIColor.red)
        carousel.setDefaultPageColor(color: UIColor.yellow)
        carousel.delegate = self
        carousel.setAutoScrollTimeInterval(timeInterval: 2)
        
        
        carousel.setPageControlAlignment(alignment: ZZCarouselPageAlignment.right)
        
        
        carousel.setCarouselData(carouselData: data)
        carousel.tag = 1001;
        self.view.addSubview(carousel)
        
        
        let carousel1 = ZZCarouselView.init(frame: CGRect(x: 0, y: self.view.frame.size.height / 3 + 84.0, width: self.view.frame.size.width, height:self.view.frame.size.height / 3), direction: ZZCarouselScrollDirection.left)
        
        carousel1.delegate = self
        carousel1.setAutoScrollTimeInterval(timeInterval: 2)
        carousel1.setCarouselData(carouselData: data)
        
        carousel1.registerCarouselCell(cellClass: ExampleCell.classForCoder())
        carousel1.setPageControlAlignment(alignment: ZZCarouselPageAlignment.right)
        //        carousel.setCurrentPageColor(color: UIColor.red)
        //        carousel.setDefaultPageColor(color: UIColor.yellow)
        carousel1.tag = 1002
        self.view.addSubview(carousel1)
    }
    
    func carouselForItemCell(carouselView: ZZCarouselView, cell: AnyObject, indexItem: AnyObject) {
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
