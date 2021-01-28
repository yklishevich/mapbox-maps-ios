import UIKit

public enum Formatted: Codable {
    case rawString(String)
    case formattedArray(FormattedArray)

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .rawString(let constant):
            try container.encode(constant)
        case .formattedArray(let formattedArray):
            try container.encode(formattedArray)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let decodedRawString = try? container.decode(String.self) {
            self = .rawString(decodedRawString)
            return
        }

        if let decodedFormattedArray = try? container.decode(FormattedArray.self) {
            self = .formattedArray(decodedFormattedArray)
            return
        }

        let context = DecodingError.Context(codingPath: decoder.codingPath,
                                            debugDescription: "Failed to decode Formatted")
        throw DecodingError.dataCorrupted(context)
    }
}

public typealias FormattedArray = [FormattedElement]

public enum FormattedElement: Codable {
    case subString(String)
    case subStringProperties(FormatOptions)
    case image(Exp)

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .subString(let constant):
            try container.encode(constant)
        case .subStringProperties(let properties):
            try container.encode(properties)
        case .image(let imageExp):
            try container.encode(imageExp)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let decodedSubstring = try? container.decode(String.self) {
            self = .subString(decodedSubstring)
            return
        }

        if let decodedFormattedProperties = try? container.decode(FormatOptions.self) {
            self = .subStringProperties(decodedFormattedProperties)
            return
        }

        if let decodedImageExp = try? container.decode(Exp.self) {
            self = .image(decodedImageExp)
            return
        }


        let context = DecodingError.Context(codingPath: decoder.codingPath,
                                            debugDescription: "Failed to decode FormattedElement")
        throw DecodingError.dataCorrupted(context)
    }

}
