//
//  PDFImageView.swift
//  DPColoringBook
//
//  Created by 土老帽 on 2018/1/25.
//  Copyright © 2018年 DPRuin. All rights reserved.
//

import UIKit

class PDFImageView: UIImageView {

    var addlines = [CGPoint]()

    override func awakeFromNib() {
        isUserInteractionEnabled = true
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // addlines = [CGPoint]()
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
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(10)
        context.setLineCap(CGLineCap.round)
        context.flush()
        
        context.addLines(between: lines!)
        context.strokePath()
        
        UIGraphicsEndPDFContext()
        
    }

    override func draw(_ rect: CGRect) {
        // Drawing code
        drawLine(lines: addlines)
    }
 

}
