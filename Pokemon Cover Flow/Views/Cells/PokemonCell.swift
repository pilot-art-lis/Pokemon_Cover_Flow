import UIKit

class PokemonCell: UICollectionViewCell {
    
    var block = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 250, height: 250)))
    var blockImage = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 150, height: 150)))
    var imageView = UIImageView()
    var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        block.center = contentView.center
        
        blockImage.center.x = block.bounds.midX
        blockImage.center.y = block.bounds.midY
        blockImage.layer.cornerRadius = blockImage.frame.width * 0.5
        
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        imageView.center.x = blockImage.bounds.midX
        imageView.center.y = blockImage.bounds.midY
        
        titleLabel.frame = CGRect(origin: .zero, size: CGSize(width: contentView.frame.width, height: 25))
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.frame.origin.y = blockImage.frame.maxY
        titleLabel.textAlignment = .center
        
        blockImage.addSubview(imageView)
        
        block.addSubview(blockImage)
        block.addSubview(titleLabel)
        
        addSubview(block)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attr = layoutAttributes as? PokemonViewLayoutAttributes {
            imageView.alpha = attr.imageAlpha
            self.block.transform = CGAffineTransform(scaleX: attr.sizeChange / 2 + 1, y: attr.sizeChange / 2 + 1)
        }
    }
}
