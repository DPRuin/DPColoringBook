//
//  ColoringShapeLayer.swift
//  DPColoringBook
//
//  Created by 土老帽 on 2018/1/26.
//  Copyright © 2018年 DPRuin. All rights reserved.
//

import UIKit

class ColoringShapeLayer: CAShapeLayer {

    private var clipPath: CGPath!
    private var lines: [CGPoint]!

    init(path: CGPath, lines:[CGPoint]) {
        super.init()
        self.clipPath = path
        
    }
    
    func setLines(lines: [CGPoint]) {
        self.lines = lines
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
