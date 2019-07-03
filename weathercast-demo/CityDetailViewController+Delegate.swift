//
//  CityDetailViewController+DataSource.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/07/03.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

// MARK: UITableViewDelegate

extension CityDetailViewController {
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.backgroundView?.backgroundColor = .white
        headerView.textLabel?.font = UIFont(name: "Helvetica Neue", size: 18.0)
        headerView.textLabel?.textColor = .black
    }
}
