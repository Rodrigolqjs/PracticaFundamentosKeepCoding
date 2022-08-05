import UIKit

struct Hero: Decodable {
    let id: String
    let name: String
    let description: String
    let photo: URL
    let favorite: Bool
}

struct Transformations: Decodable {
    let id: String
    let photo: URL
    let name: String
    let description: String
}
