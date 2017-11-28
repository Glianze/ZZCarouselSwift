//
//  Example2Cell.swift
//  ZZCarouselSwift
//
//  Created by Glianze on 2017/11/15.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit

class Example2Cell: UICollectionViewCell {

    var textLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        textLabel = UILabel.init(frame: CGRect(x:0, y:0, width: self.frame.size.width, height: self.frame.size.height))
        textLabel.backgroundColor = UIColor.white
        self.contentView.addSubview(textLabel);
        
    }

    func loadWebImage(imageUrl: String) -> Void {
        textLabel.text = imageUrl
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
