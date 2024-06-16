//
//  SelectPhotoViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

class SelectPhotoViewController: UIViewController {

    var delegate: SignUpViewController?
    
    var photoList: [UIImage]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setPhotoList() {
        for i in 0...11 {
            photoList?.append(UIImage(named: ""))
        }
    }
    
    
    
}
