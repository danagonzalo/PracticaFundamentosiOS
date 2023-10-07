import Foundation
import UIKit

struct Constants {
    
    // MARK: - Connection
    static let connection = NetworkModel()
    
    
    // MARK: - Lista con heroes y transformaciones
    static var itemsList = [TableViewRepresentable]()
    
    // Importa todas las transformaciones de un héroe dado a la lista Constants.itemsList
    static func loadTransformations(for hero: Hero) {
        
        connection.getTransformations(for: hero) { result in
            switch result {
                
            case let .success(transformations): // Se ha conseguido importar la lista de héroes
                
                for transformation in transformations {
                    // Añadimos cada transformación a la lista Constants.itemsList
                    itemsList.append(transformation)
                }
                
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}

