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
    var scaleNum: CGFloat?
    var 
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
            floodFillColor(fromPoint: point, withColor: newColor)
        }
    }
    
    func floodFillColor(fromPoint point: CGPoint?, withColor color: UIColor) {
        
        // 颜色差异度
        var tolerance: Int = 10
        var antiAlias = false
        var colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        var imageRef = image.cgImage as? CGImageRef
        var width: Int = CGImageGetWidth(image.cgImage)
        var height: Int = CGImageGetHeight(image.cgImage)
        // 装换坐标 实际坐标转换成像素坐标
        var www: size_t = startPoint.x * scaleNum
        var hhh: size_t = startPoint.y * scaleNum
        startPoint = CGPoint(x: CGFloat(www), y: CGFloat(hhh))
        var imageData = malloc(width * height * 4)
        memset(imageData, 0, width * height * 4)
        print("--------------\(imageData)")
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
