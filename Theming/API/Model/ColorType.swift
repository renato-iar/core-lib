

public enum ColorType: String, RawRepresentable, CaseIterable {

    case background
    case groupBackground
    case backgroundSecondary
    case backgroundInverted

    case text
    case textSecondary
    case textInverted
    case textHighlighted

    case highlight

    case trendPositive
    case trendNegative
    case trendSame

    case boxGradientStart
    case boxGradientEnd

    case redacted
    case redactedLight
    case redactedDark
}
