//
//  Example3Cell.swift
//  ZZCarouselSwift
//
//  Created by Glianze on 2017/11/15.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit

class Example3Cell: UICollectionViewCell {
    var imageView: UIImageView!
    var textLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height:self.frame.size.height));
        self.contentView.addSubview(imageView);
        
        textLabel = UILabel.init(frame: CGRect(x:0, y:self.frame.size.height - 40, width: self.frame.size.width, height: 40))
        textLabel.backgroundColor = UIColor.black
        textLabel.alpha = 0.4
        textLabel.textColor = UIColor.white
        self.contentView.addSubview(textLabel);
        
    }
    
    func loadData(model: Dictionary<String, AnyObject>) -> Void {
        imageView.image = (model["image"] as! UIImage)
        textLabel.text = (model["title"] as! String)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
