//
//  MarqueeLabel.swift
//  MarqueeBanner
//
//  Created by john.lin on 2018/10/16.
//  Copyright © 2018年 john.lin. All rights reserved.
//

import UIKit

protocol MarqueeViewDelegate: class {
    func tapFromMarqueeBannerIndex(index: Int)
    func tapFromMarqueeLabelIndex(index: Int)
}

class MarqueeLabel: UIView {
    
    weak var delegate: MarqueeViewDelegate?
    
    fileprivate var textArray: [String] = []
    
    fileprivate var scrollView: UIScrollView?
    
    fileprivate var currentIndex = 0
    
    fileprivate var nextIndex = 1
    
    fileprivate var timer: Timer?
    
    fileprivate var lastLabel: UILabel?
    
    fileprivate var currentLabel: UILabel?
    
    fileprivate var nextLabel: UILabel?
    
    var duration: TimeInterval = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, textArray: [String], duration: Double = 3.0) {
        super.init(frame: frame)
        self.textArray = textArray
        self.duration = duration
        self.reoload()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func reoload() {
        startTimer()
        setupScrollView()
    }
    
    fileprivate func setupScrollView() {
        scrollView = UIScrollView(frame: self.bounds)
        scrollView?.contentSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height * 3)
        scrollView?.contentOffset = CGPoint(x: 0, y: self.bounds.size.height)
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.backgroundColor = UIColor.clear
        scrollView?.isUserInteractionEnabled = true
        scrollView?.isScrollEnabled = false
        scrollView?.isPagingEnabled = false
        scrollView?.bounces = false
        scrollView?.delegate = self
        self.addSubview(scrollView!)
        
        setupLabel()
        reloadLabel()
        
        if textArray.count == 1 {
            self.scrollView?.contentSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height)
            self.scrollView?.contentOffset = CGPoint.zero
            self.currentLabel?.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        }
    }
    
    fileprivate func setupLabel() {
        self.lastLabel = createLabel(index: 0)
        self.currentLabel = createLabel(index: 1)
        
        scrollView?.addSubview(lastLabel!)
        scrollView?.addSubview(currentLabel!)
        
        self.loadLabel(label: self.currentLabel!, index: 0)
    }
    
    func loadLabel(label: UILabel, index: Int) {
        if textArray.count == 0 {
            return
        }
        let labelData = self.textArray[index]
        label.text = labelData
    }
    
    func reloadLabel() {
        let index = self.scrollView!.contentOffset.y / self.scrollView!.bounds.size.height
        if index == 1 { return }
        self.currentIndex = self.nextIndex
        self.currentLabel?.frame = CGRect(x: 0, y: self.scrollView!.bounds.size.height, width: self.scrollView!.bounds.size.width, height: self.scrollView!.bounds.size.height)
        self.currentLabel?.text = self.lastLabel?.text
        self.scrollView?.contentOffset = CGPoint(x: 0, y: self.scrollView!.bounds.size.height)
    }
    
    func createLabel(index: Int) -> UILabel? {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "PingFangTC-Regular", size: 14)
        label.frame = CGRect(x: 0, y: scrollView!.frame.size.height * CGFloat(index), width: scrollView!.frame.size.width, height: scrollView!.frame.size.height)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(labelTaped(_:)))
        self.addGestureRecognizer(tap)
        
        return label
    }
    
    @objc func labelTaped(_ tap: UITapGestureRecognizer) {
        delegate?.tapFromMarqueeLabelIndex(index: currentIndex)
    }
    
    func startTimer() {
        if self.textArray.count <= 1 {
            return
        }
        self.stopTimer()
        
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(scroll), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc fileprivate func scroll() {
        scrollView?.setContentOffset(CGPoint(x: 0, y: scrollView!.contentOffset.y + scrollView!.frame.size.height), animated: true)
    }
    
    fileprivate func doAfterScroll() {
        if self.nextIndex < 0 {
            self.nextIndex = self.textArray.count - 1
        } else {
            self.nextIndex = (self.currentIndex + 1) % self.textArray.count
        }
        
        self.loadLabel(label: self.lastLabel!, index: self.nextIndex)
    }
}

extension MarqueeLabel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.doAfterScroll()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.reloadLabel()
    }
}
