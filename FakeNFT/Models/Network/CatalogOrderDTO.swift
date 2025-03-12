struct CatalogOrderDTO: Decodable {
    let nfts: [String]
    let id: String
}

extension CatalogOrderDTO {
    func toDomainModel() -> CatalogOrder {

        return CatalogOrder(
            nfts: self.nfts,
            id: self.id
        )
    }
}
