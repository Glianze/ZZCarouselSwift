//
//  ViewController.swift
//  ZZCarouselSwiftDemo
//
//  Created by Glianze on 2017/11/15.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ZZCarouselDelegate{
    
    var tableView : UITableView!
    var carousel : ZZCarouselView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "ZZCarouselSwift"
        
        self.view.backgroundColor = UIColor.white
        
        tableView = UITableView.init(frame: self.view.bounds, style: UITableView.Style.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        self.instanceCarousel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        carousel.benginAutoScroll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        carousel.endAutoScroll()
    }
    
    func instanceCarousel() -> Void {
        let data = ["http://desk.fd.zol-img.com.cn/t_s960x600c5/g5/M00/02/02/ChMkJ1bKxc6IWCE_AAv1GUaUIDYAALHbgFXFK8AC_Ux808.jpg", "http://desk.fd.zol-img.com.cn/t_s960x600c5/g5/M00/02/01/ChMkJlbKxOCIZep0AAU2iZgswEUAALHNgIwWqUABTah055.jpg", "http://desk.fd.zol-img.com.cn/t_s960x600c5/g5/M00/02/01/ChMkJ1bKxOCISXDzAAifUTXHGcMAALHNgI1kUYACJ9p541.jpg","http://desk.fd.zol-img.com.cn/t_s960x600c5/g5/M00/02/01/ChMkJlbKxOCIHZvIAAU6HMJ3XvcAALHNgJBs5oABTo0258.jpg","http://desk.fd.zol-img.com.cn/t_s960x600c5/g5/M00/02/01/ChMkJlbKxOCIDZULAAMuVR0j3-MAALHNgJ_ws4AAy5t818.jpg"]
        
        carousel = ZZCarouselView.init(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height:150), direction: ZZCarouselScrollDirection.left)
        carousel.registerCarouselCell(cellClass: Example1Cell.self)
        
        carousel.setCurrentPageColor(color: UIColor.orange)
        carousel.setDefaultPageColor(color: UIColor.white)
        carousel.delegate = self
        carousel.setAutoScrollTimeInterval(timeInterval: 4)
        carousel.setPageControlAlignment(alignment: ZZCarouselPageAlignment.center)
        carousel.tag = 1001;
        
        carousel.setCarouselData(carouselData: data as [AnyObject])
    }
    
    func carouselForItemCell(carouselView: ZZCarouselView, cell: AnyObject, indexItem: AnyObject) {
        let cell1: Example1Cell = cell as! Example1Cell
        cell1.loadWebImage(imageUrl:indexItem as! String)
    }
    
    func carouselDidSelectItemAtIndex(carouselView: ZZCarouselView, index: Int) {
        print(index)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        }
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell?.textLabel?.text = "本地图片"
                cell?.detailTextLabel?.text = "Class-:-ExampleViewController"
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = "使用Kingfisher加载图片"
                cell?.detailTextLabel?.text = "Class-:-Example1ViewController"
            } else if indexPath.row == 2{
                cell?.textLabel?.text = "自定义cell轮播"
                cell?.detailTextLabel?.text = "Class-:-Example3ViewController"
            }
        }else {
            if indexPath.row == 0{
                cell?.textLabel?.text = "纯文字轮播"
                cell?.detailTextLabel?.text = "Class-:-Example2ViewController"
            } else if indexPath.row == 1{
                cell?.textLabel?.text = "仿淘宝头条样式"
                cell?.detailTextLabel?.text = "Class-:-Example4ViewController"
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let ex = ExampleViewController()
                self.navigationController?.pushViewController(ex, animated: true)
            }else if indexPath.row == 1 {
                let ex1 = Example1ViewController()
                self.navigationController?.pushViewController(ex1, animated: true)
            }else if indexPath.row == 2 {
                let ex1 = Example3ViewController()
                self.navigationController?.pushViewController(ex1, animated: true)
            }
        }else {
            if indexPath.row == 0 {
                let ex1 = Example2ViewController()
                self.navigationController?.pushViewController(ex1, animated: true)
            }else if indexPath.row == 1 {
                let ex1 = Example4ViewController()
                self.navigationController?.pushViewController(ex1, animated: true)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 150
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return section == 0 ? carousel : nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


