import UIKit

class PokemonCoverFlowViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    var collectionView: UICollectionView { return view as! UICollectionView }
    let layout = PokemonFlowLayout()
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
            
            self.layout.scrollDirection = .horizontal
        })
	}

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //Ustawić jedno kółko po środku i dwa zmniejszone kółka po bokach z alpha = 0 dla obrazków pokemonów

//        let pageWidth = Float(255)
//        let targetXContentOffset = Float(targetContentOffset.pointee.x)
//        let contentWidth = Float(collectionView.contentSize.width  )
//        var newPage = Float(self.pageControl.currentPage)
//
//        if velocity.x == 0 {
//            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
//        } else {
//            newPage = Float(velocity.x > 0 ? self.pageControl.currentPage + 1 : self.pageControl.currentPage - 1)
//            if newPage < 0 {
//                newPage = 0
//            }
//            if (newPage > contentWidth / pageWidth) {
//                newPage = ceil(contentWidth / pageWidth) - 1.0
//            }
//        }
//        self.pageControl.currentPage = Int(newPage)
//        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
//        targetContentOffset.pointee = point
    
        layout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.pageControl.numberOfPages = pokemons.count
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! PokemonCell
        pokemonLoader.loadImage(index: 1, completion: { image in
            cell.imageView.image = image
        })
        
        let pokemon = pokemons[1]
        
        cell.titleLabel.textColor = pokemon.colorValue
        cell.block.backgroundColor = pokemon.colorValue
        cell.titleLabel.text = pokemon.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

