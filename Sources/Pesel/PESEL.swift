#if canImport(Foundation)
import Foundation
#endif

public struct PESEL: Sendable, Hashable {
  public internal(set) var _rawValue: [UInt8]
  
  public var rawValue: String {
    self._rawValue
      .map(String.init)
      .joined()
  }
  
  /// The sex of the person associated with a given PESEL number.
  public var sex: Sex {
    self._rawValue[9] % 2 == 0 ? .female : .male
  }
  
  public var checkDigit: Int {
    Int(self._rawValue[10])
  }
  
  public var uniqueIdentificationNumber: Int {
    Int(self._rawValue[6]) * 100 +
    Int(self._rawValue[7]) * 10 +
    Int(self._rawValue[8])
  }
  
  /// The birth year of the person associated with a given PESEL number.
  public var year: Int {
    Int(self._rawValue[0]) * 10 +
    Int(self._rawValue[1]) +
    self._centuryRangeUnderlayingYear
  }
  
  /// The birth month of the person associated with a given PESEL number.
  ///
  /// Depending on the century PESEL holder was born, the month number is appendend with, respectivally:
  /// - 80 for 18th centaury
  /// - 00 for 19th century
  /// - 20 for 20th century
  /// - 40 for 21th century
  /// - 60 for 22th century
  public var month: Int {
    Int(self._rawValue[2]) * 10 +
    Int(self._rawValue[3]) % 20
  }
  
  /// The birth date of the person associated with a given PESEL number.
  public var day: Int {
    Int(self._rawValue[4]) * 10 +
    Int(self._rawValue[5])
  }
  
#if canImport(Foundation)
  /// The birth date of the person associated with the PESEL number.
  public var date: Date {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.date(
      from: "\(self.year)-\(self.month)-\(self.day)"
    ).unsafelyUnwrapped
  }
#else
  /// The birth date of the person associated with the PESEL number.
  /// Complient with ISO 8601 format.
  public var date: String {
    "\(self.year)-\(self.month)-\(self.day)"
  }
#endif
  
  private var _centuryRangeUnderlayingYear: Int {
    switch self._rawValue[2] * 10 + self._rawValue[3] {
    case 0...12:
      return 1900
      
    case 21...32:
      return 2000
      
    case 41...52:
      return 2100
      
    case 61...72:
      return 2200
      
    case 81...92:
      return 1800
      
    default:
      return -1
    }
  }
  
  @discardableResult
  public init(_ rawValue: String) throws(PESEL.Failure) {
    self._rawValue = try pesel(from: rawValue)
    if self.day == 0 || self.month == 0 {
      throw PESEL.Failure.invalidDate(
        day,
        month,
        year % 100
      )
    }
  }
}
