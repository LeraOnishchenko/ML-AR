//
//  Flower.swift
//  ML_AR_FlowerRecognizer
//
//  Created by Iryna Zubrytska on 03.07.2022.
//

import Foundation

struct FlowerDescription: Codable {
    let origin: String
    let blooming: String
}

struct FlowerMaitenance: Codable {
    let soil: String
    let sunlight: String
    let watering: String
}

struct Flower: Codable {
    let name: String
    let description: FlowerDescription
    let maintenance: FlowerMaitenance
}
