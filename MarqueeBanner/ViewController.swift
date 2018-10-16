//
//  ViewController.swift
//  MarqueeBanner
//
//  Created by john.lin on 2018/10/16.
//  Copyright © 2018年 john.lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var marqueeBanner: MarqueeImage?
    var marqueeLabel: MarqueeLabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        setupBanner()
    }
    
    func setupBanner() {
        let images: [String] = ["icon_circle_online", "icon_memberChampion", "icon_message"]
        marqueeBanner = MarqueeImage(frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 120), imageArray: images as [AnyObject], duration: 3.0)
        marqueeBanner?.delegate = self
        marqueeBanner?.backgroundColor = UIColor.gray
        self.view.addSubview(marqueeBanner!)
    }
    
    func setupLabel() {
        let texts: [String] = ["白晝之夜白晝之夜白晝之夜白晝之夜白晝之夜白晝之夜白晝之夜白晝之夜白晝之夜白晝之夜", "游牧森林音樂祭游牧森林音樂祭游牧森林音樂祭游牧森林音樂祭游牧森林音樂祭游牧森林音樂祭游牧森林音樂祭游牧森林音樂祭游牧森林音樂祭游牧森林音樂祭", "iPlaygroundiPlaygroundiPlaygroundiPlaygroundiPlaygroundiPlayground"]
        marqueeLabel = MarqueeLabel(frame: CGRect(x: 0, y: 50, width: self.view.bounds.width, height: 40), textArray: texts)
        marqueeLabel?.backgroundColor = UIColor.black
        marqueeLabel?.delegate = self
        self.view.addSubview(marqueeLabel!)
    }
}

extension ViewController: MarqueeViewDelegate {
    func tapFromMarqueeLabelIndex(index: Int) {
        print("點選第\(index)個文案")
    }
    
    func tapFromMarqueeBannerIndex(index: Int) {
        print("點選第\(index)張圖片")
    }
}

