//
//  ProductDetailViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit
import WebKit

import SnapKit
import Then

class ProductDetailViewController: UIViewController {
    
    var delegate: SearchViewController?
    
    var product: ShopItem?
    
    let webView = WKWebView()
    var likeButton: UIBarButtonItem?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configWebView()
        configHierarchy()
        configLayout()
        configView()
        configLikeButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let title = product?.title.replacingOccurrences(of: "<b>", with: "")
        navigationItem.title = title?.replacingOccurrences(of: "</b>", with: "")
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
    }
    
    func configWebView() {
        guard let link = product?.link else {return}
        guard let url = URL(string: link) else {return}
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func configLikeButton() {
        
        var cartImage = Resource.NamedImage.likeUnselected?.withRenderingMode(.alwaysOriginal)

        guard let id = product?.productId,
              let isLiked = delegate?.getIsLiked(productId: id) else {return}
        
        if isLiked {
            cartImage = Resource.NamedImage.likeSelected?.withRenderingMode(.alwaysOriginal)
        }
        likeButton = UIBarButtonItem(image: cartImage,
                                         style: .plain, target: self,
                                         action: #selector(likeButtonClicked))
        
        guard let likeButton else {return}
        navigationItem.rightBarButtonItems = [likeButton]
    }
    
    @objc func likeButtonClicked(_ sender: UIButton) {
        guard let productId = product?.productId else {return}
        delegate?.setIsLiked(productId)
        configLikeButton()
    }
}
