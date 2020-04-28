import Foundation
import UIKit

protocol PokemonLoader {
	/// Load all Pokemon
	/// - Parameter completion: closure called after request finishes
	func load(completion: @escaping ([Pokemon]?) -> Void)


	/// Load data for one specific Pokemon
	/// - Parameters:
	///   - index: Pokemon index
	///   - completion: closure called after request finishes
	func load(index: Int, completion: @escaping (Pokemon?) -> Void)


	/// Load image for one specific Pokemon
	/// - Parameters:
	///   - index: Pokemon index
	///   - completion: closure called after request finishes
	func loadImage(index: Int, completion: @escaping (UIImage?) -> Void)


	/// Catch specific Pokemon
	/// - Parameters:
	///   - index: Pokemon index
	///   - completion: closure called after request finishes. It contains new Pokemon info
	func catchPokemon(index: Int, completion: @escaping (Pokemon?) -> Void)
}

class PokemonLoaderImpl: PokemonLoader {

	private let urlSession: URLSession
	private let deviceUUID: String

	init(urlSession: URLSession = URLSession.shared, deviceUUID: String = UIDevice.current.identifierForVendor?.uuidString ?? "unknown_identifier") {
		self.urlSession = urlSession
		self.deviceUUID = deviceUUID
	}

	func load(completion: @escaping ([Pokemon]?) -> Void) {

		let url = URL(string: "https://switter.app.daftmobile.com/api/pokemon")!
		let request = createRequest(url: url, method: "GET")

		urlSession.dataTask(with: request) { (data, response, error) in
			var pokemon: [Pokemon]? = nil
			defer {
				DispatchQueue.main.async {
					completion(pokemon)
				}
			}
			guard let data = data else { return }

			pokemon = try! JSONDecoder().decode([Pokemon].self, from: data)
		}.resume()
	}

	func load(index: Int, completion: @escaping (Pokemon?) -> Void) {

		let url = URL(string: "https://switter.app.daftmobile.com/api/pokemon/\(index)")!
		let request = createRequest(url: url, method: "GET")

		urlSession.dataTask(with: request) { (data, response, error) in
			var pokemon: Pokemon? = nil
			defer {
				DispatchQueue.main.async {
					completion(pokemon)
				}
			}
			guard let data = data else { return }

			pokemon = try? JSONDecoder().decode(Pokemon.self, from: data)
		}.resume()
	}

	func loadImage(index: Int, completion: @escaping (UIImage?) -> Void) {
		let url = URL(string: "https://switter.app.daftmobile.com/api/pokemon/\(index)/image")!
		let request = createRequest(url: url, method: "GET")

		urlSession.dataTask(with: request) { (data, response, error) in
			var image: UIImage? = nil
			defer {
				DispatchQueue.main.async {
					completion(image)
				}
			}
			guard let data = data else { return }
			image = UIImage(data: data)


		}.resume()
	}

	func catchPokemon(index: Int, completion: @escaping (Pokemon?) -> Void) {
		let url = URL(string: "https://switter.app.daftmobile.com/api/pokemon/\(index)/catch")!
		let request = createRequest(url: url, method: "POST")

		urlSession.dataTask(with: request) { (data, response, error) in
			var pokemon: Pokemon? = nil
			defer {
				DispatchQueue.main.async {
					completion(pokemon)
				}
			}
			guard let data = data else { return }

			pokemon = try? JSONDecoder().decode(Pokemon.self, from: data)


		}.resume()
	}

	private func createRequest(url: URL, method: String?) -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = method
		request.addValue(deviceUUID, forHTTPHeaderField: "x-device-uuid")
		return request
	}
}
