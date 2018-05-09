//
//  ViewController.swift
//  DDScrollBannerView
//
//  Created by DDBB on 2018/5/9.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageArr = ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1525854814473&di=2730f0f4f16f8b987e5c55ad8d76d354&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F0142135541fe180000019ae9b8cf86.jpg%401280w_1l_2o_100sh.png","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1525854814473&di=2730f0f4f16f8b987e5c55ad8d76d354&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F0142135541fe180000019ae9b8cf86.jpg%401280w_1l_2o_100sh.png"]
        
        let scrollView = DDScrollBanner.init(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.size.width , height: 150), ImagesArr: imageArr)
        view.addSubview(scrollView)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

