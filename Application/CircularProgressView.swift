//
//  CircularProgressView.swift
//  Cortland
//
//  Created by Grant Brooks Goodman on 20/05/2021.
//  Copyright © 2013-2021 NEOTechnica Corporation. All rights reserved.
//

/* First-party Frameworks */
import UIKit

class CircularProgressView: UIView {
    
    //==================================================//
    
    /* MARK: Class-level Variable Declarations */
    
    //CAShapeLayers
    private var circleLayer   = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    
    //==================================================//
    
    /* MARK: Initializer Functions */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createCircularPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createCircularPath()
    }
    
    //==================================================//
    
    /* MARK: Other Functions */
    
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: 150, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        
        circleLayer.path = circularPath.reversing().cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 7
        circleLayer.strokeColor = UIColor(hex: 0x212225).cgColor
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 7
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor(hex: 0xFF962C).cgColor
        
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
    }
    
    func progressAnimation(duration: TimeInterval) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        //circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fromValue = 1.0
        circularProgressAnimation.fillMode = .backwards
        circularProgressAnimation.isRemovedOnCompletion = false
        
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
        pauseAnimation()
    }
    
    func pauseAnimation() {
        let pausedTime = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
        progressLayer.speed = 0.0
        progressLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = progressLayer.timeOffset
        
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        
        let timeSincePause = progressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressLayer.beginTime = timeSincePause
    }
}
