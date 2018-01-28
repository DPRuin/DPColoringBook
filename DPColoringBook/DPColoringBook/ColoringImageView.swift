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
    var scaleNum: CGFloat = UIScreen.main.scale

    var cgimage: CGImage!
    
    
    var lineColor: UIColor!
    var lineWidth: CGFloat!
    var startingPoint: CGPoint!
    var touchPoint: CGPoint!
    var path: UIBezierPath!
    var drawMode = false
    
    
    /// 触摸点位图坐标
    var bitmapPoint: CGPoint!
    
    // 触摸坐标
    var touchX: Int!
    var touchY: Int!
    // 数组来存储选定的颜色
    var selectedColor: Array<UInt8> = [255,0,0]
    
    override func awakeFromNib() {
        isUserInteractionEnabled = true
        // 多指
        isMultipleTouchEnabled = true
        
        lineColor = .black
        lineWidth = 5.0
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        let point = touches.first?.location(in: self)
        startingPoint = point
        if touches.count == 1 {
            // 填充颜色
            floodFillColor(startPoint: startingPoint, withColor: UIColor.red)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        touchPoint = touch?.location(in: self)
        
//        path = UIBezierPath()
//        path.lineWidth = 10
//        path.lineCapStyle = .round
//        path.move(to: startingPoint)
//        path.addLine(to: touchPoint)
//        startingPoint = touchPoint
//
//        if drawMode {
//            drawShapeLayer()
//        }
    }
    
    func drawShapeLayer() {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
        
    }
    
    func clearCanvas() {
        path.removeAllPoints()
        self.layer.sublayers = nil
        self.setNeedsDisplay()
    }
    
    func floodFillColor(startPoint point: CGPoint?, withColor color: UIColor) {
        

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
        
        // 装换坐标 实际坐标转换成像素坐标
        let x = point.x * image.size.width / frame.size.width
        let y = point.y * image.size.height / frame.size.height
        // bitmapPoint = CGPoint(x: x, y: y)
        // 转换为整数并保存
        self.touchX = Int(x)
        self.touchY = Int(y)
        print(" 转换坐标: \(x),\(y)")
        
        guard let cgImage = image.cgImage else {
            print("cgImage is nil")
            return
        }
        
        let provider = cgImage.dataProvider
        
        let cfData = provider?.data
        
        // 更改CFData窗体=更改为可变形式
        let mutableCfData = CFDataCreateMutableCopy(nil, 0, cfData)
        // 获取一个位图
        let bitmap = CFDataGetMutableBytePtr(mutableCfData)
        // 获取坐标的位图颜色
        // （Y坐标×图像宽度+ X坐标）×4←触摸坐标的位图信息
        let index = (self.touchY * (cgImage.width) + self.touchX) * 4
        
        let length = CFDataGetLength(mutableCfData)
        
        if(index < length){
            // red
            bitmap?[index] = selectedColor[0]
            // green
            bitmap?[index+1] = selectedColor[1]
            // blue
            bitmap?[index+2] = selectedColor[2]
            
            // 创建一个数组来存储要绘制的坐标
            var fillPoint: Array<Array<Int>> = []
            
            // 重复（无限循环）
            while(true){
                // 我们沿着向上的方向应用1个像素，颜色
                let indexUp = ((self.touchY-1) * (cgImage.width) + self.touchX) * 4
                // 如果是黑色（R = 0，G = 0，B = 0）则不会画
                if(!(bitmap?[indexUp] == 0 && bitmap?[indexUp+1] == 0 && bitmap?[indexUp+2] == 0)) {
                    // 如果是我选择的颜色，我不会画
                    if(!(bitmap?[indexUp] == self.selectedColor[0] && bitmap?[indexUp+1] == self.selectedColor[1] && bitmap?[indexUp+2] == self.selectedColor[2])) {
                        // 保存坐标
                        fillPoint.append([self.touchX,self.touchY-1])
                        // red
                        bitmap?[indexUp] = self.selectedColor[0]
                        // green
                        bitmap?[indexUp+1] = self.selectedColor[1]
                        // blue
                        bitmap?[indexUp+2] = self.selectedColor[2]
                    }
                }
                
                // 让我们向下画1个像素
                let indexDown = ((self.touchY+1) * (cgImage.width) + self.touchX) * 4
                // 如果是黑色（R = 0，G = 0，B = 0）则不会画
                if(!(bitmap?[indexDown] == 0 && bitmap?[indexDown+1] == 0 && bitmap?[indexDown+2] == 0)) {
                    if(!(bitmap?[indexDown] == self.selectedColor[0] && bitmap?[indexDown+1] == self.selectedColor[1] && bitmap?[indexDown+2] == self.selectedColor[2])) {
                        // 座標を保存します
                        fillPoint.append([self.touchX,self.touchY+1])
                        // red
                        bitmap?[indexDown] = self.selectedColor[0]
                        // green
                        bitmap?[indexDown+1] = self.selectedColor[1]
                        // blue
                        bitmap?[indexDown+2] = self.selectedColor[2]
                    }
                }
                
                // 让我们在正确的方向绘制30个像素的颜色
                let indexRight = (self.touchY * (cgImage.width) + (self.touchX+1)) * 4
                // 黒色(R=0,G=0,B=0)だったら塗らない
                if(!(bitmap?[indexRight] == 0 && bitmap?[indexRight+1] == 0 && bitmap?[indexRight+2] == 0)) {
                    if(!(bitmap?[indexRight] == self.selectedColor[0] && bitmap?[indexRight+1] == self.selectedColor[1] && bitmap?[indexRight+2] == self.selectedColor[2])) {
                        // 座標を保存します
                        fillPoint.append([self.touchX+1,self.touchY])
                        // red
                        bitmap?[indexRight] = self.selectedColor[0]
                        // green
                        bitmap?[indexRight+1] = self.selectedColor[1]
                        // blue
                        bitmap?[indexRight+2] = self.selectedColor[2]
                    }
                }
                
                // 让我们在左边画30个像素
                let indexLeft = (self.touchY * (cgImage.width) + (self.touchX-1)) * 4
                // 黒色(R=0,G=0,B=0)だったら塗らない
                if(!(bitmap?[indexLeft] == 0 && bitmap?[indexLeft+1] == 0 && bitmap?[indexLeft+2] == 0)) {
                    if(!(bitmap?[indexLeft] == self.selectedColor[0] && bitmap?[indexLeft+1] == self.selectedColor[1] && bitmap?[indexLeft+2] == self.selectedColor[2])) {
                        // 座標を保存します
                        fillPoint.append([self.touchX-1,self.touchY])
                        // red
                        bitmap?[indexLeft] = self.selectedColor[0]
                        // green
                        bitmap?[indexLeft+1] = self.selectedColor[1]
                        // blue
                        bitmap?[indexLeft+2] = self.selectedColor[2]
                    }
                }
                
                // 右斜め上
                let indexUpRight = ((self.touchY-1) * (cgImage.width) + (self.touchX+1)) * 4
                if(!(bitmap?[indexUpRight] == 0 && bitmap?[indexUpRight+1] == 0 && bitmap?[indexUpRight+2] == 0)) {
                    if(!(bitmap?[indexUpRight] == self.selectedColor[0] && bitmap?[indexUpRight+1] == self.selectedColor[1] && bitmap?[indexUpRight+2] == self.selectedColor[2])) {
                        // 座標を保存します
                        fillPoint.append([self.touchX+1,self.touchY-1])
                        // red
                        bitmap?[indexUpRight] = self.selectedColor[0]
                        // green
                        bitmap?[indexUpRight+1] = self.selectedColor[1]
                        // blue
                        bitmap?[indexUpRight+2] = self.selectedColor[2]
                    }
                }
                
                // 右斜め下
                let indexDownRight = ((self.touchY + 1) * (cgImage.width) + (self.touchX + 1)) * 4
                if(!(bitmap?[indexDownRight] == 0 && bitmap?[indexDownRight+1] == 0 && bitmap?[indexDownRight+2] == 0)) {
                    if(!(bitmap?[indexDownRight] == self.selectedColor[0] && bitmap?[indexDownRight+1] == self.selectedColor[1] && bitmap?[indexDownRight+2] == self.selectedColor[2])) {
                        // 座標を保存します
                        fillPoint.append([self.touchX+1,self.touchY+1])
                        // red
                        bitmap?[indexDownRight] = self.selectedColor[0]
                        // green
                        bitmap?[indexDownRight+1] = self.selectedColor[1]
                        // blue
                        bitmap?[indexDownRight+2] = self.selectedColor[2]
                    }
                }
                
                // 左斜め下
                let indexDownLeft = ((self.touchY+1) * (cgImage.width) + (self.touchX-1)) * 4
                if(!(bitmap?[indexDownLeft] == 0 && bitmap?[indexDownLeft+1] == 0 && bitmap?[indexDownLeft+2] == 0)) {
                    if(!(bitmap?[indexDownLeft] == self.selectedColor[0] && bitmap?[indexDownLeft+1] == self.selectedColor[1] && bitmap?[indexDownLeft+2] == self.selectedColor[2])) {
                        // 座標を保存します
                        fillPoint.append([self.touchX-1,self.touchY+1])
                        // red
                        bitmap?[indexDownLeft] = self.selectedColor[0]
                        // green
                        bitmap?[indexDownLeft+1] = self.selectedColor[1]
                        // blue
                        bitmap?[indexDownLeft+2] = self.selectedColor[2]
                    }
                }
                
                // 左斜め上
                let indexUpLeft = ((self.touchY-1) * (cgImage.width) + (self.touchX-1)) * 4
                if(!(bitmap?[indexUpLeft] == 0 && bitmap?[indexUpLeft+1] == 0 && bitmap?[indexUpLeft+2] == 0)) {
                    if(!(bitmap?[indexUpLeft] == self.selectedColor[0] && bitmap?[indexUpLeft+1] == self.selectedColor[1] && bitmap?[indexUpLeft+2] == self.selectedColor[2])) {
                        // 座標を保存します
                        fillPoint.append([self.touchX-1,self.touchY-1])
                        // red
                        bitmap?[indexUpLeft] = self.selectedColor[0]
                        // green
                        bitmap?[indexUpLeft+1] = self.selectedColor[1]
                        // blue
                        bitmap?[indexUpLeft+2] = self.selectedColor[2]
                    }
                }
                
                // 如果fillPoint数组的数量为0，则结束。
                if(fillPoint.count == 0){
                    break
                }
                
                // 在fillPoint的末尾找到数字
                let lastNumber = fillPoint.count - 1
                self.touchX = fillPoint[lastNumber][0]
                self.touchY = fillPoint[lastNumber][1]
                // 擦除最后一个fillPoint数组
                fillPoint.removeLast()
            }
        }
        
        //相反地转换
        // 转换为CFData
        let outputCFData = CFDataCreate(nil, bitmap, CFDataGetLength(cfData))
        // 准备图像提供者
        let outputProvider = CGDataProvider(data: outputCFData!)
        // 转换为CGImage
        let outputCGImage = CGImage(width: (cgImage.width),
                                    height: (cgImage.height),
                                    bitsPerComponent: (cgImage.bitsPerComponent),
                                    bitsPerPixel: (cgImage.bitsPerPixel),
                                    bytesPerRow: (cgImage.bytesPerRow),
                                    space: (cgImage.colorSpace!),
                                    bitmapInfo: (cgImage.bitmapInfo),
                                    provider: outputProvider!,
                                    decode: nil,
                                    shouldInterpolate: (cgImage.shouldInterpolate),
                                    intent: (cgImage.renderingIntent))
        
        // 转换成UIImage
        let outputUIImage = UIImage(cgImage: outputCGImage!)
        // 将图像放在draftImageView中
        self.image = outputUIImage
        
       //  UIGraphicsBeginImageContext(image.size)
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
     */

}
