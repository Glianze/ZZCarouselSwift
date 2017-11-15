//
//  Example1Cell.swift
//  ZZCarouselSwift
//
//  Created by Glianze on 2017/11/10.
//  Copyright © 2017年 Glianze. All rights reserved.
//

import UIKit
import Kingfisher

class Example1Cell: UICollectionViewCell {
    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height:self.frame.size.height));
        self.contentView.addSubview(imageView);

    }
    
    func loadImage(image: UIImage) -> Void {
        imageView.image = image;
    }
    
    func loadWebImage(imageUrl: String) -> Void {
        self.imageView.kf.setImage(with: URL(string: imageUrl))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
