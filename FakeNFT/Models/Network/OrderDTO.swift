struct OrderDTO: Decodable {
    let nfts: [String]
    let id: String
}

extension OrderDTO {
    func toDomainModel() -> Order {

        return Order(
            nfts: self.nfts,
            id: self.id
        )
    }
}
