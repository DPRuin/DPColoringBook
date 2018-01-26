//
//  ColoringShapeLayer.swift
//  DPColoringBook
//
//  Created by 土老帽 on 2018/1/26.
//  Copyright © 2018年 DPRuin. All rights reserved.
//

import UIKit

class ColoringShapeLayer: CAShapeLayer {

    
    
    override func draw(in ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        ctx.saveGState()
        
        
        
        
        ctx.restoreGState()
        UIGraphicsPopContext()
    }
}
