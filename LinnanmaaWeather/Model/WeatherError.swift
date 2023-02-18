//
//  WeatherError.swift
//  LinnanmaaWeather
//
//  Created by Antti Juustila on 16.2.2023.
//

import Foundation

enum WeatherError: Error {
	case httpError(Int)
	case parseError(String)
}

