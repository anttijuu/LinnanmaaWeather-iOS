//
//  ContentView.swift
//  LinnanmaaWeather
//
//  Created by Antti Juustila on 16.2.2023.
//

import SwiftUI

struct ContentView: View {

	@EnvironmentObject var weather: WeatherModel

	var body: some View {
		ScrollView {
			ZStack {
				Image("Linnanmaa")
					.resizable()
					.aspectRatio(contentMode: .fill)
					.opacity(0.7)
				Text("Weather in Linnanmaa")
					.font(.title)
					.padding(3)
					.overlay {
						RoundedRectangle(cornerSize: CGSize(width: 6.0, height: 6.0), style: .continuous)
							.opacity(0.2)
							.foregroundColor(.white)
					}
			}
			VStack(spacing: 8) {
				Text("Weather at \(weather.timeStamp)")
					.font(.caption)
				ForEach(weather.measurements) { measurement in
					HStack {
						Text(measurement.name)
						Spacer()
						Text(measurement.valueFormatted)
					}
				}
			}
		}
		.padding()
		.task {
			await weather.getWeather()
		}
		Spacer()
		VStack(spacing: 8) {
			Text("\(weather.status) \(Date.now.formatted(date: .abbreviated, time: .standard))")
				.font(.caption)
				.foregroundColor(.secondary)
			Button(action: {
				Task {
					await weather.getWeather()
				}
			}, label: {
				Text("Refresh")
			})
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
