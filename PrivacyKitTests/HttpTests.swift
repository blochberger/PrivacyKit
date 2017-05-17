//
//  HttpTests.swift
//  PrivacyKit
//
//  Created by Maximilian Blochberger on 2017-04-04.
//  Copyright © 2017 Universität Hamburg. All rights reserved.
//

import XCTest
@testable import PrivacyKit

class HttpTests: XCTestCase {
    
	func testHeadRequest() {
		let optionalRequest = Request(withMethod: .head, andUrl: URL(string: "https://example.com/")!, andHeaders: ["X-Test": "foobar", "X-Foo": "Bar"])

		XCTAssertNotNil(optionalRequest, "Failed to create request")
		let actualRequest = optionalRequest!

		let actual = String(data: actualRequest.compose()!, encoding: .utf8)!
		let expected = "HEAD / HTTP/1.1\r\nX-Test: foobar\r\nHost: example.com\r\nX-Foo: Bar\r\n\r\n"

		XCTAssertEqual(actual, expected)
	}

	func testConnectRequest() {
		let optionalRequest = Request.connect(
			toHost: "example.com",
			withPort: 80,
			viaProxy: URL(string: "https://localhost:8888")!,
			withHeaders: ["X-Test": "foobar", "X-Foo": "Bar"]
		)

		XCTAssertNotNil(optionalRequest, "Failed to create request")
		let actualRequest = optionalRequest!

		let actual = String(data: actualRequest.compose()!, encoding: .utf8)!
		let expected = "CONNECT example.com:80 HTTP/1.1\r\nX-Test: foobar\r\nHost: localhost\r\nX-Foo: Bar\r\n\r\n"

		XCTAssertEqual(actual, expected)
	}

	func testPServiceUploadResponse() {
		let rawResponse = "HTTP/1.0 200 OK\r\nServer: BaseHTTP/0.6 Python/3.6.0\r\nDate: Wed, 25 Jan 2017 13:00:00 GMT\r\n\r\n".data(using: .utf8)!

		let expectedHeaders: Headers = [
			"Server": "BaseHTTP/0.6 Python/3.6.0",
			"Date": "Wed, 25 Jan 2017 13:00:00 GMT",
		]


		let optionalResponse = Response(withRawData: rawResponse)

		XCTAssertNotNil(optionalResponse, "Failed to parse response.")
		let actualResponse = optionalResponse!

		XCTAssertEqual(actualResponse.status, .ok)
		XCTAssertEqual(actualResponse.headers, expectedHeaders)
		XCTAssertEqual(actualResponse.body, Data())
	}

	func testConnectResponse() {
		let rawResponse = "HTTP/1.0 200 Connection Established\r\nProxy-agent: Apache\r\n\r\n".data(using: .utf8)!

		let optionalResponse = Response(withRawData: rawResponse)

		XCTAssertNotNil(optionalResponse, "Failed to parse response.")
		let actualResponse = optionalResponse!

		XCTAssertEqual(actualResponse.status, .ok)
		XCTAssertEqual(actualResponse.headers, ["Proxy-agent": "Apache"])
		XCTAssertEqual(actualResponse.body, Data())
	}

    
}