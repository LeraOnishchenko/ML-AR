//
//  FlowerPredictionInfo.swift
//  ML_AR_FlowerRecognizer
//
//  Created by Iryna Zubrytska on 11.07.2022.
//

import Foundation

struct FlowerPredictionInfo {
    let flower: Flower
    let prediction: Prediction

    var name: String { prediction.0 }

    var probability: String { "\(prediction.1 * 100) %" }

    var origin: String {
        "🏠 \(flower.description.origin)"
    }

    var blooming: String {
        "🌸 \(flower.description.blooming)"
    }

    var sunlight: String {
        "☀️ \(flower.maintenance.sunlight)"
    }

    var watering: String {
        "💧 \(flower.maintenance.watering)"
    }

    var soil: String {
        "🌿 \(flower.maintenance.soil)"
    }

    var allInfo: String {
        """
        \(prediction.0) - \(prediction.1 * 100) %
        🏠 \(flower.description.origin)
        🌸 \(flower.description.blooming)
        ☀️ \(flower.maintenance.sunlight)
        💧 \(flower.maintenance.watering)
        🌿 \(flower.maintenance.soil)
        """
    }
}
