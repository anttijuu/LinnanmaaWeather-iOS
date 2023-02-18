//
//  Weather.swift
//  LinnanmaaWeather
//
//  Created by Antti Juustila on 16.2.2023.
//

import Foundation

/*
 {
 "tempnow": -15.1,
 "temphi": -6.4,
 "templo": -15.4,
 "dewpoint": -17.3,
 "humidity": 84,
 "airpressure": 1023.3,
 "windspeed": 1.5,
 "windspeedmax": 4.9,
 "winddir": 56,
 "precipitation1d": 0,
 "precipitation1h": 0,
 "solarrad": 626,
 "windchill": -19,
 "timestamp": "2022-12-12 11:13 EET"
 }
 */
struct Weather: Codable {
	let tempnow: Double
	let temphi: Double
	let templo: Double
	let dewpoint: Double
	let humidity: Int
	let airpressure: Double
	let windspeed: Double
	let windspeedmax: Double
	let winddir: Int
	let precipitation1d: Int
	let precipitation1h: Int
	let solarrad: Int
	let windchill: Int
	let timestamp: String
}
