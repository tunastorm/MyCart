//
//  ProductDetailViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit
import WebKit

import SnapKit

class ProductDetailViewController: UIViewController {
    
    var delegate: SearchViewController?
    
    var product: ShopItem?
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configWebView()
        configHierarchy()
        configLayout()
        configView()
      
    }
    
    func configHierarchy() {
        view.addSubview(webView)
    }
    
    func configLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configView() {
        view.backgroundColor = Resource.MyColor.white
        let title = product?.title.replacingOccurrences(of: "<b>", with: "")
        navigationItem.title = title?.replacingOccurrences(of: "</b>", with: "")
    }
    
    func configWebView() {
        guard let link = product?.link else {return}
        guard let url = URL(string: link) else {return}
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
}
