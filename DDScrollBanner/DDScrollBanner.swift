//
//  DDScrollBannerView.swift
//  DDScrollBannerView
//
//  Created by DDBB on 2018/5/9.
//

import UIKit
import Kingfisher

//图片轮播组件代理协议
protocol ScrollBannerViewDelegate {
    func handleTapAction(index: Int) -> Void
}

class DDScrollBanner: UIView {
    public var delegate: ScrollBannerViewDelegate!
    public var interval: Double = 5.0
    let kScreenWidth = UIScreen.main.bounds.size.width
    
    // 当前展示的图片索引
    var currentIndex: Int = 0
    var dataSource: [String]?
    
    // 用于轮播的左中右三个image（不管几张图片都是这三个imageView交替使用）
    var leftImageView, middleImageView, rightImageView: UIImageView?
    var scrollerView: UIScrollView?
    var scrollerViewWidth: CGFloat?
    var scrollerViewHeight: CGFloat?
    var pageControl: UIPageControl?
    
    // 自动滚动计时器
    var autoScrollTimer: Timer?
    
    func relodataData(ImagesArr:[String]) {
        self.autoScrollTimer?.invalidate()
        self.dataSource =  ImagesArr
        self.configureImageView()
        self.configurePageController()
        if ImagesArr.count > 1 {
            self.scrollerView?.isScrollEnabled = true
            
            self.configureAutoScrollTimer()
        } else {
            self.scrollerView?.isScrollEnabled = false
        }
        
    }
    
    init(frame: CGRect, ImagesArr: [String]) {
        super.init(frame: frame)
        self.scrollerViewWidth = frame.width
        self.scrollerViewHeight = frame.height
        self.dataSource = ImagesArr
        self.configureScrollerView()
        self.configureImageView()
        self.configurePageController()
        if ImagesArr.count > 1 {
            self.scrollerView?.isScrollEnabled = true
            
            // 设置自动滚动计时器
            self.configureAutoScrollTimer()
        } else {
            self.scrollerView?.isScrollEnabled = false
        }
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 设置scrollerView
    func configureScrollerView() {
        self.scrollerView = UIScrollView(frame: CGRect(x: 0,y: 0, width: self.scrollerViewWidth!, height: self.scrollerViewHeight!))
        self.scrollerView?.delegate = self
        self.scrollerView?.contentSize = CGSize(width: self.scrollerViewWidth! * 3, height: self.scrollerViewHeight!)
        
        // 滚动视图内容区域向左偏移一个view的宽度
        self.scrollerView?.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
        self.scrollerView?.isPagingEnabled = true
        self.scrollerView?.bounces = false
        self.addSubview(self.scrollerView!)
    }
    // 设置imageView
    func configureImageView(){
        if self.leftImageView == nil {
            self.leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.scrollerViewWidth!, height: self.scrollerViewHeight!))
            self.middleImageView = UIImageView(frame: CGRect(x: self.scrollerViewWidth!, y: 0,  width: self.scrollerViewWidth!, height: self.scrollerViewHeight! ));
            self.rightImageView = UIImageView(frame: CGRect(x: 2*self.scrollerViewWidth!, y: 0, width: self.scrollerViewWidth!, height: self.scrollerViewHeight!));
            self.scrollerView?.showsHorizontalScrollIndicator = false
            
            
            self.scrollerView?.addSubview(self.leftImageView!)
            self.scrollerView?.addSubview(self.middleImageView!)
            self.scrollerView?.addSubview(self.rightImageView!)
        }
        // 设置初始时左中右三个imageView的图片（分别时数据源中最后一张，第一张，第二张图片）
        if(self.dataSource?.count != 0){
            self.touchViewAction()
            resetImageViewSource()
        } else {
            // 如果没有图片，站位图
            self.middleImageView?.image = UIImage.init(named: "")
        }
        
    }
    
    // 设置页控制器
    func configurePageController() {
        if self.pageControl == nil {
            self.pageControl = UIPageControl(frame: CGRect(x: kScreenWidth/2-60, y: self.scrollerViewHeight! - 20, width: 120, height: 20))
            self.pageControl?.backgroundColor = UIColor.clear
            self.pageControl?.isUserInteractionEnabled = false
            self.addSubview(self.pageControl!)
        }
        self.pageControl?.numberOfPages = (self.dataSource?.count)!
        self.pageControl?.isHidden = (self.dataSource?.count)! == 1
    }
    
    // 设置自动滚动计时器
    func configureAutoScrollTimer() {
        autoScrollTimer = Timer.scheduledTimer(timeInterval: self.interval, target: self,
                                               selector: #selector(letItScroll),
                                               userInfo: nil, repeats: true)
    }
    
    @objc func letItScroll(){
        let offset = CGPoint(x: 2*scrollerViewWidth!, y: 0)
        self.scrollerView?.setContentOffset(offset, animated: true)
    }
    
    // 每当滚动后重新设置各个imageView的图片
    func resetImageViewSource() {
        let resetBlc: CompletionHandler = {(image, error, cacheType, imageURL) in
            if error != nil {
                self.notificaImageError()
            }
        }
        // 当前显示的是第一张图片
        if self.currentIndex == 0 {
            self.leftImageView?.kf.setImage(with: URL(string: (self.dataSource?.last)!), placeholder: nil, completionHandler: resetBlc)
            self.self.middleImageView?.kf.setImage(with: URL(string: (self.dataSource?.first)!), placeholder: nil, completionHandler: resetBlc)
            let rightImageIndex = (self.dataSource?.count)!>1 ? 1 : 0 //保护
            self.rightImageView?.kf.setImage(with: URL(string: (self.dataSource?[rightImageIndex])!), completionHandler: resetBlc)
        }
            // 当前显示的是最好一张图片
        else if self.currentIndex == (self.dataSource?.count)! - 1 {
            self.leftImageView?.kf.setImage(with: URL(string: (self.dataSource?[currentIndex - 1])!), completionHandler: resetBlc)
            self.middleImageView?.kf.setImage(with: URL(string: (self.dataSource?.last)!), completionHandler: resetBlc)
            self.rightImageView?.kf.setImage(with: URL(string: (self.dataSource?.first)!), completionHandler: resetBlc)
        }
            // 其他情况
        else {
            self.leftImageView?.kf.setImage(with: URL(string: (self.dataSource?[currentIndex - 1])!), completionHandler: resetBlc)
            self.middleImageView?.kf.setImage(with: URL(string: (self.dataSource?[currentIndex])!), completionHandler: resetBlc)
            self.rightImageView?.kf.setImage(with: URL(string: (self.dataSource?[currentIndex + 1])!), completionHandler: resetBlc)
        }
    }
    
    func touchViewAction(){
        // 添加组件的点击事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapAction(_:)))
        self.addGestureRecognizer(tap)
    }
    
    // 点击事件响应@objc
    @objc func handleTapAction(_ tap: UITapGestureRecognizer) -> Void{
        if self.delegate != nil {
            self.delegate.handleTapAction(index: self.currentIndex)
        }
    }
    /// 图片加载error
    private func notificaImageError() {
        
    }
}

extension DDScrollBanner: UIScrollViewDelegate {
    // scrollView滚动完毕后触发
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 获取当前偏移量
        let offset = scrollView.contentOffset.x
        if(self.dataSource?.count != 0){
            
            // 如果向左滑动（显示下一张）
            if(offset >= self.scrollerViewWidth!*2) {
                // 还原偏移量
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
                
                // 视图索引+1
                self.currentIndex = self.currentIndex + 1
                
                if self.currentIndex == self.dataSource?.count {
                    self.currentIndex = 0
                }
            }
            // 如果向右滑动（显示上一张）
            if(offset <= 0) {
                //还原偏移量
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
                //视图索引-1
                self.currentIndex = self.currentIndex - 1
                
                if self.currentIndex == -1 {
                    self.currentIndex = (self.dataSource?.count)! - 1
                }
            }
            // 重新设置各个imageView的图片
            resetImageViewSource()
            
            // 设置页控制器当前页码
            self.pageControl?.currentPage = self.currentIndex
        }
    }
    
    // 手动拖拽滚动开始
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 使自动滚动计时器失效（防止用户手动移动图片的时候这边也在自动滚动）
        autoScrollTimer?.invalidate()
    }
    
    // 手动拖拽滚动结束
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        // 重新启动自动滚动计时器
        configureAutoScrollTimer()
    }
}

