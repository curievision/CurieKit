//
//  CurieKit.swift
//
//
//  Created by Benji Dodgson on 1/30/24.
//

import Foundation

// The protocol conformance for objects wanting to retrieve `CurieProduct`'s
public protocol CurieServiceProtocol {
    func getProduct(with productId: String) async throws -> CurieProduct?
}

/// The service responsible for retrieving Products
public final actor CurieKit: CurieServiceProtocol {

    public enum ServiceError: Error {
        case decodingError
        case invalidResponse
        case invalidURL
        case api(Error)
        case message(String)
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
    
    /// Gets the corresponding `CurieProduct` with a given identifier locally or from the server
    /// - Parameter identifier: The unique identifer of the `CurieProduct`
    /// - Returns: A `CurieProduct` with a matching identifier OR an `ServiceError`
    public func getProduct(with identifier: String) async throws -> CurieProduct? {
        
        if let existingURL = getExistingProductURL(with: identifier) {
            return CurieProduct(id: identifier,
                                url: existingURL,
                                name: "",
                                timestamp: Date())
        }
                
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
    
    /// Curie's local cache directory for already downloaded products.
    private var cacheDirectory: URL {
        return FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appending(path: "Curie", directoryHint: .isDirectory)
    }
    
    /// Returns an existing URL of a `CurrieProduct`'s 3D asset if one exists
    /// - Parameter productId: The unique identifier of the `CurrieProduct`
    /// - Returns: The optional URL of the `CurrieProduct` 3D asset
    private func getExistingProductURL(with identifier: String) -> URL? {
        let existingURL = cacheDirectory.appendingPathComponent("\(identifier).usdz")
        if FileManager.default.fileExists(atPath: existingURL.path) {
            return existingURL
        } else {
            return nil
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

        let savedURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)

        // Check if a file exists at the destination URL and delete it if it does
        if FileManager.default.fileExists(atPath: savedURL.path) {
            try FileManager.default.removeItem(at: savedURL)
        }

        // Create the cache directory when not present
        try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)

        // Move the temporary file from the download to the cache directory
        try FileManager.default.moveItem(at: tempLocalUrl, to: savedURL)

        // Return the URL where the file was saved
        return savedURL
    }
}
