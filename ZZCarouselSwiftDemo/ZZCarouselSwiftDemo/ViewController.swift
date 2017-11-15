//
//  ViewController.swift
//  ZZCarouselSwiftDemo
//
//  Created by Glianze on 2017/11/15.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var tableView : UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "ZZCarouselSwift"
        
        self.view.backgroundColor = UIColor.white
        
        tableView = UITableView.init(frame: self.view.bounds, style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        }
        if indexPath.row == 0 {
            cell?.textLabel?.text = "本地图片"
            cell?.detailTextLabel?.text = "Class-:-ExampleViewController"
        } else if indexPath.row == 1 {
            cell?.textLabel?.text = "使用Kingfisher加载图片"
            cell?.detailTextLabel?.text = "Class-:-Example1ViewController"
        } else if indexPath.row == 2{
            cell?.textLabel?.text = "纯文字轮播"
            cell?.detailTextLabel?.text = "Class-:-Example2ViewController"
        } else if indexPath.row == 3{
            cell?.textLabel?.text = "自定义cell轮播"
            cell?.detailTextLabel?.text = "Class-:-Example3ViewController"
        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let ex = ExampleViewController()
            self.navigationController?.pushViewController(ex, animated: true)
        }else if indexPath.row == 1 {
            let ex1 = Example1ViewController()
            self.navigationController?.pushViewController(ex1, animated: true)
        }else if indexPath.row == 2 {
            let ex1 = Example2ViewController()
            self.navigationController?.pushViewController(ex1, animated: true)
        }else if indexPath.row == 3 {
            let ex1 = Example3ViewController()
            self.navigationController?.pushViewController(ex1, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


