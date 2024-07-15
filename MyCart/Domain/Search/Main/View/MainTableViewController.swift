//
//  MainTableViewExtension.swift
//  MyCart
//
//  Created by 유철원 on 6/17/24.
//

import UIKit


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputSearchedList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        let data = viewModel.outputSearchedList.value[indexPath.row]
        cell.delegate = self
        cell.configCell(indexPath.row, data)
        return cell
    }
    
    
}
