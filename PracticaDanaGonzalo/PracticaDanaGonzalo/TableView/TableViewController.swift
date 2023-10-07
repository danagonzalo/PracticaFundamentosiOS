
import UIKit
import Foundation

class TableViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var logOutLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Variables
    private var itemsList = [TableViewRepresentable]()
    private var heroSelected: Hero?

    
    // MARK: - Initializers
     init(title: String) {
         super.init(nibName: nil, bundle: nil)
         self.title = title
    }
    
    
    init(title: String, heroSelected: Hero) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.heroSelected = heroSelected
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadList),
            name: NSNotification.Name(rawValue: "load"),
            object: nil
        )

        
        logOutLabel.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: TableViewCell.identifier, bundle: nil), 
                           forCellReuseIdentifier: TableViewCell.identifier)
        
        // Si queremos mostrar la lista de heroes (donde value = true)
        if title == Hero.heroesIdentifier {
            
            // Activamos el botón para cerrar sesión
            let logOutButton = UIBarButtonItem(
                title: "Cerrar Sesión",
                style: .plain,
                target: self,
                action: #selector(logoutButtonTapped)
            )
            
            // Añadimos el botón a la barra superior
            navigationItem.leftBarButtonItem = logOutButton

            // Cargamos la lista de la tableView solo con heroes
            itemsList = Constants.itemsList.filter({$0 is Hero})

            // Ordenamos los heroes alfabeticamente
            itemsList.sort(by: {
                ($0 as! Hero).name < ($1 as! Hero).name
            })
        }
        
        // En cambio, si queremos ver la listqa de transformaciones de un hero...
        else if title == Transformation.transformationsIdentifier {
            
            // Buscamos solo las transformaciones, es decir, donde value = false
            itemsList = Constants.itemsList.filter {
                let isTransformation = $0 is Transformation
                var heroSelectedInList: Bool = false
                if isTransformation {
                    heroSelectedInList = ($0 as! Transformation).hero?.id == heroSelected?.id
                }
                return isTransformation && heroSelectedInList
            }
            
            // Ordenamos las transformaciones por su número
            itemsList.sort(by: {
                let item1 = Int($0.name.split(separator: ".")[0])
                let item2 =  Int($1.name.split(separator: ".")[0])
                
                return item1 ?? 0 < item2 ?? 0
            })
        }
    }
}


// MARK: - TableViewController Datasource
extension TableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        let item = itemsList[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
}


// MARK: - TableViewController Delegate
extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = DetailView(representable: itemsList[indexPath.row] as! (any TableViewRepresentable))
        
        navigationController?.pushViewController(detailViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

// MARK: - Otras funciones
extension TableViewController {
    
    // Devuelve el ancho de la cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // Qué hacer cuando hacemos click en "Cerrar Sesión"
    @objc func logoutButtonTapped(_ sender: Any) {
        
        // Accedemos al SceneDelegate
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            
            // Simulamos cerrar sesión...
            tableView.isHidden = true
            logOutLabel.isHidden = false
            
            // Hacemos un delay de 0.5sec para simular que cerramos sesión
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let navigationController = UINavigationController(rootViewController: LoginViewController())
                
                sceneDelegate.window?.rootViewController = navigationController
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    // Actualizar la lista de héroes
    @objc func loadList(notification: NSNotification){
        
        itemsList = notification.object as! [TableViewRepresentable]
        
        //Ordenamos los heroes por nombre
        itemsList.sort(by: {
            $0.name < $1.name
        })
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}



