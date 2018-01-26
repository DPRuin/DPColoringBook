//
//  ColoringViewController.swift
//  DPColoringBook
//
//  Created by 土老帽 on 2018/1/19.
//  Copyright © 2018年 DPRuin. All rights reserved.
//

import UIKit

class ColoringViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didTapClear(_ sender: UIButton) {
        let coloringView = view as! SVGColoringView
        coloringView.clearCanvas()
    }
    
    @IBAction func didTapDraw(_ sender: UIButton) {

    }
    
    @IBAction func didTapDone(_ sender: UIButton) {
        
    }
    
    
}

