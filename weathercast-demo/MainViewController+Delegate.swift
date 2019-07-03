//
//  MainViewController+Delegate.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/07/03.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

// MARK: UICollectionViewDelegate

extension MainViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCellImage = self.cityImages[indexPath.row]

        guard let cell = collectionView.cellForItem(at: indexPath) else { return }

        selectedCellSnapshot = UIImageView(image: UIImage(view: cell.contentView))
    }
}
