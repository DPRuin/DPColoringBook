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
        
        let svgURL = Bundle.main.url(forResource: "82", withExtension: "svg")!
        let source = SVGKSourceURL.source(from: svgURL)
        SVGKImage.image(with: source) { (svgImage, _) in
            self.drawingLayer = svgImage?.caLayerTree
            print("hhhh---", self.drawingLayer?.sublayers?.count)
            self.image = svgImage
        }
        
        
    }
    
    private func setup() {
        self.backgroundColor = UIColor.white
        self.clearsContextBeforeDrawing = true
    }
    
    var lastPinchScale: CGFloat = 1.0
    private var scaleForCTM: CGFloat = 1.0
    
    private var lastPanTranslate = CGPoint.zero
    private var translateForCTM = CGPoint.zero
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        let point = (touches.first?.location(in: self))!
        let scaleTransform = CGAffineTransform(scaleX: 1 / scaleForCTM, y: 1 / scaleForCTM)
        let scaledPoint = point.applying(scaleTransform)
        let translateTransform = CGAffineTransform(translationX: -translateForCTM.x, y: -translateForCTM.y)
        startPoint = scaledPoint.applying(translateTransform)
        
        if let layer = self.drawingLayer?.hitTest(point) as? CAShapeLayer {
            coloringLayer = layer
            coloringLayer?.delegate = self

            layer.strokeColor = UIColor.orange.cgColor
            
            startPoint = self.layer.convert(startPoint, to: coloringLayer)
            
            addlines = [CGPoint]()
            addlines.append(startPoint)
            
            coloringLayer?.setNeedsDisplay()
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
        coloringLayer?.setNeedsDisplay()
        
    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        super.draw(layer, in: ctx)
        if let coloringLayer = coloringLayer, addlines.count > 0 {
            UIGraphicsPushContext(ctx)
            ctx.saveGState()

//            ctx.translateBy(x: 0.0, y: coloringLayer.bounds.height)
//            ctx.scaleBy(x: 1.0, y: -1.0)

            ctx.setStrokeColor(UIColor.red.cgColor)
            ctx.setLineWidth(20)
            ctx.setLineCap(CGLineCap.round)
            ctx.flush()
            print("------", layer.frame)

//            ctx.beginPath()
//            ctx.addPath(coloringLayer.path!)
//            ctx.closePath()
//            ctx.clip()

            ctx.addLines(between: addlines)
            ctx.strokePath()

            ctx.restoreGState()
            UIGraphicsPopContext()
        }
        
    }
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        if let layer = drawingLayer, let context = UIGraphicsGetCurrentContext() {
//            context.scaleBy(x: scaleForCTM, y: scaleForCTM)
//            context.translateBy(x: translateForCTM.x, y: translateForCTM.y)
//            layer.render(in: context)
//        }
//
//        // drawLine(lines: addlines)
//
//    }
    
    func clearCanvas() {
        path.removeAllPoints()
        // coloringLayer.sublayers = nil
        self.setNeedsDisplay()
    }
    
}


