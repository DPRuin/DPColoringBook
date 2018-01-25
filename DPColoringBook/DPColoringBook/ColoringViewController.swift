//
//  ColoringViewController.swift
//  DPColoringBook
//
//  Created by 土老帽 on 2018/1/19.
//  Copyright © 2018年 DPRuin. All rights reserved.
//

import UIKit

class ColoringViewController: UIViewController {

    var startPoint: CGPoint?
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startPoint = touches.first?.location(in:self.imageView )
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in:self.imageView )
        
        drawLine(fromPoint: startPoint!, toPoint: point!)
        startPoint = point
    }
    
    func drawLine(fromPoint: CGPoint, toPoint: CGPoint) {
        let path = Bundle.main.path(forResource: "test", ofType: "pdf")!
        
        UIGraphicsBeginPDFContextToFile(path, self.imageView.frame, nil)
        self.imageView.draw(self.imageView.frame)
        UIGraphicsBeginPDFPageWithInfo(self.imageView.frame, nil)
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(10)
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        context.setLineCap(CGLineCap.round)
        context.flush()
        context.strokePath()
        UIGraphicsEndPDFContext()
        
    }
    

    @IBAction func didTapClear(_ sender: UIButton) {
        let coloringView = view as! ColoringView
        coloringView.clearCanvas()
    }
    
    @IBAction func didTapDraw(_ sender: UIButton) {

    }
    
    @IBAction func didTapDone(_ sender: UIButton) {
        
    }
    
    
}

