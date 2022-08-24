//
//  LocalDataModelTests.swift
//  PracticaDragonBallTests
//
//  Created by Rodrigo Latorre on 11/08/22.
//

import XCTest
@testable import PracticaDragonBall

class LocalDataModelTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testSaveToken() throws {
        let storedToken: String = "TestToken"
        
        LocalDataModel.save(token: storedToken)
        
        let retrievedToken = LocalDataModel.getToken()
        
        XCTAssertEqual(retrievedToken, storedToken, "No hay un toquen guardado")
    }
    
    func testGetTokenWhenNoTokenSaved() throws {
      let retrievedToken = LocalDataModel.getToken()
      XCTAssertNil(retrievedToken, "No hay un toquen guardado")
    }
    
    func testDeleteToken() throws {
      
      let storedToken = "TestToken"
      LocalDataModel.save(token: storedToken)
      
      LocalDataModel.deleteToken()

      let retrievedToken = LocalDataModel.getToken()
      XCTAssertNil(retrievedToken, "No hay un toquen guardado")
    }

}
