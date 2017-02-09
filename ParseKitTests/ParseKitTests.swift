//
//  ParseKitTests.swift
//  ParseKitTests
//
//  Copyright (c) 2017 Daniel Byon
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import XCTest
@testable import ParseKit

class ParseKitTests: XCTestCase {

    // MARK: Variables

    let json = NSDictionary(dictionary: [
        // Int
        "validInt": 123,
        "validIntString": "456",
        "invalidInt": [],
        "invalidIntString": "value",
        // String
        "validString": "value",
        "invalidString": 123,
        // Double
        "validDouble": 10.45,
        "validDoubleString": "87.43",
        "invalidDouble": true,
        "invalidDoubleString": "value",
        // Bool
        "validBool": true,
        "validBoolString0": "true",
        "validBoolString1": "false",
        "validBoolString2": "1",
        "validBoolString3": "0",
        "validBoolString4": "yes",
        "validBoolString5": "no",
        "validBoolString6": "TRUE",
        "validBoolString7": "FALSE",
        "validBoolString8": "YES",
        "validBoolString9": "NO",
        "invalidBool": 12.3,
        "invalidBoolString": "value",
        // Date
        "validDate": "2017-02-08T12:15:00-0800",
        "invalidDate": "value",
        "validDateDifferentFormat": "02-08-2017 12:15",
        // Enum
        "validStringEnum": "one",
        "invalidStringEnum": "value",
        "validIntEnum": 1,
        "invalidIntEnum": 3,
        // URL
        "validURL": "https://www.google.com",
        "invalidURL": "",
        // Parsable
        "validParsable": ["value": "Some value"],
        "invalidParsable": ["value": 123],
        // Parsable List
        "validParsableList": [
            ["value": "one"],
            ["value": "two"]
        ],
        "invalidParsableList": [
            ["value": "one"],
            ["value": 123]
        ]
        ])

    let differentDateFormat = "MM-dd-yyyy HH:mm"
    let validDate = Date(timeIntervalSince1970: 1486584900)
    let invalidKeyPath = "someKeyThatDoesNotExist"

    // MARK: Tests

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testValidInt() {
        do {
            let keyPath = "validInt"
            let expected = 123

            let value = try json.parseInt(keyPath)
            XCTAssertEqual(value, expected)

            let general: Int = try json.parse(keyPath)
            XCTAssertEqual(general, expected)

            let optionalValue = try json.parseOptionalInt(keyPath)
            XCTAssertNotNil(optionalValue)
            XCTAssertEqual(optionalValue, expected)

            let optionalGeneral: Int? = try json.parseOptional(keyPath)
            XCTAssertNotNil(optionalGeneral)
            XCTAssertEqual(optionalGeneral, expected)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testValidIntString() {
        let keyPath = "validIntString"
        let expected = 456

        do {
            let value = try json.parseInt(keyPath)
            XCTAssertEqual(value, expected)

            let optionalValue = try json.parseOptionalInt(keyPath)
            XCTAssertNotNil(optionalValue)
            XCTAssertEqual(optionalValue, expected)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testInvalidInt() {
        let keyPath = "invalidInt"
        do {
            let _ = try json.parseInt(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: Int = try json.parse(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _ = try json.parseOptionalInt(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: Int? = try json.parseOptional(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
    }

    func testInvalidIntString() {
        let keyPath = "invalidIntString"
        do {
            let _ = try json.parseInt(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: Int = try json.parse(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _ = try json.parseOptionalInt(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: Int? = try json.parseOptional(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
    }

    func testValidString() {
        let keyPath = "validString"
        let expected = "value"

        do {
            let value = try json.parseString(keyPath)
            XCTAssertEqual(value, expected)

            let general: String = try json.parse(keyPath)
            XCTAssertEqual(general, expected)

            let optionalValue = try json.parseOptionalString(keyPath)
            XCTAssertNotNil(optionalValue)
            XCTAssertEqual(optionalValue, expected)

            let optionalGeneral: String? = try json.parseOptional(keyPath)
            XCTAssertNotNil(optionalGeneral)
            XCTAssertEqual(optionalGeneral, expected)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testInvalidString() {
        let keyPath = "invalidString"
        do {
            let _ = try json.parseString(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: String = try json.parse(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _ = try json.parseOptionalString(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: String? = try json.parseOptional(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
    }

    func testValidDouble() {
        let keyPath = "validDouble"
        let expected = 10.45

        do {
            let value = try json.parseDouble(keyPath)
            XCTAssertEqual(value, expected)

            let general: Double = try json.parse(keyPath)
            XCTAssertEqual(general, expected)

            let optionalValue = try json.parseOptionalDouble(keyPath)
            XCTAssertNotNil(optionalValue)
            XCTAssertEqual(optionalValue, expected)

            let optionalGeneral: Double? = try json.parseOptional(keyPath)
            XCTAssertNotNil(optionalGeneral)
            XCTAssertEqual(optionalGeneral, expected)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testValidDoubleString() {
        let keyPath = "validDoubleString"
        let expected = 87.43

        do {
            let value = try json.parseDouble(keyPath)
            XCTAssertEqual(value, expected)

            let optionalValue = try json.parseOptionalDouble(keyPath)
            XCTAssertNotNil(optionalValue)
            XCTAssertEqual(optionalValue, expected)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testInvalidDouble() {
        let keyPath = "invalidDouble"
        do {
            let _ = try json.parseDouble(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: Double = try json.parse(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _ = try json.parseOptionalDouble(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: Double? = try json.parseOptional(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
    }

    func testInvalidDoubleString() {
        let keyPath = "invalidDoubleString"
        do {
            let _ = try json.parseDouble(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _ = try json.parseOptionalDouble(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
    }

    func testValidBool() {
        let keyPath = "validBool"
        let expected = true

        do {
            let value = try json.parseBool(keyPath)
            XCTAssertEqual(value, expected)

            let general: Bool = try json.parse(keyPath)
            XCTAssertEqual(general, expected)

            let optionalValue = try json.parseOptionalBool(keyPath)
            XCTAssertNotNil(optionalValue)
            XCTAssertEqual(optionalValue, expected)

            let optionalGeneral: Bool? = try json.parseOptional(keyPath)
            XCTAssertNotNil(optionalGeneral)
            XCTAssertEqual(optionalGeneral, expected)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testValidBoolStrings() {
        let expectedValues = [
            "validBoolString0": true,
            "validBoolString1": false,
            "validBoolString2": true,
            "validBoolString3": false,
            "validBoolString4": true,
            "validBoolString5": false,
            "validBoolString6": true,
            "validBoolString7": false,
            "validBoolString8": true,
            "validBoolString9": false
        ]

        do {
            for (keyPath, expected) in expectedValues {
                let value = try json.parseBool(keyPath)
                XCTAssertEqual(value, expected)

                let optionalValue = try json.parseOptionalBool(keyPath)
                XCTAssertNotNil(optionalValue)
                XCTAssertEqual(optionalValue, expected)
            }
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testInvalidBool() {
        let keyPath = "invalidBool"
        do {
            let _ = try json.parseBool(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _ = try json.parseOptionalBool(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
    }

    func testInvalidBoolString() {
        let keyPath = "invalidBoolString"
        do {
            let _ = try json.parseBool(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _ = try json.parseOptionalBool(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
    }

    func testValidDate() {
        let keyPath = "validDate"
        let expected = validDate

        do {
            let value = try json.parseDate(keyPath)
            XCTAssertEqual(value, expected)

            let general: Date = try json.parse(keyPath)
            XCTAssertEqual(general, expected)

            let optionalValue = try json.parseOptionalDate(keyPath)
            XCTAssertNotNil(optionalValue)
            XCTAssertEqual(optionalValue, expected)

            let optionalGeneral: Date? = try json.parseOptional(keyPath)
            XCTAssertNotNil(optionalGeneral)
            XCTAssertEqual(optionalGeneral, expected)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testInvalidDate() {
        let keyPath = "invalidDate"
        do {
            let _ = try json.parseDate(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: Date = try json.parse(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _ = try json.parseOptionalDate(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: Date? = try json.parseOptional(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
    }

    func testValidDateDifferentFormat() {
        let keyPath = "validDateDifferentFormat"
        let expected = validDate

        let formatter = DateFormatter()
        formatter.dateFormat = differentDateFormat

        do {
            let value = try json.parseDate(keyPath, dateFormatter: formatter)
            XCTAssertEqual(value, expected)

            let general: Date = try json.parse(keyPath, dateFormatter: formatter)
            XCTAssertEqual(general, expected)

            let optionalValue = try json.parseOptionalDate(keyPath, dateFormatter: formatter)
            XCTAssertNotNil(optionalValue)
            XCTAssertEqual(optionalValue, expected)

            let optionalGeneral: Date? = try json.parseOptional(keyPath, dateFormatter: formatter)
            XCTAssertNotNil(optionalGeneral)
            XCTAssertEqual(optionalGeneral, expected)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testValidStringEnum() {
        let keyPath = "validStringEnum"
        let expected = StringEnum.one

        do {
            let value: StringEnum = try json.parseEnum(keyPath)
            XCTAssertEqual(value, expected)

            let general: StringEnum = try json.parse(keyPath)
            XCTAssertEqual(general, expected)

            let optionalValue: StringEnum? = try json.parseOptionalEnum(keyPath)
            XCTAssertNotNil(optionalValue)
            XCTAssertEqual(optionalValue, expected)

            let optionalGeneral: StringEnum? = try json.parseOptional(keyPath)
            XCTAssertNotNil(optionalGeneral)
            XCTAssertEqual(optionalGeneral, expected)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testInvalidStringEnum() {
        let keyPath = "invalidStringEnum"
        do {
            let _: StringEnum = try json.parseEnum(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: StringEnum = try json.parse(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: StringEnum = try json.parseEnum(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: StringEnum? = try json.parseOptional(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
    }

    func testValidIntEnum() {
        let keyPath = "validIntEnum"
        let expected = IntEnum.one

        do {
            let value: IntEnum = try json.parseEnum(keyPath)
            XCTAssertEqual(value, expected)

            let general: IntEnum = try json.parse(keyPath)
            XCTAssertEqual(general, expected)

            let optionalValue: IntEnum? = try json.parseOptionalEnum(keyPath)
            XCTAssertNotNil(optionalValue)
            XCTAssertEqual(optionalValue, expected)

            let optionalGeneral: IntEnum? = try json.parseOptional(keyPath)
            XCTAssertNotNil(optionalGeneral)
            XCTAssertEqual(optionalGeneral, expected)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testInvalidIntEnum() {
        let keyPath = "invalidIntEnum"
        do {
            let _: IntEnum = try json.parseEnum(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: IntEnum = try json.parse(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: IntEnum = try json.parseEnum(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: IntEnum? = try json.parseOptional(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
    }

    func testValidURL() {
        let keyPath = "validURL"
        let expected = URL(string: "https://www.google.com")

        do {
            let value = try json.parseURL(keyPath)
            XCTAssertEqual(value, expected)

            let optionalValue = try json.parseOptionalURL(keyPath)
            XCTAssertNotNil(optionalValue)
            XCTAssertEqual(optionalValue, expected)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testInvalidURL() {
        let keyPath = "invalidURL"
        do {
            let _ = try json.parseURL(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _ = try json.parseOptionalURL(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
    }

    func testValidParsable() {
        let keyPath = "validParsable"
        let expected = "Some value"
        do {
            let value: TestStruct = try json.parseParsable(keyPath)
            XCTAssertEqual(value.value, expected)

            let general: TestStruct = try json.parse(keyPath)
            XCTAssertEqual(general.value, expected)

            let optionalValue: TestStruct? = try json.parseOptionalParsable(keyPath)
            XCTAssertNotNil(optionalValue)
            XCTAssertEqual(optionalValue?.value, expected)

            let optionalGeneral: TestStruct? = try json.parseOptional(keyPath)
            XCTAssertNotNil(optionalGeneral)
            XCTAssertEqual(optionalGeneral?.value, expected)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testInvalidParsable() {
        let keyPath = "invalidParsable"
        do {
            let _: TestStruct = try json.parseParsable(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: TestStruct = try json.parse(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: TestStruct? = try json.parseOptionalParsable(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: TestStruct? = try json.parseOptional(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
    }

    func testValidParsableList() {
        let keyPath = "validParsableList"
        do {
            let value: [TestStruct] = try json.parseParsableList(keyPath)
            XCTAssertEqual(value.count, 2)
            XCTAssertEqual(value[0].value, "one")
            XCTAssertEqual(value[1].value, "two")

            let general: [TestStruct] = try json.parse(keyPath)
            XCTAssertEqual(general.count, 2)
            XCTAssertEqual(general[0].value, "one")
            XCTAssertEqual(general[1].value, "two")

            let optionalValue: [TestStruct]? = try json.parseParsableList(keyPath)
            XCTAssertNotNil(optionalValue)
            XCTAssertEqual(optionalValue?.count, 2)
            XCTAssertEqual(optionalValue?[0].value, "one")
            XCTAssertEqual(optionalValue?[1].value, "two")

            let optionalGeneral: [TestStruct]? = try json.parseOptional(keyPath)
            XCTAssertNotNil(optionalGeneral)
            XCTAssertEqual(optionalGeneral?.count, 2)
            XCTAssertEqual(optionalGeneral?[0].value, "one")
            XCTAssertEqual(optionalGeneral?[1].value, "two")
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testInvalidParsableList() {
        let keyPath = "invalidParsableList"
        do {
            let _: [TestStruct] = try json.parseParsableList(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: [TestStruct] = try json.parse(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: [TestStruct]? = try json.parseOptionalParsableList(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
        do {
            let _: [TestStruct]? = try json.parseOptional(keyPath)
            XCTFail("Shouldn't get here")
        } catch {
            // Success
        }
    }
    
    func testKeyNotFound() {
        do {
            let _: Any = try json.parse(invalidKeyPath)
            XCTFail("Shouldn't get here")
        } catch ParseError.keyPathNotFound(_) {
            // Success
        } catch {
            XCTFail("Wrong error thrown")
        }
    }
    
}

private enum StringEnum: String {
    case one
}

private enum IntEnum: Int {
    case one = 1
}

private struct TestStruct: Parsable {
    
    let value: String
    
    init(json: NSDictionary) throws {
        value = try json.parse("value")
    }
    
}
