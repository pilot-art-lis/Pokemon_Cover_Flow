import UIKit

class PokemonCoverFlowViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    var collectionView: UICollectionView { return view as! UICollectionView }
    let layout = PokemonViewFlowLayout()
    let pokemonLoader: PokemonLoader
    var pokemons: [Pokemon] = []
    var pageControl: UIPageControl = UIPageControl()

    override func loadView() {
        view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
    }
    
    init(pokemonLoader: PokemonLoader = PokemonLoaderImpl()){
        self.pokemonLoader = pokemonLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        pokemonLoader.load(completion: { pokemons  in
            self.pokemons = pokemons ?? []
            
            self.collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: "CELL")
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.translatesAutoresizingMaskIntoConstraints = false
            self.collectionView.contentInsetAdjustmentBehavior = .never
            self.collectionView.contentInset.left = 80
            self.layout.scrollDirection = .horizontal
        
        })
	}

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let pageWidth = Float(250)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(collectionView.contentSize.width)
        var newPage = Float(self.pageControl.currentPage)

        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1
        } else {
            newPage = Float(velocity.x > 0 ? self.pageControl.currentPage + 1 : self.pageControl.currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        self.pageControl.currentPage = Int(newPage)
        let point = CGPoint (x: CGFloat(-82 + newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
        
        layout.invalidateLayout()
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pageControl.numberOfPages = pokemons.count
        return pokemons.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! PokemonCell
        let pokemon = pokemons[indexPath.item]
        
        pokemonLoader.loadImage(index: pokemon.number, completion: { image in
            cell.imageView.image = image
        })
        
        cell.blockImage.backgroundColor = pokemon.colorValue
        cell.titleLabel.textColor = pokemon.colorValue
        cell.titleLabel.text = pokemon.name
        
        let catchCesture = CatchGestureRecognizer(target: self, action: #selector(catchPokemon(_:) ))
        catchCesture.numberOfTapsRequired = 1
        catchCesture.id = indexPath.item
        
        cell.block.addGestureRecognizer(catchCesture)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 250, height: collectionView.bounds.height)
    }
    
    @objc func catchPokemon(_ sender: CatchGestureRecognizer) {
        let id = sender.id
        guard let view: PokemonCell = (sender.view!.superview as? PokemonCell) else { return  }
        let pokemonId = self.pokemons[id].number
        pokemonLoader.catchPokemon(index: pokemonId, completion: { pokemon  in
            if let pokemon = pokemon {
                self.pokemons[id] = pokemon
                view.blockImage.backgroundColor = pokemon.colorValue
                view.titleLabel.textColor = pokemon.colorValue
                view.titleLabel.text = pokemon.name
                self.pokemonLoader.loadImage(index: pokemon.number, completion: { image in
                    view.imageView.image = image
                })
            }
        })
    }
}

