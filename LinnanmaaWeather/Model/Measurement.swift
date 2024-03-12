//
//  Measurement.swift
//  LinnanmaaWeather
//
//  Created by Antti Juustila on 16.2.2023.
//

import Foundation

struct Measurement: Identifiable {
	var id: String {
		name
	}
	let name: String
	let value: Double
	let unit: String
}

extension Measurement {
	var formatted: String {
		String.localizedStringWithFormat("%.1lf%@", value, unit)
	}
}
