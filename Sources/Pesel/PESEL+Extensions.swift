extension PESEL: Identifiable {
  public var id: String {
    self.rawValue
  }
}

extension PESEL: Codable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.singleValueContainer()
    let rawValue = try container.decode(String.self)
    self._rawValue = try pesel(from: rawValue)
  }
}

extension PESEL: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    self.rawValue
  }
  
  public var debugDescription: String {
    """
    _rawValue: \(self._rawValue)
    rawValue: \(self.rawValue)
    """
  }
}
