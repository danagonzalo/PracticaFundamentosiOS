import Foundation

final class NetworkModel {
    enum NetworkError: Error {
        case unknown
        case malformedUrl
        case decodingFailed
        case encodingFailed
        case noData
        case statusCode(code: Int?)
        case noToken
    }
    
    private var baseComponents: URLComponents {
        var components = URLComponents()
        components.scheme = Constants.URLComponentsScheme
        components.host = Constants.URLComponentsHost
        return components
    }
    
    private var token: String? {
        get {
            if let token = LocalDataModel.getToken() { return token }
            return nil
        }
        set {
            if let token = newValue { LocalDataModel.save(token: token) }
        }
    }
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
        
    func login(user: String, password: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        
        var components = baseComponents
        components.path = Constants.loginPath
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        let loginString = String(format: "%@:%@", user, password)
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(.decodingFailed))
            return
        }
        
        let base64LoginString = loginData.base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.httpMethod
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: Constants.httpHeaderField)
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            let urlResponse = response as? HTTPURLResponse
            let statusCode = urlResponse?.statusCode
            
            guard statusCode == 200 else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            guard let token = String(data: data, encoding: .utf8) else {
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(token))
            self?.token = token
        }
        
        task.resume()
    }
    
    // Importa la lista de heroes
    func getHeroes(
        completion: @escaping (Result<[Hero], NetworkError>) -> Void
    ) {
        var components = baseComponents
        components.path = Constants.heroesPath
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        guard let token else {
            completion(.failure(.noToken))
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "name", value: "")]
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.httpMethod
        request.httpBody = urlComponents.query?.data(using: .utf8)
        request.setValue("Bearer \(token)", forHTTPHeaderField: Constants.httpHeaderField)
        createTask(
            for: request,
            using: [Hero].self,
            completion: completion
        )
    }
    
    // Importa la lista de transformaciones de un heroe concreto
    func getTransformations(for hero: Hero, completion: @escaping (Result<[Transformation], NetworkError>) -> Void) {
        
        var components = baseComponents
        components.path = Constants.transformationsPath
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        guard let token else {
            completion(.failure(.noToken))
            return
        }
        

        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "id", value: hero.id)]
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.httpMethod
        request.setValue("Bearer \(token)", forHTTPHeaderField: Constants.httpHeaderField)
        request.httpBody = urlComponents.query?.data(using: .utf8)
        
        createTask(for: request, using: [Transformation].self, completion: completion)
    }
    
    func createTask<T: Decodable>(for request: URLRequest, using type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            let result: Result<T, NetworkError>
            
            defer {
                completion(result)
            }
            
            guard error == nil else {
                result = .failure(.unknown)
                return
            }
            
            guard let data else {
                result = .failure(.noData)
                return
            }
            
            guard let resource = try? JSONDecoder().decode(type, from: data) else {
                result = .failure(.decodingFailed)
                return
            }
            
            result = .success(resource)
        }
        
        task.resume()
    }
    
    
    // MARK: Marca o desmarca un hero como favorito
    func toggleFavorite(for hero: Hero, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        
        var components = baseComponents
        components.path = Constants.favoritesPath
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        guard let token else {
            completion(.failure(.noToken))
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "hero", value: hero.id)]
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.httpMethod
        request.setValue("Bearer \(token)", forHTTPHeaderField: Constants.httpHeaderField)
        request.httpBody = urlComponents.query?.data(using: .utf8)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            var result: Result<Void, NetworkError>
            
            defer {
                completion(result)
            }
            
            guard error == nil else {
                result = .failure(.unknown)
                return
            }
            
            guard data != nil else {
                result = .failure(.noData)
                return
            }
            
            result = .success(())
        }
        
        task.resume()
    }
}
