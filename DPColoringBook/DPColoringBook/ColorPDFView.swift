//
//  ColorPDFView.swift
//  DPColoringBook
//
//  Created by 土老帽 on 2018/1/25.
//  Copyright © 2018年 DPRuin. All rights reserved.
//

import UIKit
import PDFKit

class ColorPDFView: PDFView {
   
    var addlines = [CGPoint]()
    var coloringPage: PDFPage!
    let clipPaths = [UIBezierPath]()
    
    override func awakeFromNib() {

        // Load our simple PDF document, retrieve the first page
        if let documentURL = Bundle.main.url(forResource: "hhh", withExtension: "pdf"), let document = PDFDocument(url: documentURL), let page = document.page(at: 0) {
            // Set our document to the view, center it, and set a background color
            self.document = document
            coloringPage = page
            autoScales = false
            backgroundColor = UIColor.lightGray
            
            // 不能缩放
            minScaleFactor = scaleFactorForSizeToFit
            maxScaleFactor = scaleFactorForSizeToFit
            
            isUserInteractionEnabled = true
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panTouchMove(pan:)) )
        addGestureRecognizer(pan)
        
        createClip()
        
        
    }
    
    @objc func panTouchMove(pan: UIPanGestureRecognizer) {
        
        var point = pan.location(in: self)
        point = convert(point, to: coloringPage!)
        switch pan.state {
        case .began:
            addlines = [CGPoint]()
            
            addlines.append(point)
            
        case .changed:
            addlines.append(point)
            
            setNeedsDisplay()
        default:
            break
        }
        
    }
    
    // FIXME: CGPath路径获取不到
    func createClip() {
        print("ccc", coloringPage.numberOfCharacters)
        
        
        let annotations = coloringPage.annotations
        for annot in annotations {
            let paths = annot.paths
            
            
            print("eee", annot.quadrilateralPoints as? [CGPoint])
            print("hhh", paths?.count)
            paths?.count
            
            if paths != nil {
                for path in paths! {
                    
                }
            }
            
        }
    }
    
    override func draw(_ page: PDFPage, to context: CGContext) {
        
        UIGraphicsPushContext(context)
        // context.saveGState()
        // TODO: boounds的获取?
//        let pageBounds = page.characterBounds(at: 0)
//        context.translateBy(x: 0.0, y: pageBounds.size.height)
//        context.scaleBy(x: 1.0, y: -1.0)
//        context.rotate(by: CGFloat.pi / 4.0)

        context.beginPath()
        context.setStrokeColor(UIColor.blue.cgColor)
        let path = UIBezierPath(arcCenter: CGPoint(x: 300, y: 300), radius: 200, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        context.addPath(path.cgPath)
        context.closePath()
        context.clip()
        
        if addlines.count > 0 {
            context.setStrokeColor(UIColor.red.cgColor)
            context.setLineWidth(10)
            context.setLineCap(CGLineCap.round)
            context.flush()
            context.addLines(between: addlines)

            context.strokePath()
        }
        
        // context.restoreGState()
        UIGraphicsPopContext()
    }
    
}
