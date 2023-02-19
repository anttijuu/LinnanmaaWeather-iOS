//
//  WeatherModel.swift
//  LinnanmaaWeather
//
//  Created by Antti Juustila on 16.2.2023.
//

import Foundation

class WeatherModel: ObservableObject {

	@Published var timeStamp: String = ""
	@Published var status: String = ""
	@Published var measurements = [Measurement]()

	@MainActor
	func getWeather() async {
		do {
			let url = URL(string: "http://weather.willab.fi/weather.json")!
			if let data = try await getWeather(from: url) {
				let weather = try parseWeather(from: data)
				updateMeasurements(from: weather)
				status = NSLocalizedString("Weather updated", comment: "Successfully updated the weather data")
			}
		} catch WeatherError.httpError(let code) {
			status = String(format: NSLocalizedString("Failed to update weather (HTTP error %d)", comment: "Network error prevented updating weather"), code)
		} catch WeatherError.parseError(let msg) {
			status = String(format: NSLocalizedString("Data from server was malformed: %@", comment: "Server content was malformed"), msg)
		} catch {
			status = String(format: NSLocalizedString("Unexpected error %@", comment: "Something went wrong."), error.localizedDescription)
		}
	}

	private func getWeather(from url: URL) async throws -> Data? {
		let (data, response) = try await URLSession.shared.data(from: url)
		if let httpResponse = response as? HTTPURLResponse {
			if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
				return data
			} else {
				throw WeatherError.httpError(httpResponse.statusCode)
			}
		}
		return nil
	}

	private func parseWeather(from data: Data) throws -> Weather {
		do {
			let weather = try JSONDecoder().decode(Weather.self, from: data)
			return weather
		} catch {
			throw WeatherError.parseError(error.localizedDescription)
		}
	}

	private func updateMeasurements(from weather: Weather) {
		measurements.removeAll()
		measurements.append(Measurement(name: NSLocalizedString("Temperature", comment: ""), value: weather.tempnow, unit: " °C"))
		measurements.append(Measurement(name: NSLocalizedString("Humidity", comment: ""), value: Double(weather.humidity), unit: "%"))
		measurements.append(Measurement(name: NSLocalizedString("Air pressure", comment: ""), value: weather.airpressure, unit: " hPa"))
		measurements.append(Measurement(name: NSLocalizedString("Wind direction", comment: ""), value: Double(weather.winddir), unit: "°"))
		measurements.append(Measurement(name: NSLocalizedString("Wind speed", comment: ""), value: weather.windspeed, unit: " m/s"))
		timeStamp = weather.timestamp
	}

}
