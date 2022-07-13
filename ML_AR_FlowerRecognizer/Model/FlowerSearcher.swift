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
        let urlString = NSURLComponents()
                urlString.scheme = "https"
                urlString.host = "raw.githubusercontent.com"
                urlString.path = "/irazubrytska/FlowerRepo/main/\(name).json"

        guard let url = urlString.url else {
            print("ERROR - invalid url")
            return nil
        }

        let data = try? Data(contentsOf: url)
        guard let data = data,
              let flower = try? JSONDecoder().decode(Flower.self, from: data) else {
            print("CANNOT decode flower with name \(name)")
            return nil
        }
        return flower
    }
}
