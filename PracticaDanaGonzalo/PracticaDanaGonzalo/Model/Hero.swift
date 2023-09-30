import Foundation

struct Hero: Decodable, Hashable, TableViewRepresentable {
    let id: String
    let name: String
    let description: String
    let photo: String
    let favorite: Bool

}
