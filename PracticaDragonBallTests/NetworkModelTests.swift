import XCTest
@testable import PracticaDragonBall

enum ErrorMock: Error {
  case mockCase
}

class NetworkModelTests: XCTestCase {
  
  private var urlSessionMock: URLSessionMock!
  private var sut: NetworkModel!
  
  override func setUpWithError() throws {
    urlSessionMock = URLSessionMock()
    
    sut = NetworkModel(urlSession: urlSessionMock)
  }
  
  override func tearDownWithError() throws {
    sut = nil
  }
  
  func testLoginFailWithNoData() {
    var error: NetworkError?
    
    urlSessionMock.data = nil
    
    sut.login(user: "", password: "") { _, networkError in
      error = networkError
    }
    
    XCTAssertEqual(error, .noData)
  }
  
  func testLoginFailWithError() {
    var error: NetworkError?
    
    urlSessionMock.data = nil
    urlSessionMock.error = ErrorMock.mockCase
    
    sut.login(user: "", password: "") { _, networkError in
      error = networkError
    }
    
    XCTAssertEqual(error, .other)
  }
  
  func testLoginFailWithErrorCodeNil() {
    var error: NetworkError?
    
    urlSessionMock.data = "TokenString".data(using: .utf8)!
    urlSessionMock.response = nil
    
    sut.login(user: "", password: "") { _, networkError in
      error = networkError
    }
    
    XCTAssertEqual(error, .errorCode(nil))
  }
  
  func testLoginFailWithErrorCode() {
    var error: NetworkError?
    
    urlSessionMock.data = "TokenString".data(using: .utf8)!
    urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 404, httpVersion: nil, headerFields: nil)
    
    sut.login(user: "", password: "") { _, networkError in
      error = networkError
    }
    
    XCTAssertEqual(error, .errorCode(404))
  }
  
  func testLoginSuccessWithMockToken() {
    var error: NetworkError?
    var retrievedToken: String?
    
    urlSessionMock.error = nil
    urlSessionMock.data = "TokenString".data(using: .utf8)!
    urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    sut.login(user: "", password: "") { token, networkError in
      retrievedToken = token
      error = networkError
    }

    XCTAssertEqual(retrievedToken, "TokenString", "Se debe haber recibido un Token")
    XCTAssertNil(error, "No deberia haber un error")
  }
  
  func testGetHerosSuccess() {
    var error: NetworkError?
    var retrievedHeroes: [Hero]?
    
    sut.token = "testToken"
    urlSessionMock.data = getHeroesData(resourceName: "heroes")
    urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    sut.getHeroes { heroes, networkError in
      error = networkError
      retrievedHeroes = heroes
    }
    
    XCTAssertEqual(retrievedHeroes?.first?.id, "Hero ID", "Debe ser el mismo Heroe que el de el JSON")
    XCTAssertNil(error, "No deberia haber un error")
  }
  
  func testGetHerosSuccessWithNoHeroes() {
    var error: NetworkError?
    var retrievedHeroes: [Hero]?
    
    sut.token = "testToken"
    urlSessionMock.data = getHeroesData(resourceName: "noHeroes")
    urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    sut.getHeroes { heroes, networkError in
      error = networkError
      retrievedHeroes = heroes
    }
    
    XCTAssertNotNil(retrievedHeroes)
    XCTAssertEqual(retrievedHeroes?.count, 0)
    XCTAssertNil(error, "No deberia haber un error")
  }
    
  func testGetTransformationsSuccess() {
    var error: NetworkError?
    var retrievedTransformations: [Transformations]?
      
    sut.token = "testToken"
    urlSessionMock.data = getTransformationsData(resourceName: "transformations")
    urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)

    sut.getTransformations { transformations, networkError in
      error = networkError
      retrievedTransformations = transformations
    }
      
    XCTAssertEqual(retrievedTransformations?.first?.id, "Transformation ID", "Debe ser el mismo id que el del JSON")
    XCTAssertNil(error, "No deberia haber un error")
  }
    
  func testGetTransformationsSuccessWithNoTransformations() {
    var error: NetworkError?
    var retrievedTransformations: [Transformations]?
    
    sut.token = "testToken"
    urlSessionMock.data = getTransformationsData(resourceName: "noTransformations")
    urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    sut.getTransformations { transformations, networkError in
      error = networkError
      retrievedTransformations = transformations
    }
    
    XCTAssertNotNil(retrievedTransformations)
    XCTAssertEqual(retrievedTransformations?.count, 0)
    XCTAssertNil(error, "No deberia haber un error")
  }
}
    

extension NetworkModelTests {
  func getHeroesData(resourceName: String) -> Data? {
    let bundle = Bundle(for: NetworkModelTests.self)
      
    guard let path = bundle.path(forResource: resourceName, ofType: "json") else {return nil}
    
    return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
  }
    
  func getTransformationsData(resourceName: String) -> Data? {
    let bundle = Bundle(for: NetworkModelTests.self)
      
    guard let path = bundle.path(forResource: resourceName, ofType: "json") else {return nil}
      
    return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
  }
}
