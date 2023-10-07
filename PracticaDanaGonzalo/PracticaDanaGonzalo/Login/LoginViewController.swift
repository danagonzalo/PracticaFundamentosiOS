import UIKit


class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var waitingLabel: UILabel!

    
    // MARK: - Continuar
    @IBAction func login(_ sender: Any) {
        // Intentamos conectarnos con nuestras credenciales

        Constants.connection.login(user: userTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] result in
            switch result {
                
            // El usuario y la contraseña son correctos
            case .success(_):

                // Importamos datos de la API
                self?.loadData()
                
                // Mostrando mensaje "Cargando datos..."
                DispatchQueue.main.async { [weak self] in
                    self?.view.endEditing(true)
                    self?.stackView.isHidden = true
                    self?.waitingLabel.isHidden = false
                }
            
            case let .failure(error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waitingLabel.isHidden = true
        stackView.isHidden = false
    }
    

    // Carga la lista de héroes y sus transformaciones
    private func loadData() {
        
        Constants.connection.getHeroes { [weak self] result in
        
            switch result {
                
            case let .success(heroes): // Se ha conseguido importar la lista de héroes
                
                
                
                // Una vez finalizada la carga de datos, procedemos a entrar en la aplicación
                for hero in heroes {
                    // Añadimos un héroe a la lista Constants.itemsList
                    print(hero.name)
                    Constants.itemsList.append(hero)
                    
                    // Buscamos las transformaciones para el héroe
                    Constants.loadTransformations(for: hero)
                }
                
                // Pasamos a la lista de heroes
                DispatchQueue.main.async { [weak self] in
                    let tableViewController = TableViewController(title: Hero.heroesIdentifier)
                    tableViewController.view.isHidden = false
                
                // MARK: - Por algún motivo, setViewControllers NO funciona...
                  self?.navigationController?.setViewControllers([tableViewController], animated: true)
                }
                
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    

}
