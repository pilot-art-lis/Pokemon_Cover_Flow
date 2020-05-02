import UIKit

class PokemonCell: UICollectionViewCell {
    
    var block = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 150, height: 150)))
    var imageView = UIImageView()
    var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        block.center = contentView.center
        block.layer.cornerRadius = block.frame.width * 0.5
        
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        imageView.center.x = block.bounds.midX
        imageView.center.y = block.bounds.midY
        
        titleLabel.frame = CGRect(origin: .zero, size: CGSize(width: contentView.frame.width, height: 25))
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.frame.origin.y = block.frame.maxY
        titleLabel.textAlignment = .center
        
        block.addSubview(imageView)
        
        addSubview(block)
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        imageView.alpha = layoutAttributes.alpha
    }
}
