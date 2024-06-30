//
//  MainTableViewExtension.swift
//  MyCart
//
//  Created by 유철원 on 6/17/24.
//

import UIKit


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        guard let searchedList else {return cell}
        cell.delegate = self
        cell.configCell(data: searchedList[indexPath.row])
        return cell
    }
}
