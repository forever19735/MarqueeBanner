//
//  MarqueeView.swift
//  MarqueeBanner
//
//  Created by john.lin on 2018/10/16.
//  Copyright © 2018年 john.lin. All rights reserved.
//
import UIKit

protocol MarqueeViewDelegate: class {
    func tapFromMarqueeBannerIndex(index: Int)
}

class MarqueeView: UIView {
    weak var delegate: MarqueeViewDelegate?
    
    enum MarqueeViewDirection {
        case None, Left, Right
    }
    
    fileprivate var scrollView: UIScrollView?
    
    fileprivate var pageControl: UIPageControl?
    
    fileprivate var imageArray: [AnyObject]?
    
    fileprivate var timer: Timer?
    
    fileprivate var currentImageView: UIImageView?
    
    fileprivate var otherImageView: UIImageView?
    
    fileprivate var currentIndex = 0
    
    fileprivate var nextIndex = 1
    
    fileprivate var currentDirection: MarqueeViewDirection = .None
    
    var duration: TimeInterval = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, imageArray: [AnyObject], duration: TimeInterval = 5.0) {
        super.init(frame: frame)
        self.imageArray = imageArray
        self.duration = duration
        self.reload()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.stopTimer()
    }
    
    fileprivate func reload() {
        startTimer()
        setupScrollView()
    }
    
    func startTimer() {
        if self.imageArray!.count <= 1 {
            return
        }
        stopTimer()
        
        timer = Timer.scheduledTimer(timeInterval: self.duration, target: self, selector: #selector(scroll), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc fileprivate func scroll() {
        self.scrollView?.setContentOffset(CGPoint(x: self.scrollView!.bounds.size.width * 2, y: 0), animated: true)
    }
    
    fileprivate func setupImage() {
        self.currentImageView = createImage(index: 0)
        self.otherImageView = createImage(index: 1)
        
        self.scrollView?.addSubview(currentImageView!)
        self.scrollView?.addSubview(otherImageView!)
        
        self.currentImageView?.frame = CGRect(x: self.bounds.size.width, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        self.loadImage(imageView: self.currentImageView!, index: 0)
    }
    
    fileprivate func setupPage() {
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: self.bounds.size.height - 30, width: self.bounds.size.width, height: 30))
        self.addSubview(self.pageControl!)
        
        self.pageControl?.numberOfPages = self.imageArray!.count
        self.pageControl?.currentPage = 0
        self.pageControl?.hidesForSinglePage = true
    }
    
    fileprivate func createImage(index: Int) -> UIImageView {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.frame = CGRect(x: scrollView!.frame.size.width * CGFloat(index), y: 0, width: scrollView!.frame.size.width, height: scrollView!.frame.size.height)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTaped(_:)))
        self.addGestureRecognizer(tap)
        
        return image
    }
    
    fileprivate func reloadImage() {
        self.currentDirection = .None
        //取得當前位置
        let index = self.scrollView!.contentOffset.x / self.scrollView!.bounds.size.width
        if index == 1 { return }
        self.currentIndex = self.nextIndex
        self.pageControl!.currentPage = self.currentIndex
        
        self.currentImageView?.frame = CGRect(x: self.scrollView!.bounds.size.width, y: 0, width: self.scrollView!.bounds.size.width, height: self.scrollView!.bounds.size.height)
        self.currentImageView!.image = self.otherImageView!.image
        self.scrollView?.contentOffset = CGPoint(x: self.scrollView!.bounds.size.width, y: 0)
    }
    
    fileprivate func loadImage(imageView: UIImageView, index: Int) {
        if imageArray?.count == 0 {
            return
        }
        let imageData = imageArray![index]
        if imageData is String {
            imageView.image = UIImage(named: imageData as! String)
        } else if imageData is UIImage {
            imageView.image = imageData as? UIImage
        } else {
            imageView.image = nil
        }
    }
    
    @objc func imageTaped(_ tap: UITapGestureRecognizer) {
        delegate?.tapFromMarqueeBannerIndex(index: currentIndex)
    }
    
    fileprivate func setupScrollView() {
        self.scrollView = UIScrollView(frame: self.bounds)
        self.scrollView?.contentSize = CGSize(width: self.bounds.size.width * 3, height: self.bounds.size.height)
        self.scrollView?.contentOffset = CGPoint(x: self.bounds.size.width, y: 0)
        self.scrollView?.isPagingEnabled = true
        self.scrollView?.bounces = false
        self.scrollView?.scrollsToTop = false
        self.scrollView?.showsVerticalScrollIndicator = false
        self.scrollView?.showsHorizontalScrollIndicator = false
        self.scrollView?.delegate = self
        self.addSubview(self.scrollView!)
        
        setupImage()
        setupPage()
        reloadImage()
        
        if self.pageControl?.numberOfPages == 1 {
            self.scrollView?.contentSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height)
            self.scrollView?.contentOffset = CGPoint.zero
            self.currentImageView?.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        }
    }
}

extension MarqueeView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.reloadImage()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.currentDirection = .None
        self.reloadImage()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.currentDirection = scrollView.contentOffset.x > scrollView.bounds.size.width ? .Left : .Right
        
        if self.currentDirection == .Right {
            self.otherImageView!.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
            self.nextIndex = self.currentIndex - 1
            if self.nextIndex < 0 {
                self.nextIndex = self.imageArray!.count - 1
            }
        } else if self.currentDirection == .Left {
            self.otherImageView?.frame = CGRect(x: self.currentImageView!.frame.maxX, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
            self.nextIndex = (self.currentIndex + 1) % self.imageArray!.count
        }
        
        self.loadImage(imageView: self.otherImageView!, index: self.nextIndex)
    }
}
