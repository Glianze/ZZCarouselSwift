//
//  Example3ViewController.swift
//  ZZCarouselSwift
//
//  Created by Glianze on 2017/11/15.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit

class Example3ViewController: UIViewController,ZZCarouselDelegate {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.view.backgroundColor = UIColor.white
        
        let data = [
            ["title":"标题1","image":UIImage(named:"zz1.jpg") as Any],
            ["title":"标题2","image":UIImage(named:"zz2.jpg") as Any],
            ["title":"标题3","image":UIImage(named:"zz3.jpg") as Any],
            ["title":"标题4","image":UIImage(named:"zz4.jpg") as Any],
            ["title":"标题5","image":UIImage(named:"zz5.jpg") as Any],
        ]
        
        let carousel = ZZCarouselView.init(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height:self.view.frame.size.height / 3), direction: ZZCarouselScrollDirection.left)
        carousel.registerCarouselCell(cellClass: Example3Cell.classForCoder())
        
        carousel.setCurrentPageColor(color: UIColor.red)
        carousel.setDefaultPageColor(color: UIColor.yellow)
        carousel.delegate = self
        carousel.setAutoScrollTimeInterval(timeInterval: 2)
        carousel.setPageControlAlignment(alignment: ZZCarouselPageAlignment.right)
        carousel.setCarouselData(carouselData: data as [AnyObject])
        carousel.tag = 1001;
        self.view.addSubview(carousel)
    }
    
    func carouselForItemCell(carouselView: ZZCarouselView, cell: UICollectionViewCell, indexItem: AnyObject) {
        let cell1: Example3Cell = cell as! Example3Cell
        cell1.loadData(model: indexItem as! Dictionary<String, AnyObject>)
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
