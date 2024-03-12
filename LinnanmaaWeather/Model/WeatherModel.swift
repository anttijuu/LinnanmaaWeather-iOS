//
//  WeatherModel.swift
//  LinnanmaaWeather
//
//  Created by Antti Juustila on 16.2.2023.
//

import Foundation
import os.log

@Observable
final class WeatherModel {

	var timeStamp: String = ""
	var status: String = ""
	var measurements = [Measurement]()

	@MainActor
	func getWeather() async {
		do {
			let url = URL(string: "https://weather.willab.fi/weather.json")!
			if let data = try await LinnanmaaWeather.getWeather(from: url) {
				let weather = try parseWeather(from: data)
				updateMeasurements(from: weather)
				status = NSLocalizedString("Weather updated", comment: "Successfully updated the weather data")
			}
		} catch WeatherError.httpError(let code) {
			logger.error("HTTP error with code \(code)")
			status = String(format: NSLocalizedString("Failed to update weather (HTTP error %d)", comment: "Network error prevented updating weather"), code)
		} catch WeatherError.parseError(let msg) {
			logger.error("Error parsing JSON: \(msg)")
			status = String(format: NSLocalizedString("Data from server was malformed: %@", comment: "Server content was malformed"), msg)
		} catch {
			logger.error("Unexpected error \(error.localizedDescription)")
			status = String(format: NSLocalizedString("Unexpected error %@", comment: "Something went wrong."), error.localizedDescription)
		}
	}

	private func parseWeather(from data: Data) throws -> Weather {
		logger.debug("Got \(data.count) bytes of data")
		do {
			let weather = try JSONDecoder().decode(Weather.self, from: data)
			return weather
		} catch {
			throw WeatherError.parseError(error.localizedDescription)
		}
	}

	private func updateMeasurements(from weather: Weather) {
		logger.debug("Updating the measurements from data")
		measurements.removeAll()
		measurements.append(Measurement(name: NSLocalizedString("Temperature", comment: ""), value: weather.tempnow, unit: " °C"))
		measurements.append(Measurement(name: NSLocalizedString("Feels like", comment: ""), value: weather.windchill, unit: " °C"))
		measurements.append(Measurement(name: NSLocalizedString("Lowest temp", comment: ""), value: weather.templo, unit: " °C"))
		measurements.append(Measurement(name: NSLocalizedString("Highest temp", comment: ""), value: weather.temphi, unit: " °C"))
		measurements.append(Measurement(name: NSLocalizedString("Air pressure", comment: ""), value: weather.airpressure, unit: " hPa"))
		measurements.append(Measurement(name: NSLocalizedString("Humidity", comment: ""), value: Double(weather.humidity), unit: "%"))
		measurements.append(Measurement(name: NSLocalizedString("Wind speed", comment: ""), value: weather.windspeed, unit: " m/s"))
		measurements.append(Measurement(name: NSLocalizedString("Wind direction", comment: ""), value: Double(weather.winddir), unit: "°"))
		timeStamp = weather.timestamp
	}

	private let logger = Logger(subsystem: "com.anttijuustila.linnanmaaweather", category: "weathermodel")
}

func getWeather(from url: URL) async throws -> Data? {
	var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
	request.httpMethod = "GET"
	let (data, response) = try await URLSession.shared.data(for: request)
	if let httpResponse = response as? HTTPURLResponse {
		if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
			return data
		} else {
			throw WeatherError.httpError(httpResponse.statusCode)
		}
	}
	return nil
}
