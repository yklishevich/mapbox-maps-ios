import Foundation
import UIKit

@_functionBuilder
/// A function builder struct that builds expressions.
public struct ExpressionBuilder {

    /**
     Build an `Expression` arguments that conform to the `ValidExpressionObject` protocol.
     - Parameter arguments:
     - Returns: Returns an `Expression` that contains the arguments as the `Expression.expressionElements` value.
     */
    public static func buildBlock(_ arguments: ValidExpressionArgument...) -> Expression {

        var expressionElements = [Expression.Element]()

        for arg in arguments {
            expressionElements = expressionElements + arg.expressionElements
        }

        return Expression(with: expressionElements)
    }
}

/// A protocol for objects that can be used to create `Expression` values.
public protocol ValidExpressionArgument {
    /// An array of expression elements.
    var expressionElements: [Expression.Element] { get }
}

extension Int: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [.argument(.number(Double(self)))]
    }
}

extension UInt: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [.argument(.number(Double(self)))]
    }
}

extension Double: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [.argument(.number(Double(self)))]
    }
}

extension String: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [.argument(.string(self))]
    }
}

extension Bool: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [.argument(.boolean(self))]
    }
}

extension Array: ValidExpressionArgument where Element == Double {
    public var expressionElements: [Expression.Element] {
        return [.argument(.array(self))]
    }
}

extension Expression.Element: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [self]
    }
}

extension Expression: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [.argument(.expression(self))]
    }
}

extension Expression.Argument: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [.argument(self)]
    }
}

extension Expression.Operator: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [.op(self)]
    }
}

extension Dictionary: ValidExpressionArgument where Key: ValidExpressionArgument,
                                                    Value: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        var elements = [Expression.Element]()
        for (key, value) in self {
            elements = elements + key.expressionElements + value.expressionElements
        }
        return elements
    }
}
