//
//  Example4ViewController.swift
//  ZZCarouselSwiftDemo
//
//  Created by Glianze on 2017/11/28.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit

class Example4ViewController: UIViewController,ZZCarouselDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
        
        self.createTaobaoStyle()
    }
    
    func createTaobaoStyle() -> Void {
        let imageView = UIImageView.init(frame: CGRect(x: 15, y: 84, width: 40, height: 40));
        imageView.image = UIImage.init(named: "tb_info_image")
        self.view.addSubview(imageView);
        
        let data = [["title":"iPhoneX SEPlus美爆了，独家曝光","type":1,"subTitle":"X只是过渡 iphone11才是重头戏"],["title":"22万也能开特斯拉，上市当天订单","type":2,"subTitle":"众泰版奔驰来了，网友改装"],["title":"数据结构并非淘宝数据结构","type":3,"subTitle":"仿淘宝样式而已，后期需要自行处理"]
        ]
        
        let carousel = ZZCarouselView.init(frame: CGRect(x: 60, y: 84, width: self.view.frame.size.width - 60, height:40.0), direction: ZZCarouselScrollDirection.top)
        carousel.registerCarouselCell(cellClass: Example4TaobaoCell.classForCoder())
        carousel.setCurrentPageColor(color: UIColor.red)
        carousel.setDefaultPageColor(color: UIColor.yellow)
        carousel.delegate = self
        carousel.setAutoScrollTimeInterval(timeInterval: 3)
        carousel.setPageControlAlignment(alignment: ZZCarouselPageAlignment.right)
        carousel.setHiddenPageControl(hidden: true)
        carousel.setDisableScroll(disableScroll: false)
        self.view.addSubview(carousel)
        carousel.setCarouselData(carouselData: data as [AnyObject])
        
    }
    
    func carouselForItemCell(carouselView: ZZCarouselView, cell: UICollectionViewCell, indexItem: AnyObject) {
        let cell1: Example4TaobaoCell = cell as! Example4TaobaoCell

        
        cell1.loadData(data: indexItem as! Dictionary<String, Any>)
    }
    
    func carouselDidSelectItemAtIndex(carouselView: ZZCarouselView, index: Int) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
