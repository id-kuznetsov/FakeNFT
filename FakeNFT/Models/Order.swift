struct Order: Codable, Hashable {
    var nfts: [String]
    let id: String
}

extension Order {
    func toDTO() -> OrderDTO? {
        return OrderDTO(
            nfts: self.nfts,
            id: self.id
        )
    }
}
