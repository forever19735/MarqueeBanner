//
//  ViewController.swift
//  MarqueeBanner
//
//  Created by john.lin on 2018/10/16.
//  Copyright © 2018年 john.lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var marqueeBanner: MarqueeView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
    }
    
    func setupBanner() {
        let images: [String] = ["icon_circle_online", "icon_memberChampion", "icon_message"]
        marqueeBanner = MarqueeView(frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 120), imageArray: images as [AnyObject], duration: 3.0)
        marqueeBanner?.delegate = self
        marqueeBanner?.backgroundColor = UIColor.gray
        self.view.addSubview(marqueeBanner!)
    }
}

extension ViewController: MarqueeViewDelegate {
    func tapFromMarqueeBannerIndex(index: Int) {
        print("點選第\(index)張圖片")
    }
}

