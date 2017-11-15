//
//  Example2ViewController.swift
//  ZZCarouselSwift
//
//  Created by Glianze on 2017/11/15.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit

class Example2ViewController: UIViewController,ZZCarouselDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        let data = ["昨天晴天转多云0℃-100℃", "今日晴天转多云0℃-100℃", "明天晴天转多云0℃-100℃", "后天晴天转多云0℃-100℃"]
        
        let carousel = ZZCarouselView.init(frame: CGRect(x: 40, y: 84, width: self.view.frame.size.width - 80, height:40.0), direction: ZZCarouselScrollDirection.left)
        carousel.registerCarouselCell(cellClass: Example2Cell.classForCoder())
        carousel.setCurrentPageColor(color: UIColor.red)
        carousel.setDefaultPageColor(color: UIColor.yellow)
        carousel.delegate = self
        carousel.setAutoScrollTimeInterval(timeInterval: 3)
        carousel.setPageControlAlignment(alignment: ZZCarouselPageAlignment.right)
        carousel.setHiddenPageControl(hidden: true)
        self.view.addSubview(carousel)
        carousel.setCarouselData(carouselData: data as [AnyObject])
        
        
        let carousel1 = ZZCarouselView.init(frame: CGRect(x: 40, y: 144, width: self.view.frame.size.width - 80, height:40.0), direction: ZZCarouselScrollDirection.top)
        carousel1.registerCarouselCell(cellClass: Example2Cell.classForCoder())
        carousel1.setDefaultPageColor(color: UIColor.yellow)
        carousel1.delegate = self
        carousel1.setAutoScrollTimeInterval(timeInterval: 3)
        carousel1.setPageControlAlignment(alignment: ZZCarouselPageAlignment.right)
        carousel1.setHiddenPageControl(hidden: true)
        self.view.addSubview(carousel1)
        carousel1.setCarouselData(carouselData: data as [AnyObject])
        
    }
    
    func carouselForItemCell(carouselView: ZZCarouselView, cell: AnyObject, indexItem: AnyObject) {
        let cell1: Example2Cell = cell as! Example2Cell
        cell1.loadWebImage(imageUrl:indexItem as! String)
    }
    
    func carouselDidSelectItemAtIndex(carouselView: ZZCarouselView, index: Int) {
        
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
