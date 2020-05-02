//
//  PokemonFlowLayout.swift
//  Pokemon Cover Flow
//
//  Created by Taras Kulyavets on 02.05.2020.
//  Copyright © 2020 DaftAcademy. All rights reserved.
//

import UIKit

class PokemonFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let arr = super.layoutAttributesForElements(in: rect)

        for atts:UICollectionViewLayoutAttributes in arr! {
            if nil == atts.representedElementKind {
                let ip = atts.indexPath
                atts.frame = (self.layoutAttributesForItem(at: ip)?.frame)!
            }
        }
        return arr
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let atts = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else do {
            return
        }

        if indexPath.item == 0 || indexPath.item == 1 {
            var frame = atts?.frame;
            frame?.origin.x = sectionInset.top;
            atts?.frame = frame!;
            return atts
        }
//
//        let ipPrev = IndexPath(item: indexPath.item - 2, section: indexPath.section)
//
//        let fPrev = self.layoutAttributesForItem(at: ipPrev)?.frame
//
//        let rightPrev = (fPrev?.origin.y)! + (fPrev?.size.height)! + 10
//
//        if (atts?.frame.origin.y)! <= rightPrev {
//            return atts
//        }
//
//        var f = atts?.frame
//        f?.origin.y = rightPrev
//        atts?.frame = f!
        return atts
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
}
