import XCTest

@testable import PracticaDanaGonzalo

final class NetworkModelTests: XCTestCase {
    private var sut: NetworkModel!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        sut = NetworkModel(session: session)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: Test
    func testToggleFavorite() {
        let someUser = "SomeUser"
        let somePassword = "SomePassword"
        let someHero = Hero(id: "", name: "", description: "", photo: "", favorite: false)
        
        
        MockURLProtocol.requestHandler = { request in
            let loginString = String(format: "%@:%@", someUser, somePassword)
            let loginData = loginString.data(using: .utf8)!
            
            XCTAssertEqual(request.httpMethod, Constants.httpMethod)
            XCTAssertEqual(
                request.value(forHTTPHeaderField: Constants.httpHeaderField),
                "Bearer " + LocalDataModel.getToken()!)
            
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: Constants.URLComponentsHost)!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"]
                )
            )
            return (response)
        }
        
        let expectation = expectation(description: "Success")
        
        sut.toggleFavorite(for: someHero){ result in
            guard case .success(_) = result else {
                XCTFail("Expected success but received \(result)")
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 300)
    }
}

// OHHTTPStubs
final class MockURLProtocol: URLProtocol {
    static var error: NetworkModel.NetworkError?
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        guard let handler = MockURLProtocol.requestHandler else {
            assertionFailure("Received unexpected request with no handler")
            return
        }
        
        do {
            let (response) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() { }
}

