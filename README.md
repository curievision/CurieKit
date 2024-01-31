# CurieKit

## Summary

CurieKit is a Swift package that provides an easy-to-use interface for retrieving CurieProduct objects from a remote API. It implements the ProductAPIService protocol, offering async methods to fetch products using their unique identifiers. The service handles various operations, such as generating signed URLs, managing local storage of product assets, and error handling.

## Installation

To integrate CurieKit into your Swift project, you can use Swift Package Manager (SPM). Add the following dependency to your Package.swift:

## Installation

To integrate CurieKit into your Swift project, you can use Swift Package Manager (SPM). Add the following dependency to your Package.swift:

`
dependencies: [
    .package(url: "https://github.com/your-username/CurieKit.git", .upToNextMajor(from: "1.0.0"))
]
`

Remember to replace your-username with your actual GitHub username and adjust the version number as needed.

## Usage

To use CurieKit in your project, you need to initialize it with your API key and optionally, a custom URLSession. Here's a basic setup and how to fetch a product:

```swift
import Foundation
import CurieKit

// Initialize CurieKit
let apiKey = "your_api_key"
let curieKit = CurieKit(with: apiKey)

// Usage example
func fetchProduct() {
    Task {
        do {
            if let product = try await curieKit.getProduct(with: "product_id") {
                // Handle the fetched product
                print("Product: \(product)")
            }
        } catch {
            print("Error fetching product: \(error)")
        }
    }
}

fetchProduct()
```

Replace `your_api_key` and `product_id` with your actual API key and a valid product ID.
