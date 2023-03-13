//
//  Location.swift
//  epiFiProject
//
//  Created by Devank Karanwal on 11/03/23.
//

import Foundation

// MARK: - LocationElementElement
struct LocationElementElement: Codable {
    let version: Int?
    let key: String?
    let type: String?
    let rank: Int?
    let localizedName: String?
    let englishName: String?
    let primaryPostalCode: String?
    let country: Country?
    let region: Region?
    let administrativeArea: AdministrativeArea?
    let timeZone: TimeZone?
    let geoPosition: GeoPosition?
    let isAlias: Bool?
    let supplementalAdminAreas: [SupplementalAdminArea]?
    var dataSets: [String]
    let parentCity: ParentCity?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case key = "Key"
        case type = "Type"
        case rank = "Rank"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
        case primaryPostalCode = "PrimaryPostalCode"
        case region = "Region"
        case country = "Country"
        case administrativeArea = "AdministrativeArea"
        case timeZone = "TimeZone"
        case geoPosition = "GeoPosition"
        case isAlias = "IsAlias"
        case supplementalAdminAreas = "SupplementalAdminAreas"
        case dataSets = "DataSets"
        case parentCity = "ParentCity"
    }
}

// MARK: - AdministrativeArea
struct AdministrativeArea: Codable {
    let id, localizedName, englishName: String?
    let level: Int?
    let localizedType, englishType: String?
    let countryID: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
        case level = "Level"
        case localizedType = "LocalizedType"
        case englishType = "EnglishType"
        case countryID = "CountryID"
    }
}

enum EnglishTypeEnum: String, Codable {
    case division = "Division"
    case municipality = "Municipality"
    case prefecture = "Prefecture"
    case province = "Province"
    case region = "Region"
    case state = "State"
}

// MARK: - Country
struct Country: Codable {
    let id, localizedName, englishName: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
    }
}

// MARK: - Country
struct Region: Codable {
    let id, localizedName, englishName: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
    }
}


// MARK: - GeoPosition
struct DataSet: Codable {
    let AirQualityCurrentConditions: String?
    let AirQualityForecasts: String?
    let Alerts: String?
    let ForecastConfidence: String?
    let FutureRadar: String?
    let MinuteCast: String?
    let PremiumAirQuality: String?
    let Radar: String?

   
}



enum Name: String, Codable {
    case kota = "Kota"
}

// MARK: - GeoPosition
struct GeoPosition: Codable {
    let latitude, longitude: Double?
    let elevation: Elevation?

    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
        case elevation = "Elevation"
    }
}

// MARK: - Elevation
struct Elevation: Codable {
    let metric, imperial: Imperial?

    enum CodingKeys: String, CodingKey {
        case metric = "Metric"
        case imperial = "Imperial"
    }
}

// MARK: - Imperial
struct Imperial: Codable {
    let value: Int?
    let unit: String?
    let unitType: Int?

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
        case unitType = "UnitType"
    }
}

enum Unit: String, Codable {
    case ft = "ft"
    case m = "m"
}

// MARK: - ParentCity
struct ParentCity: Codable {
    let key, localizedName, englishName: String?

    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
    }
}

// MARK: - SupplementalAdminArea
struct SupplementalAdminArea: Codable {
    let level: Int?
    let localizedName, englishName: String?

    enum CodingKeys: String, CodingKey {
        case level = "Level"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
    }
}

// MARK: - TimeZone
struct TimeZone: Codable {
    let code, name: String?
    let gmtOffset: Double?
    let isDaylightSaving: Bool?
    let nextOffsetChange: String?

    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case name = "Name"
        case gmtOffset = "GmtOffset"
        case isDaylightSaving = "IsDaylightSaving"
        case nextOffsetChange = "NextOffsetChange"
    }
}

enum TypeEnum: String, Codable {
    case city = "City"
}

typealias LocationElement = [LocationElementElement]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
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
