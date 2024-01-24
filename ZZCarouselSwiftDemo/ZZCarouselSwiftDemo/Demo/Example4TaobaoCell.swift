//
//  Example4TaobaoCell.swift
//  ZZCarouselSwiftDemo
//
//  Created by Glianze on 2017/11/28.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit

class Example4TaobaoCell: UICollectionViewCell {
    var textLabel : UILabel!
    var subtextLabel : UILabel!
    var typeLabel1 : UILabel!
    var typeLabel2 : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        typeLabel1 = UILabel.init(frame: CGRect(x:5, y:2.5, width:40, height: 15))
        typeLabel1.backgroundColor = UIColor.white
        typeLabel1.layer.masksToBounds = true
        typeLabel1.layer.cornerRadius = 5
        typeLabel1.layer.borderWidth = 1.0
        typeLabel1.layer.borderColor = UIColor.orange.cgColor
        typeLabel1.textColor = UIColor.orange
        typeLabel1.textAlignment = NSTextAlignment.center
        typeLabel1.font = UIFont.systemFont(ofSize: 11.0)
        self.contentView.addSubview(typeLabel1);
        
        
        typeLabel2 = UILabel.init(frame: CGRect(x:5, y:22.5, width:40, height: 15))
        typeLabel2.backgroundColor = UIColor.white
        typeLabel2.layer.masksToBounds = true
        typeLabel2.layer.cornerRadius = 5
        typeLabel2.layer.borderWidth = 1.0
        typeLabel2.layer.borderColor = UIColor.orange.cgColor
        typeLabel2.textColor = UIColor.orange
        typeLabel2.textAlignment = NSTextAlignment.center
        typeLabel2.font = UIFont.systemFont(ofSize: 11.0)
        self.contentView.addSubview(typeLabel2);
        
        textLabel = UILabel.init(frame: CGRect(x:50, y:0, width: self.frame.size.width - 50, height: 20))
        textLabel.backgroundColor = UIColor.white
        self.contentView.addSubview(textLabel);
        
        subtextLabel = UILabel.init(frame: CGRect(x:50, y:20, width: self.frame.size.width - 50, height: 20))
        subtextLabel.backgroundColor = UIColor.white
        self.contentView.addSubview(subtextLabel);
        
    }
    

    func loadData(data: Dictionary<String, Any>) -> Void {
        textLabel.text = data["title"] as? String
        subtextLabel.text = data["subTitle"] as? String
        
        if data["type"] as? Int == 1 {
            typeLabel1.text = "吃瓜"
            typeLabel2.text = "好的"
        }else if data["type"] as? Int == 2 {
            typeLabel1.text = "围观"
            typeLabel2.text = "你猜"
        }else if data["type"] as? Int == 3 {
            typeLabel1.text = "热门"
            typeLabel2.text = "劲爆"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
