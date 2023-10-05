import Foundation

struct Transformation: Decodable, Hashable, TableViewRepresentable {
    static let transformationsIdentifier = "Transformations"
    let id: String
    let name: String
    let description: String
    let photo: String
    let hero: TransformationHero?
}

struct TransformationHero: Decodable, Hashable {
    let id: String
}


