#if canImport(Foundation)
@_exported public import protocol Foundation.LocalizedError
#endif

extension PESEL {
  public enum Failure: Hashable {
    case invalidFormat(_ rawValue: String)
    case invalidDate(_ day: Int, _ month: Int, _ year: Int)
    case invalidChecksum(_ calculated: Int, _ epxected: Int)
    
    fileprivate var _errorDescription: String {
      switch self {
      case let .invalidFormat(rawValue):
        """
        Length: \(rawValue.count), 
        Underlying value: \(rawValue)
        """
        
      case let .invalidChecksum(calculated, expected):
        """
        Calculated last digit: \(calculated), expected: \(expected)
        """
        
      case let .invalidDate(day, month, year):
        "\(year)-\(month)-\(day) is not a valid date"
      }
    }
  }
}

#if canImport(Foundation)
extension PESEL.Failure: LocalizedError {
  public var errorDescription: String? {
    self._errorDescription
  }
}
#else
extension PESEL.Failure: Error {
  public var errorDescription: String {
    self._errorDescription
  }
}
#endif
