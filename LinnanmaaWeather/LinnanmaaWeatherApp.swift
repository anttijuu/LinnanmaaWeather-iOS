//
//  LinnanmaaWeatherApp.swift
//  LinnanmaaWeather
//
//  Created by Antti Juustila on 16.2.2023.
//

import SwiftUI

@main
struct LinnanmaaWeatherApp: App {

	@State var weather = WeatherModel()

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environment(weather)
		}
	}
}
