import UIKit

class DetailView: UIViewController {
    
    //MARK: - Variables
    private var item: (any TableViewRepresentable)? = nil
    private var buttonIsHidden = false
    private var selectedimage = ""
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var showTransformationsButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIImageView!
    
    
    // MARK: - Button actions
    
    // Marca o desmarca un hero como favorito
    private func toggleFavorite() {
        
        Constants.connection.toggleFavorite(for: item as! Hero) { [weak self] result in

            switch (result) {
                
            case .success(()):
                
                // Primero cambiamos el icono al hacer click
                DispatchQueue.main.async { [weak self] in
                    if self?.selectedimage == "heart" {
                        self?.selectedimage = "heart.fill"
                    }
                    else if self?.selectedimage == "heart.fill" {
                        self?.selectedimage = "heart"
                    }
                    
                    self?.favoriteButton.image = UIImage(systemName: self!.selectedimage)
                    
                    // Borramos los heroes a los que acabamos de marcar como favoritos para poder actualizar la lista
                    Constants.itemsList.removeAll()
                    
                    
                    // Recargamos la lista de heroes, esta vez actualizada
                    Constants.connection.getHeroes { result in
                        switch (result) {
                           
                            // Se ha conseguido importar la lista de héroes
                        case let .success(heroes):
                
                            for hero in heroes {
                                // Añadimos un héroe a la lista Constants.itemsList
                                Constants.itemsList.append(hero)
                            }
                            
                            // Notificamos a TableViewController de que puede actualizar la tableView
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: Constants.itemsList)

                            
                        case .failure(_):
                            return
                        }
                    }
                }
                    
            case .failure(_):
                return
            }
        }
        
    }

    // Abre un TableViewController con la lista de transformaciones de un hero
    @IBAction func showTransformations(_ sender: Any) {
        let tableViewController = TableViewController(title: Transformation.transformationsIdentifier, heroSelected: item as! Hero)
        navigationController?.pushViewController(tableViewController, animated: true)
    }
    
    
    // MARK: - Initializers
    
    init(representable: any TableViewRepresentable) {
        super.init(nibName: nil, bundle: nil)
        self.item = representable
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        // Si el item es de tipo Hero, hay que fijarse si tiene o no transformaciones
        if item is Hero {
            
            selectedimage = (item as! Hero).favorite ? "heart.fill" : "heart"
            favoriteButton.image = UIImage(systemName: selectedimage)

            // Número de transformaciones que tiene el héroe
            let numberOfTransformations = Constants.itemsList.filter {
                let isTransformation = $0 is Transformation
                print ("Es tranfor \($0 is Transformation)")
                var heroSelected: Bool = false
                if isTransformation {
                    heroSelected = ($0 as! Transformation).hero?.id == item?.id
                }

                
                return isTransformation && heroSelected
            }.count
            
            // Si no tiene ninguna transformación, escondemos el botón showTransformationButton
            buttonIsHidden = (numberOfTransformations == 0 ? true : false)
            
            favoriteButton.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imagedTapped))
            favoriteButton.addGestureRecognizer(tapGesture)

            favoriteButton.isHidden = false
        }
        else {
            // Si no es de tipo Hero, es Transformation, por lo que tampoco se debería mostrar el botón
            buttonIsHidden = true
            favoriteButton.isHidden = true
        }
            
        showTransformationsButton.isHidden = buttonIsHidden
        
        nameLabel.text = item?.name
        descriptionText.text = item?.description
        
        imageView.setImage(for: URL(string:(item!.photo))!)
        addGradient(to: imageView, firstColor: .white, secondColor: .clear)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Otras funciones
    
    // Añade un degradado a una vista con los colores deseados
    private func addGradient(to view: UIView, firstColor: UIColor, secondColor: UIColor) {
        
        DispatchQueue.main.async {
            let gradient = CAGradientLayer()
            gradient.frame = view.bounds
            gradient.colors = [firstColor.cgColor, secondColor.cgColor]
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 0, y: 0)
            gradient.locations = [0, 0.85]
            
            view.layer.addSublayer(gradient)
        }
    }
    
    // Handler para la UIImageView favoriteButton
    @objc private func imagedTapped(_ gesture: UITapGestureRecognizer) {
        if gesture.view is UIImageView {
           self.toggleFavorite()
       }
    }
    

}

