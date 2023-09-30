import Foundation
import UIKit

struct Constants {
    
    // MARK: - Connection
    static let connection = NetworkModel()
    
    static let URLComponentsScheme = "https"
    static let URLComponentsHost = "dragonball.keepcoding.education"
    static let httpMethod = "POST"
    static let httpHeaderField = "Authorization"
    
    static let loginPath = "/api/auth/login"
    static let heroesPath = "/api/heros/all"
    static let transformationsPath = "/api/heros/tranformations"
    static let favoritesPath = "/api/data/herolike"

    static let codeSuccess = 200

    
    // MARK: - UserDefaults
    static let userDefaults = UserDefaults.standard
    
    
    // MARK: - Identifiers
    static let heroesIdentifier = "Heroes"
    static let transformationsIdentifier = "Transformaciones"
    static let tableViewCelldentifier = "TableViewCell"
    
    
    // MARK: - Errors
    static let errorNoImage = "No image found"
    static let errorInitCoderNotImplemented = "init(coder:) has not been implemented"
    
    
    // MARK: - Lista con heroes y transformaciones
    static var itemsList = [AnyHashable : Bool]()

    
    // MARK: - Beautify functions
    static func addShadow(to view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5.0, height : 5.0)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 5
    }
    
    static func addBlurEffect(to imageView: UIImageView, style: UIBlurEffect.Style) {
        let blur = UIBlurEffect(style: style)
        let blurEffect = UIVisualEffectView(effect: blur)
        blurEffect.frame = imageView.bounds
        imageView.addSubview(blurEffect)
    }
}

