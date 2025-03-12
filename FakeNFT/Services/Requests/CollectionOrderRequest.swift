import Foundation

struct CollectionOrderRequest: NetworkRequest {
    var order: CatalogOrder?

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod {
        return order == nil ? .get : .put
    }

    var dto: Dto? {
        guard
            let order,
            let orderDTO = order.toDTO()
        else {
            return nil
        }

        return UpdateCollectionOrderDto(order: orderDTO)
    }
}

struct UpdateCollectionOrderDto: Dto {
    let order: CatalogOrderDTO

    enum CodingKeys: String, CodingKey {
        case nfts
    }

    func asDictionary() -> [String: String] {
        [
            CodingKeys.nfts.rawValue: order.nfts.joined(separator: ",")
        ]
    }
}
