import UIKit

public protocol ExpressionOption: ValidExpressionArgument, Codable { }

extension ExpressionOption {
    public var expressionElements: [Expression.Element] {
        return [.argument(.option(self))]
    }
}

public struct Formatted: Codable, Equatable {
    var formattedSections: [FormattedSection]?
}

public struct FormattedSection: Codable, Equatable {

    public enum Input: Codable, Equatable {
        case string(String)
        case expression(Exp) // image expression

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let validString = try? container.decode(String.self) {
                self = .string(validString)
            }

            if let validExp = try? container.decode(Expression.self) {
                self = .expression(validExp)
            }

            let context = DecodingError.Context(codingPath: decoder.codingPath,
                                                debugDescription: "Failed to decode FormattedSection")
            throw DecodingError.dataCorrupted(context)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
            case .expression(let exp):
                try container.encode(exp)
            case .string(let string):
                try container.encode(string)
            }
        }
    }

    public let input: Input
    public let options: FormatOptions?

    init(input: Input, options: FormatOptions? = nil) {
        self.input = input
        self.options = options
    }

    public static func == (lhs: FormattedSection, rhs: FormattedSection) -> Bool {
        return lhs.input == rhs.input && lhs.options == rhs.options
    }
}

public struct FormatOptions: ExpressionOption, Equatable {

    /// Applies a scaling factor on text-size as specified by the root layout property.
    public var fontScale: Double?

    /// Overrides the font stack specified by the root layout property
    public var textFont: [String]?

    /// Overrides the color specified by the root paint property.
    public var textColor: ColorRepresentable?

    internal enum CodingKeys: String, CodingKey {
        case fontScale = "font-scale"
        case textFont = "text-font"
        case textColor = "text-color"
    }

    public init(fontScale: Double?, textFont: [String]?, textColor: UIColor?) {
        self.fontScale = fontScale
        self.textFont = textFont

        if let textColor = textColor {
            self.textColor = ColorRepresentable(color: textColor)
        }
    }


}

public struct NumberFormatOptions: ExpressionOption {

    /// Specifies the locale to use, as a BCP 47 language tag.
    public var locale: String?

    /// Specifies an ISO 4217 code to use for currency-style formatting.
    public var currency: String?

    /// Minimum  number of fractional digits to include.
    public var minFractionDigits: Int?

    /// Maximum number of fractional digits to include.
    public var maxFractionDigits: Int?

    internal enum CodingKeys: String, CodingKey {
        case locale = "locale"
        case currency = "currency"
        case minFractionDigits = "min-fraction-digits"
        case maxFractionDigits = "max-fraction-digits"
    }

    public init(locale: String?, currency: String?, minFractionDigits: Int?, maxFractionDigits: Int?) {
        self.locale = locale
        self.currency = currency
        self.minFractionDigits = minFractionDigits
        self.maxFractionDigits = maxFractionDigits
    }
}

public struct CollatorOptions: ExpressionOption {

    /// Whether comparison option is case sensitive.
    public var caseSensitive: Bool?

    /// Whether the comparison operation is diacritic sensitive
    public var diacriticSensitive: Bool?

    /// The locale argument specifies the IETF language tag of the locale to use.
    /// If none is provided, the default locale is used.
    public var locale: String?

    internal enum CodingKeys: String, CodingKey {
        case locale = "locale"
        case caseSensitive = "case-sensitive"
        case diacriticSensitive = "diacritic-sensitive"
    }

    public init(caseSensitive: Bool?, diacriticSensitive: Bool?, locale: String?) {
        self.caseSensitive = caseSensitive
        self.diacriticSensitive = diacriticSensitive
        self.locale = locale
    }

}
