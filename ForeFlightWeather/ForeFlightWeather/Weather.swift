// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weather = try? JSONDecoder().decode(Weather.self, from: jsonData)

import Foundation

// MARK: - Weather
public struct Weather: Codable {
    let report: Report
}

// MARK: - Report
struct Report: Codable {
    let conditions: Conditions
    let forecast: ReportForecast
    let windsAloft: ReportWindsAloft
    let mos: MOS
}

// MARK: - Conditions
struct Conditions: Codable {
    let text, ident: String
    let dateIssued: String
    let lat, lon: Double
    let elevationFt, tempC, dewpointC: Int
    let pressureHg, pressureHpa: Double
    let reportedAsHpa: Bool
    let densityAltitudeFt, relativeHumidity: Int
    let flightRules: String
    let cloudLayers, cloudLayersV2: [CloudLayer]
    let weather: [JSONAny]
    let visibility: ConditionsVisibility
    let remarks: Remarks
}

// MARK: - CloudLayer
struct CloudLayer: Codable {
    let coverage: String
    let altitudeFt: Int
    let ceiling: Bool
    let altitudeQualifier: Int?
}

// MARK: - Remarks
struct Remarks: Codable {
    let precipitationDiscriminator, humanObserver: Bool
    let seaLevelPressure, temperature, dewpoint: Double
    let visibility: WeatherBeginEndsClass
    let sensoryStatus, lightning: [JSONAny]
    let weatherBeginEnds: WeatherBeginEndsClass
    let clouds, obscuringLayers: [JSONAny]
}

// MARK: - WeatherBeginEndsClass
struct WeatherBeginEndsClass: Codable {
}

// MARK: - ConditionsVisibility
struct ConditionsVisibility: Codable {
    let distanceSm, prevailingVisSm: Double
}

// MARK: - ReportForecast
struct ReportForecast: Codable {
    let text, ident: String
    let dateIssued: String
    let period: Period
    let lat, lon: Double
    let elevationFt: Int
    let conditions: [PurpleCondition]
}

// MARK: - PurpleCondition
struct PurpleCondition: Codable {
    let text: String
    let dateIssued: String
    let lat, lon: Double
    let elevationFt, relativeHumidity: Int
    let flightRules: String
    let cloudLayers, cloudLayersV2: [CloudLayer]
    let weather: [JSONAny]
    let visibility: PurpleVisibility
    let period: Period
}

// MARK: - Period
struct Period: Codable {
    let dateStart, dateEnd: String
}

// MARK: - PurpleVisibility
struct PurpleVisibility: Codable {
    let distanceSm, prevailingVisSm: Double
}

// MARK: - MOS
struct MOS: Codable {
    let station: String
    let issued: String
    let period: Period
    let latitude, longitude: Double
    let forecast: MOSForecast
}

// MARK: - MOSForecast
struct MOSForecast: Codable {
    let text, ident: String
    let dateIssued: String
    let period: Period
    let lat, lon: Double
    let elevationFt: Int
    let conditions: [FluffyCondition]
}

// MARK: - FluffyCondition
struct FluffyCondition: Codable {
    let text: String
    let tempMinC, tempMaxC, dewpointMinC, dewpointMaxC: Double
    let flightRules: String
    let cloudLayers, cloudLayersV2: [CloudLayer]
    let weather: [JSONAny]
    let visibility: FluffyVisibility
    let period: Period
    let turbulence, icing: [JSONAny]
}

// MARK: - FluffyVisibility
struct FluffyVisibility: Codable {
    let distanceSm: Double
}

// MARK: - ReportWindsAloft
struct ReportWindsAloft: Codable {
    let lat, lon: Double
    let dateIssued: String
    let windsAloft: [WindsAloftElement]
    let source: String
}

// MARK: - WindsAloftElement
struct WindsAloftElement: Codable {
    let validTime: String
    let period: Period
    let windTemps: [String: WindTemp]
}

// MARK: - WindTemp
struct WindTemp: Codable {
    let directionFromTrue, knots, celsius, altitude: Int
    let isLightAndVariable, isGreaterThan199Knots, turbulence, icing: Bool
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
