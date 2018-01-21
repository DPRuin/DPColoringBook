//
//  ColoringImageView.swift
//  DPColoringBook
//
//  Created by 土老帽 on 2018/1/19.
//  Copyright © 2018年 DPRuin. All rights reserved.
//

import UIKit


class ColoringImageView: UIImageView {

    var startImage: UIImage?
    var newColor: UIColor = .red
    var scaleNum: CGFloat = 1.0

    var cgimage: CGImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = true;
        // 多指
        isMultipleTouchEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        if touches.count == 1 {
            // 填充颜色
            floodFillColor(startPoint: point, withColor: newColor)
        }
    }
    
    func floodFillColor(startPoint point: CGPoint?, withColor color: UIColor) {
        
        #if false
        // 颜色差异度
        var tolerance: Int = 10
        var antiAlias = false
        var colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let image = image else {
            print("image is nil")
            return
        }
        var cgimage = image.cgImage!
        var width: Int = cgimage.width
        var height: Int = cgimage.height
        
        guard let point = point else {
            print("point is nil")
            return
        }
        #endif
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
