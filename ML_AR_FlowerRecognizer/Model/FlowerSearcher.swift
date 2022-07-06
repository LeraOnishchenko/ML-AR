//
//  FlowerSearcher.swift
//  ML_AR_FlowerRecognizer
//
//  Created by Iryna Zubrytska on 03.07.2022.
//

import Foundation

final class FlowerSearcher {
    @discardableResult
    func findFlowerWith(name: String) -> Flower? {
        var uc = URLComponents()
        uc.scheme = "https"
        uc.host = "raw.githubusercontent.com"
        uc.path = "/irazubrytska/FlowerRepo/main/\(name).json"

        let data = try? Data(contentsOf: URL(string: uc.url!.absoluteString)!)
        guard let data = data,
              let flower = try? JSONDecoder().decode(Flower.self, from: data) else {
            print("CANNOT decode flower with name \(name)")
            return nil
        }
        return flower
    }
}
