//
//  PokemonFlowLayout.swift
//  Pokemon Cover Flow
//
//  Created by Best Mac on 02.05.2020.
//  Copyright © 2020 DaftAcademy. All rights reserved.
//

import UIKit

class PokemonViewFlowLayout: UICollectionViewFlowLayout {
    
    private var cellAttributes = [IndexPath: PokemonViewLayoutAttributes]()
    
    override func prepare() {
        cellAttributes = [IndexPath: PokemonViewLayoutAttributes]()
        for section in 0 ..< collectionView!.numberOfSections {
        for item in 0 ..< collectionView!.numberOfItems(inSection: section) {
            let indexPath = IndexPath(item: item, section: section)
            let attributes = PokemonViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(origin: CGPoint(x: 250 * item, y: 0), size: CGSize(width: 250, height: collectionViewContentSize.height))
            cellAttributes[indexPath] = attributes
            }
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var attributeList = [UICollectionViewLayoutAttributes]()
        
        for (_, attributes) in cellAttributes {
          if attributes.frame.intersects(rect) {
            let collectionCenter = collectionView!.bounds.size.width / 2
            let offset = collectionView!.contentOffset.x
            let normalizedCenter = attributes.center.x - offset
            
            let maxDistance = CGFloat(250.0)
            let distanceFromCenter = min(collectionCenter - normalizedCenter, maxDistance)
            let ratio = (maxDistance - abs(distanceFromCenter)) / maxDistance
            
            attributes.imageAlpha = ratio
            attributes.sizeChange = ratio
            attributeList.append(attributes)
          }
        }
        
        return attributeList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItem(at: indexPath)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}

class PokemonViewLayoutAttributes:  UICollectionViewLayoutAttributes {
    open var imageAlpha: CGFloat = 1.0
    open var sizeChange: CGFloat = 0.0
    
    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! PokemonViewLayoutAttributes
        copy.imageAlpha = imageAlpha
        copy.sizeChange = sizeChange
        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? PokemonViewLayoutAttributes {
            if attributes.imageAlpha == imageAlpha && attributes.sizeChange == sizeChange {
                return super.isEqual (object)
            }
        }
        return false
    }
}
