//
//  Example4ViewController.swift
//  ZZCarouselSwiftDemo
//
//  Created by Glianze on 2017/11/28.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit

class Example4ViewController: UIViewController,ZZCarouselDelegate {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.backgroundColor = UIColor(white: 1, alpha: 0.001)
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private lazy var carousel: ZZCarouselView = {
        let carousel = ZZCarouselView(direction: .top)
        return carousel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
        setupView()
        setupConstraints()
        self.createTaobaoStyle()
    }
    
    func createTaobaoStyle() -> Void {
        imageView.image = UIImage.init(named: "tb_info_image")
        
        let data = [["title":"iPhoneX SEPlus美爆了，独家曝光","type":1,"subTitle":"X只是过渡 iphone11才是重头戏"],["title":"22万也能开特斯拉，上市当天订单","type":2,"subTitle":"众泰版奔驰来了，网友改装"],["title":"数据结构并非淘宝数据结构","type":3,"subTitle":"仿淘宝样式而已，后期需要自行处理"]
        ]
        
        carousel.registerCarouselCell(cellClass: Example4TaobaoCell.classForCoder())
        carousel.setCurrentPageColor(color: UIColor.red)
        carousel.setDefaultPageColor(color: UIColor.yellow)
        carousel.delegate = self
        carousel.setAutoScrollTimeInterval(timeInterval: 3)
        carousel.setPageControlAlignment(alignment: ZZCarouselPageAlignment.right)
        carousel.setHiddenPageControl(hidden: true)
        carousel.setDisableScroll(disableScroll: false)
        carousel.setCarouselData(carouselData: data as [AnyObject])
        carousel.reloadData()
    }
    
    private func setupView() {
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(carousel)
    }
    
    private func setupConstraints() {
        let views: [String: Any] = ["stackView": stackView]
        var constraints: [NSLayoutConstraint] = []
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let v_stackView = "V:|-[stackView]"
        let h_stackView = "H:|-0-[stackView]-0-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: v_stackView, options: .alignAllLeading, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: h_stackView, options: .alignAllTop, metrics: nil, views: views)
        constraints += [NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)]
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        constraints += [NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)]
        NSLayoutConstraint.activate(constraints)
        
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
