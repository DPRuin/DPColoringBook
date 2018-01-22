//
//  ColoringView.swift
//  DPColoringBook
//
//  Created by 土老帽 on 2018/1/19.
//  Copyright © 2018年 DPRuin. All rights reserved.
//

import UIKit
import SVGKit

class ColoringView: UIView {

    var drawingLayer: CALayer? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private var fillColor = UIColor.red
    func setFillColor(color: UIColor) {
        fillColor = color
    }
    
    // 划线起点
    var startPoint = CGPoint.zero
    var path: UIBezierPath!
    
    override func awakeFromNib() {
        setup()
        
    }
    
    private func setup() {
        self.backgroundColor = UIColor.white
        self.clearsContextBeforeDrawing = true

        // 点击
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(sender:)))
        tap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    var lastPinchScale: CGFloat = 1.0
    private var scaleForCTM: CGFloat = 1.0
    
    private var lastPanTranslate = CGPoint.zero
    private var translateForCTM = CGPoint.zero
    
    @objc func tapGesture(sender: UITapGestureRecognizer) {
        let point = sender.location(in: self)
        let scaleTransform = CGAffineTransform(scaleX: 1 / scaleForCTM, y: 1 / scaleForCTM)
        let scaledPoint = point.applying(scaleTransform)
        let translateTransform = CGAffineTransform(translationX: -translateForCTM.x, y: -translateForCTM.y)
        let translatedPoint = scaledPoint.applying(translateTransform)

        if let layer = self.drawingLayer?.hitTest(translatedPoint) as? CAShapeLayer {
            layer.fillColor = fillColor.cgColor

        }

        self.setNeedsDisplay()
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = (touches.first?.location(in: self))!
        let scaleTransform = CGAffineTransform(scaleX: 1 / scaleForCTM, y: 1 / scaleForCTM)
        let scaledPoint = point.applying(scaleTransform)
        let translateTransform = CGAffineTransform(translationX: -translateForCTM.x, y: -translateForCTM.y)
        
        startPoint = scaledPoint.applying(translateTransform)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        let scaleTransform = CGAffineTransform(scaleX: 1 / scaleForCTM, y: 1 / scaleForCTM)
        let scaledPoint = point!.applying(scaleTransform)
        let translateTransform = CGAffineTransform(translationX: -translateForCTM.x, y: -translateForCTM.y)
        
        let endPoint = scaledPoint.applying(translateTransform)
        
        
        if let layer = self.drawingLayer?.hitTest(startPoint) as? CAShapeLayer {
            
            print("layer---",layer.frame)
            // 新建一个bezier对象
            let bezierPath = UIBezierPath()
            
            // 设置线两头样式
            bezierPath.lineCapStyle = CGLineCap.round
            // 设置起点、终点坐标
            bezierPath.move(to: startPoint)
            bezierPath.addLine(to: endPoint)
            
            path = bezierPath
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.red.cgColor
            shapeLayer.lineWidth = 10
            shapeLayer.fillColor = UIColor.cyan.cgColor
            
            layer.addSublayer(shapeLayer)
            
        }
        
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let layer = drawingLayer, let context = UIGraphicsGetCurrentContext() {
            context.scaleBy(x: scaleForCTM, y: scaleForCTM)
            context.translateBy(x: translateForCTM.x, y: translateForCTM.y)
            layer.render(in: context)
        }
    }
 

}
