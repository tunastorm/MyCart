//
//  LikedItemDetailViewController.swift
//  MyCart
//
//  Created by 유철원 on 7/11/24.
//

import UIKit
import WebKit
import SnapKit
import Then


final class LikedItemDetailViewController: BaseViewController {
    
    var delegate: LikedItemCollectionViewCellDelegate?
    var row: Int?
    var product: ShopItem?

    let webView = WKWebView()
    private let errorView = UIView()
    private let errorLabel = UILabel().then {
        $0.font = Resource.Font.boldSystem16
        $0.textAlignment = .center
        $0.textColor = Resource.MyColor.lightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configExternalResource()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let delegate, let productId = product?.productId else {
            return
        }
    }
    
    override func configHierarchy() {
        view.addSubview(webView)
    }
    
    override func configLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        super.configView()
        configErrorView()
    }
    
    private func configErrorView() {
        let errorImage = UIImageView(image: Resource.SystemImage.networkSlash).then {
            $0.tintColor = Resource.MyColor.lightGray
            $0.contentMode = .scaleAspectFit
        }
        errorImage.isHidden = true
        
        view.addSubview(errorView)
        errorView.addSubview(errorImage)
        errorView.addSubview(errorLabel)
        
        errorView.snp.makeConstraints {
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
    
    private func viewToggle(error: MapKitError) {
        switch error {
        case .productURLNotExist, .productConnectionFailed:
            webView.isHidden = true
            errorView.isHidden = false
        default:
            webView.isHidden = false
            errorView.isHidden = true
        }
    }

    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
        let title = product?.title.replacingOccurrences(of: "<b>", with: "")
        navigationItem.title = title?.replacingOccurrences(of: "</b>", with: "")
        configLikeButton()
    }
    
    private func configExternalResource() {
        webView.navigationDelegate = self
        guard let link = product?.link, let url = URL(string: link) else {
            errorLabel.text = MapKitError.productURLNotExist.message
            viewToggle(error: MapKitError.productURLNotExist)
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func configLikeButton() {
        guard let delegate, let productId = product?.productId, let row else {
            return
        }
        let cartImage = Resource.IsLike.like.image
        let likeButton = UIBarButtonItem(image: cartImage, style: .plain, target: self, action: #selector(likeButtonClicked))
        likeButton.tag = row
        navigationItem.rightBarButtonItem = likeButton
    }
    
    @objc private func likeButtonClicked(_ sender: UIButton) {
        guard let productId = product?.productId else {
            return
        }
        delegate?.deleteLikedItem(productId, inDetail: true)
    }
}

extension LikedItemDetailViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        errorLabel.text = MapKitError.productConnectionFailed.message
        viewToggle(error:MapKitError.productConnectionFailed)
    }
}



