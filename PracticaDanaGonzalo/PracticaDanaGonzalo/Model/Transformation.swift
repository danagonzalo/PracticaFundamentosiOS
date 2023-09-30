import Foundation

struct Transformation: Decodable, Hashable, TableViewRepresentable {
    let id: String
    let name: String
    let description: String
    let photo: String
    let hero: TransformationHero?
}

struct TransformationHero: Decodable, Hashable {
    let id: String
}


