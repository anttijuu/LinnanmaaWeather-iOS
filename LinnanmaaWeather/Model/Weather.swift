//
//  Weather.swift
//  LinnanmaaWeather
//
//  Created by Antti Juustila on 16.2.2023.
//

import Foundation

/*
 {
 "tempnow": -1.2,
 "templo": -3.5,
 "temphi": 3.4,
 "airpressure": 1005.2,
 "humidity": 80.2,
 "precipitation1h": 0.0,
 "precipitation1d": 0.0,
 "precipitation1w": 0.0,
 "solarrad": -1,
 "windspeed": 0.8,
 "windspeedmax": 1.7,
 "winddir": 165,
 "timestamp": "2023-10-09 07:50:15 UTC",
 "windchill": -1.7,
 "dewpoint": -4.2
 } */
struct Weather: Codable {
	let tempnow: Double
	let templo: Double
	let temphi: Double
	let airpressure: Double
	let humidity: Double
	let precipitation1h: Int
	let precipitation1d: Int
	let precipitation1w: Int
	let solarrad: Int
	let windspeed: Double
	let windspeedmax: Double
	let winddir: Int
	let timestamp: String
	let windchill: Double
	let dewpoint: Double
}
