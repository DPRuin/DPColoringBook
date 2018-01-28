//
//  PDFColoringView.swift
//  DPColoringBook
//
//  Created by 土老帽 on 2018/1/25.
//  Copyright © 2018年 DPRuin. All rights reserved.
//

import UIKit


extension CGContext {
    
    func savingGState<Result>(_ body: () throws -> Result) rethrows -> Result {
        self.saveGState()
        defer {
            self.restoreGState()
        }
        return try body()
    }
}

class PDFColoringView: UIView {
    
    var addlines = [CGPoint]()
    
    let pdfDocument: CGPDFDocument = {
        return CGPDFDocument(Bundle.main.url(forResource: "test", withExtension: "pdf")! as CFURL)!
    }()

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        addlines = [CGPoint]()
        let startPoint = touches.first?.location(in: self)
        addlines.append(startPoint!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        addlines.append(point!)
        setNeedsDisplay()
    }
    
    func drawLine(lines: [CGPoint]?) {
        guard lines != nil else {
            return
        }
        let path = Bundle.main.path(forResource: "test", ofType: "pdf")!
        
        UIGraphicsBeginPDFContextToFile(path, frame, nil)
        UIGraphicsBeginPDFPageWithInfo(frame, nil)
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: 0.0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(10)
        context.setLineCap(CGLineCap.round)
        context.flush()
        
        context.beginPath()
        context.addArc(center: center, radius: 200, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        context.closePath()
        context.clip()
        
        
        context.addLines(between: lines!)
        context.strokePath()
        
        UIGraphicsEndPDFContext()
        
    }
    
    
    override func draw(_ rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()!
        // Drawing code
        // PDF page drawing expects a Lower-Left coordinate system, so we flip the coordinate system
        // before we start drawing.
        context.translateBy(x: 0.0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        // Grab the first PDF page
        let page = pdfDocument.page(at: 1)!

        // We're about to modify the context CTM to draw the PDF page where we want it, so save the graphics state in case we want to do more drawing
        context.saveGState()

        // page.getDrawingTransform provides an easy way to get the transform for a PDF page. It will scale down to fit, including any
        // base rotations necessary to display the PDF page correctly.
        let pdfTransform = page.getDrawingTransform(.cropBox, rect: bounds, rotate: 0, preserveAspectRatio: true)

        // And apply the transform.
        context.concatenate(pdfTransform)

        // Finally, we draw the page
        context.drawPDFPage(page)

        // restore the graphics state for further manipulations!
        context.restoreGState()
        context.endPDFPage()
        
        drawLine(lines: addlines)

    }
    
    
    

}
