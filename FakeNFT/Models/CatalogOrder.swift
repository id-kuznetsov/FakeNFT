struct CatalogOrder: Codable, Hashable {
    var nfts: [String]
    let id: String
}

extension CatalogOrder {
    func toDTO() -> OrderDTO? {
        return OrderDTO(
            nfts: self.nfts,
            id: self.id
        )
    }
}
