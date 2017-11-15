//
//  Example1ViewController.swift
//  ZZCarouselSwift
//
//  Created by Glianze on 2017/11/15.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit

class Example1ViewController: UIViewController,ZZCarouselDelegate {

    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        let data = ["http://i1.douguo.net//upload/banner/0/6/a/06e051d7378040e13af03db6d93ffbfa.jpg", "http://i1.douguo.net//upload/banner/9/3/4/93f959b4e84ecc362c52276e96104b74.jpg", "http://i1.douguo.net//upload/banner/d/8/2/d89f438789ee1b381966c1361928cb32.jpg"]
        
        let carousel = ZZCarouselView.init(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height:self.view.frame.size.height / 3), direction: ZZCarouselScrollDirection.left)
        carousel.registerCarouselCell(cellClass: Example1Cell.classForCoder())

        carousel.setCurrentPageColor(color: UIColor.red)
        carousel.setDefaultPageColor(color: UIColor.yellow)
        carousel.delegate = self
        carousel.setAutoScrollTimeInterval(timeInterval: 2)
        carousel.setPageControlAlignment(alignment: ZZCarouselPageAlignment.right)
        carousel.tag = 1001;
        self.view.addSubview(carousel)
        
        
        carousel.setCarouselData(carouselData: data as [AnyObject])
    }
    
    func carouselForItemCell(carouselView: ZZCarouselView, cell: AnyObject, indexItem: AnyObject) {
        let cell1: Example1Cell = cell as! Example1Cell
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
