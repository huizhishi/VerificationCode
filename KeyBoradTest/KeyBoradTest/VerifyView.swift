//
//  VerifyView.swift
//  KeyBoradTest
//
//  Created by wyse on 2017/7/21.
//  Copyright © 2017年 wyse. All rights reserved.
//

import UIKit

protocol VerifyViewDelegate {
    func change(view: VerifyView)
    func completeInput(view: VerifyView)
    func beginInput(view: VerifyView)
}

class VerifyView: UIView {
    
    /// 保存验证码的字符串
    var textStore: String = ""
    /// 最大输入个数
    var maxNum: Int = 4
    
    var delegate: VerifyViewDelegate?
    var keyboardType: UIKeyboardType = .numberPad
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.gray
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override func becomeFirstResponder() -> Bool {
        delegate?.beginInput(view: self)
        return super.becomeFirstResponder()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.isFirstResponder {
            super.becomeFirstResponder()
        }
    }
    override func draw(_ rect: CGRect) {
        let width = (rect.size.width - 18 * 3) / 4.0
        
        let context = UIGraphicsGetCurrentContext()
        for i in 0..<maxNum {
            let point = CGPoint(x: (width + 18) * CGFloat(i), y: rect.size.height - 1)
            context?.move(to: point)
            context?.addLine(to: CGPoint(x: point.x + width, y: rect.size.height - 1))
            context?.closePath()
        }
        context?.setLineWidth(1)
        context?.drawPath(using: .fillStroke)
        context?.setStrokeColor(#colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attrs = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)]
        for (i, c) in textStore.characters.enumerated() {
            String(c).draw(at: CGPoint(x: (width + 16) * CGFloat(i) + width/2.0, y: 2), withAttributes: attrs)
        }
    }
    func screenRatio(_ value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.size.width * value / 375
    }
}

extension VerifyView: UIKeyInput {
    var hasText: Bool {
        return textStore.characters.count < 6
    }
    func insertText(_ text: String) {
        if textStore.characters.count < maxNum {
            /// 判断是否为数字
            if Int(text) != nil {
                textStore.append(text)
                delegate?.change(view: self)
                if textStore.characters.count == maxNum {
                    delegate?.completeInput(view: self)
                }
                setNeedsDisplay()
            }
        }
    }
    func deleteBackward() {
        if textStore.characters.count > 0 {
            textStore.removeLast()
            delegate?.change(view: self)
        }
        setNeedsDisplay()
    }
}
