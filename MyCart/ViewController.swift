//
//  ViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/13/24.
//

import UIKit

class ViewController: UIViewController {

    let APICon = APIController()
    
    override func loadView() {
        APICon.requestSearch("선물", sort: .date, page: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
}
