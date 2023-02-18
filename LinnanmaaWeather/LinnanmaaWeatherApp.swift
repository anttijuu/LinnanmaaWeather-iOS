//
//  LinnanmaaWeatherApp.swift
//  LinnanmaaWeather
//
//  Created by Antti Juustila on 16.2.2023.
//

import SwiftUI

@main
struct LinnanmaaWeatherApp: App {

	@ObservedObject var weather = WeatherModel()

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(weather)
		}
	}
}
