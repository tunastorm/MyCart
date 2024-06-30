//
//  SelectPhotoView.swift
//  MyCart
//
//  Created by 유철원 on 6/30/24.
//

import UIKit


class SelectPhotoView: BaseView {
    
    var delegate: SelectPhotoViewDelegate?
    
    let profileView = UIView()
    
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = Resource.Border.width3
        $0.layer.borderColor = Resource.MyColor.orange.cgColor
        $0.layer.cornerRadius = Resource.CornerRadious.profileImageView
        $0.layer.masksToBounds = true
    }
    
    let cameraIconView = UIView().then {
        $0.backgroundColor = Resource.MyColor.orange
        $0.layer.cornerRadius = Resource.CornerRadious.cameraIcon
        $0.layer.masksToBounds = true
    }
    
    let cameraIcon = UIImageView(image: Resource.SystemImage.cameraFill).then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Resource.MyColor.white
    }
    
    let collectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        
        let horizontalCount = CGFloat(4)
        let verticalCount = CGFloat(3)
        let lineSpacing = CGFloat(10)
        let itemSpacing = CGFloat(5)
        let inset = CGFloat(10)
        
        let width = UIScreen.main.bounds.width - (inset * 2) - (itemSpacing * horizontalCount-1)
        let height = UIScreen.main.bounds.width - 90 - (inset * 2) - (lineSpacing * verticalCount-1)
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width / horizontalCount,
                                 height: height / verticalCount)
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: inset,
                                           left: inset,
                                           bottom: inset,
                                           right: inset)
        return layout
    }
    
    
    lazy var collectiomView = UICollectionView(frame: .zero,
                                          collectionViewLayout: collectionViewLayout())

    override func configHierarchy() {
        self.addSubview(profileView)
        profileView.addSubview(profileImageView)
        profileView.addSubview(cameraIconView)
        cameraIconView.addSubview(cameraIcon)
        self.addSubview(collectiomView)
    }
    
    override func configLayout() {
        
        profileView.snp.makeConstraints {
            $0.size.equalTo(120)
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cameraIconView.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.bottom.trailing.equalToSuperview()
        }
        
        cameraIcon.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        
        let collectionViewHeight = UIScreen.main.bounds.width - 90
        collectiomView.snp.makeConstraints {
            $0.height.equalTo(collectionViewHeight)
            $0.top.equalTo(profileView.snp.bottom).offset(50)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        self.backgroundColor = .white
        profileImageView.image = delegate?.getSelectedPhoto()
    }
}
