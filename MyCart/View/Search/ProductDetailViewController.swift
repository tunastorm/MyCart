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
    let noURLErrorView = UIView()
    
    var likeButton: UIBarButtonItem?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNoURLErrorView()
        configHierarchy()
        configLayout()
        configView()
        viewToggle(isError: false)
        configLikeButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let title = product?.title.replacingOccurrences(of: "<b>", with: "")
        navigationItem.title = title?.replacingOccurrences(of: "</b>", with: "")
        configWebView()
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
        print(#function, product?.link)
        guard let link = product?.link,
              let url = URL(string: link) else {
            print(#function, "빨간징징이")
            viewToggle(isError: true)
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func configNoURLErrorView() {
        let errorImage = UIImageView(image: Resource.SystemImage.networkSlash).then {
            $0.tintColor = Resource.MyColor.lightGray
            $0.contentMode = .scaleAspectFit
        }
        let errorLabel = UILabel().then {
            $0.font = Resource.Font.boldSystem16
            $0.textAlignment = .center
            $0.textColor = Resource.MyColor.lightGray
            $0.text = StatusMessage.APIError.productURLNotExist.message
        }
        
        view.addSubview(noURLErrorView)
        noURLErrorView.addSubview(errorImage)
        noURLErrorView.addSubview(errorLabel)
        
        noURLErrorView.snp.makeConstraints {
            $0.size.equalTo(300)
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        errorImage.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.8)
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(errorImage.snp.bottom)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    
    func viewToggle(isError: Bool) {
        if isError {
            webView.isHidden = true
            noURLErrorView.isHidden = false
        } else {
            webView.isHidden = false
            noURLErrorView.isHidden = true
        }
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
