//
//  SelectPhotoViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

import SnapKit



class SelectPhotoCollectionViewController: UIViewController {

    var delegate: SignUpViewController?
    
    var selectedCell: IndexPath?
    var selectedPhoto: UIImage?
    
    let photoList = Resource.NamedImage.allProfile
    
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
    
    lazy var collectiomView = UICollectionView(frame: .zero,
                                          collectionViewLayout: collectionViewLayout())
    
    let collectionViewHeight = UIScreen.main.bounds.width - 90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBaseSetting()
        configHierarchy()
        configLayout()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configUpdateViewToggle()
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let horizontalCount = CGFloat(4)
        let verticalCount = CGFloat(3)
        let lineSpacing = CGFloat(10)
        let itemSpacing = CGFloat(5)
        let inset = CGFloat(10)
        
        let width = UIScreen.main.bounds.width - (inset * 2) - (itemSpacing * horizontalCount-1)
        let height = collectionViewHeight - (inset * 2) - (lineSpacing * verticalCount-1)
        
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
    
    func configBaseSetting() {
        collectiomView.delegate = self
        collectiomView.dataSource = self
        collectiomView.register(SelectPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: SelectPhotoCollectionViewCell.identifier)
    }
    
    func configHierarchy() {
        view.addSubview(profileView)
        profileView.addSubview(profileImageView)
        profileView.addSubview(cameraIconView)
        cameraIconView.addSubview(cameraIcon)
        view.addSubview(collectiomView)
    }
    
    func configLayout() {
        
        profileView.snp.makeConstraints {
            $0.size.equalTo(120)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
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
        
        let height = UIScreen.main.bounds.width - 80
        collectiomView.snp.makeConstraints {
            $0.height.equalTo(collectionViewHeight)
            $0.top.equalTo(profileView.snp.bottom).offset(50)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configView() {
        view.backgroundColor = .white
        profileImageView.image = selectedPhoto
        navigationItem.title = Resource.Text.profileSetting
    }
    
    func configUpdateViewToggle() {
        guard let delegate else {return}
        var naviTitle =  Resource.Text.profileSetting
        if delegate.isUpdateView {
            naviTitle = Resource.Text.editProfileTitle
        }
        navigationItem.title = naviTitle
    }
}


extension SelectPhotoCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectPhotoCollectionViewCell.identifier,
                                                      for: indexPath) as! SelectPhotoCollectionViewCell
        
        
        let thisPhoto = photoList[indexPath.row]
        cell.configCell(image: thisPhoto)
        
        guard let selectedPhoto else {return cell}
        
        // UIImage 객체 생성 시 입력한 에셋파일의 이름 가져오기
        var selectedName = String(selectedPhoto.description).split(separator: " ")[2].replacingOccurrences(of: ")", with: "")
        var thisName = String(thisPhoto.description).split(separator: " ")[2].replacingOccurrences(of: ")", with: "")
        
        // 이름이 같을 경우 해당 셀을 선택된 상태로 설정
        // -> 페이지 로드시 이전 화면에서 랜덤 생성된 이미지가 기본 선택됨
        if selectedName == thisName {
            cell.configSelectedUI()
            selectedCell = indexPath
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let selectedCell {
            let lastCell = collectionView.cellForItem(at: selectedCell) as! SelectPhotoCollectionViewCell
            lastCell.configUnselectedUI()
        }
      
        let cell = collectionView.cellForItem(at: indexPath) as! SelectPhotoCollectionViewCell
        cell.configSelectedUI()
        selectedCell = indexPath
        selectedPhoto = cell.imageView.image
        profileImageView.image = selectedPhoto
        delegate?.receiveData(data: selectedPhoto)
    }
}
 
