//
//  File.swift
//  
//
//  Created by Benji Dodgson on 1/30/24.
//

import Foundation

// The protocol conformance for objects wanting to retrieve `CurieProduct`'s
public protocol ProductAPIService {
    func getProduct(with productId: String) async throws -> CurieProduct?
}

/// The service responsible for retrieving Products
public final class CurieProductService: ProductAPIService {

    public enum ServiceError: Error {
        case decodingError
        case invalidResponse
        case invalidURL
        case api(Error)
    }
    
    private let signedURLString = "https://api.curie.io/public/products/signurl?product_id="
    private let headerField = "x-curie-api-key"
    private let session: URLSession
    
    public let apiKey: String
    
    public init(with apiKey: String, session: URLSession = URLSession.shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    // MARK: Public
    
    /// Gets the corresponding `CurieProduct` with a given identifier
    /// - Parameter identifier: The unique identifer of the `CurieProduct`
    /// - Returns: A `CurieProduct` with a matching identifier OR an `ServiceError`
    public func getProduct(with identifier: String) async throws -> CurieProduct? {
        guard let signedURL = try? await getSignedURL(for: identifier) else { return nil }
        return try await getProduct(signedURL, productId: identifier)
    }
    
    // MARK: Private
    
    /// Gets a signed URL using the given api key and `CurieProduct` identifier
    /// - Parameter productId: The unique identifier of the `CurieProduct`
    /// - Returns: A signed URL unique to the product OR a `ServiceError`
    private func getSignedURL(for productId: String) async throws -> URL? {
        
        let urlString = signedURLString + productId
        
        guard let url = URL(string: urlString) else { throw ServiceError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: headerField)

        do {
            let data = try await session.data(for: request).0
            let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let value = dict?["url"] as? String
            let signedURL = URL(string: value ?? "")
            return signedURL
        } catch {
            throw ServiceError.api(error)
        }
    }
    
    /// Gets the `CurieProduct` from the signed URL
    /// - Parameters:
    ///   - signedURL: The URL used to get the `CurieProduct`
    ///   - productId: The unique identifier of the `CurieProduct`
    /// - Returns: A `CurieProduct` with a matching identifier OR an `ServiceError`
    private func getProduct(_ signedURL: URL, productId: String) async throws -> CurieProduct? {
        
        do {
            let url = try await downloadAsset(from: signedURL)
        
            return CurieProduct(id: productId,
                           url: url,
                           name: "",
                           timestamp: Date())
        } catch {
            throw ServiceError.api(error)
        }
    }
    
    /// Retrieves a 3D asset and stores in locally
    /// - Parameter url: The URL address of the desired 3D asset
    /// - Returns: The local URL of the stored 3D asset
    private func downloadAsset(from url: URL) async throws -> URL {

        let (tempLocalUrl, response) = try await session.download(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let savedURL = documentsURL.appendingPathComponent(url.lastPathComponent)

        try FileManager.default.copyItem(at: tempLocalUrl, to: savedURL)
        
        return savedURL
    }
}
