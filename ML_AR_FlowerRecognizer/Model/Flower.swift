//
//  Flower.swift
//  ML_AR_FlowerRecognizer
//
//  Created by Iryna Zubrytska on 03.07.2022.
//

import Foundation

struct FlowerDescription: Codable {
    private let origin: String
    private let blooming: String
}

struct FlowerMaitenance: Codable {
    private let soil: String
    private let sunlight: String
    private let watering: String
}

struct Flower: Codable {
    private let name: String
    private let description: FlowerDescription
    private let maintenance: FlowerMaitenance
}
