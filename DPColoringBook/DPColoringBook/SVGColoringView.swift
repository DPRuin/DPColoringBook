//
//  ColoringView.swift
//  DPColoringBook
//
//  Created by 土老帽 on 2018/1/19.
//  Copyright © 2018年 DPRuin. All rights reserved.
//

import UIKit
import SVGKit

class SVGColoringView: SVGKLayeredImageView {

    var drawingLayer: CALayer? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var coloringLayer: CAShapeLayer?
    
    
    private var fillColor = UIColor.red
    
    func setFillColor(color: UIColor) {
        fillColor = color
    }
    
    // 划线起点
    var startPoint = CGPoint.zero
    var path: UIBezierPath!
    
    var addlines = [CGPoint]()
    
    
    
    override func awakeFromNib() {
        setup()
        
        // self.image = SVGKImage(named: "8.svg")
        
        let svgURL = Bundle.main.url(forResource: "8", withExtension: "svg")!
        let source = SVGKSourceURL.source(from: svgURL)
        SVGKImage.image(with: source) { (svgImage, _) in
            self.drawingLayer = svgImage?.caLayerTree
            print("hhhh---", self.drawingLayer?.sublayers?.count)
        }
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
            print("layer---",layer.frame)
            layer.fillColor = UIColor.blue.cgColor
        }

        self.setNeedsDisplay()
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = (touches.first?.location(in: self))!
        let scaleTransform = CGAffineTransform(scaleX: 1 / scaleForCTM, y: 1 / scaleForCTM)
        let scaledPoint = point.applying(scaleTransform)
        let translateTransform = CGAffineTransform(translationX: -translateForCTM.x, y: -translateForCTM.y)
        startPoint = scaledPoint.applying(translateTransform)
        
        if let layer = self.drawingLayer?.hitTest(point) as? CAShapeLayer {
            coloringLayer = layer
            startPoint = self.layer.convert(startPoint, to: coloringLayer)
            coloringLayer?.strokeColor = UIColor.orange.cgColor
            
            addlines = [CGPoint]()
            addlines.append(startPoint)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        let scaleTransform = CGAffineTransform(scaleX: 1 / scaleForCTM, y: 1 / scaleForCTM)
        let scaledPoint = point!.applying(scaleTransform)
        let translateTransform = CGAffineTransform(translationX: -translateForCTM.x, y: -translateForCTM.y)
        
        var endPoint = scaledPoint.applying(translateTransform)
        endPoint = self.layer.convert(endPoint, to: coloringLayer)
        addlines.append(endPoint)
        setNeedsDisplay()
        
        
//        // 新建一个bezier对象
//        let bezierPath = UIBezierPath()
//        // 设置线两头样式
//        bezierPath.lineCapStyle = CGLineCap.round
//        // 设置起点、终点坐标
//        bezierPath.move(to: startPoint)
//
//        endPoint = self.layer.convert(endPoint, to: coloringLayer)
//        print("--",startPoint, "--", endPoint)
//        if coloringLayer.contains(endPoint) {
//            bezierPath.addLine(to: endPoint)
//        } else {
//            bezierPath.addLine(to: startPoint)
//        }
//        startPoint = endPoint
//        path = bezierPath
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = path.cgPath
//        shapeLayer.strokeColor = UIColor.red.cgColor
//        shapeLayer.lineWidth = 10
//        // shapeLayer.fillColor = UIColor.cyan.cgColor
//        coloringLayer.addSublayer(shapeLayer)
//        self.setNeedsDisplay()
    }
    
    
    
    func drawLine(lines: [CGPoint]?) {
        guard let lines = lines, lines.count > 0, let coloringLayer = coloringLayer else {
            return
        }
        
//        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: 0.0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(10)
        context.setLineCap(CGLineCap.round)
        context.flush()
        
        context.beginPath()
        context.addPath(coloringLayer.path!)
        // context.addArc(center: center, radius: 200, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        context.closePath()
        context.clip()
        
        
        context.addLines(between: lines)
        context.strokePath()
        
//        coloringLayer.contents = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
//        UIGraphicsEndImageContext()
        
    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        super.draw(layer, in: ctx)
        print("------")
        if let coloringLayer = coloringLayer, addlines.count > 0 {
            UIGraphicsPushContext(ctx)
            ctx.saveGState()
            
//            ctx.translateBy(x: 0.0, y: bounds.size.height)
//            ctx.scaleBy(x: 1.0, y: -1.0)
            
            ctx.setStrokeColor(UIColor.red.cgColor)
            ctx.setLineWidth(10)
            ctx.setLineCap(CGLineCap.round)
            ctx.flush()
            
            ctx.beginPath()
            ctx.addPath(coloringLayer.path!)
            // context.addArc(center: center, radius: 200, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
            ctx.closePath()
            ctx.clip()
            
            
            ctx.addLines(between: addlines)
            ctx.strokePath()
            
            ctx.restoreGState()
            UIGraphicsPopContext()
        }

    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let layer = drawingLayer, let context = UIGraphicsGetCurrentContext() {
            context.scaleBy(x: scaleForCTM, y: scaleForCTM)
            context.translateBy(x: translateForCTM.x, y: translateForCTM.y)
            layer.render(in: context)
        }
        
        // drawLine(lines: addlines)
        
    }
    
    func clearCanvas() {
        path.removeAllPoints()
        // coloringLayer.sublayers = nil
        self.setNeedsDisplay()
    }
    
 

}
