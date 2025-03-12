struct OrderDTO: Decodable {
    let nfts: [String]
    let id: String
}

extension OrderDTO {
    func toDomainModel() -> CatalogOrder {

        return CatalogOrder(
            nfts: self.nfts,
            id: self.id
        )
    }
}
