struct CatalogOrder: Codable, Hashable {
    var nfts: [String]
    let id: String
}

extension CatalogOrder {
    func toDTO() -> CatalogOrderDTO? {
        return CatalogOrderDTO(
            nfts: self.nfts,
            id: self.id
        )
    }
}
