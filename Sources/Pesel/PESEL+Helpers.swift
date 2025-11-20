func pesel(from rawValue: consuming String) throws(PESEL.Failure) -> [UInt8] {
  let pesel = extractDigits(from: rawValue)
  guard pesel.count == 11
  else { throw PESEL.Failure.invalidFormat(rawValue) }
  
  var checksum = 0
  let weights = [1, 3, 7, 9]
  for i in 0 ..< pesel.count - 1 {
    checksum += Int(pesel[i]) * weights[i % 4]
  }
  
  checksum = (10 - checksum % 10) % 10
  let lastDigit = Int(pesel[10])
  guard checksum == lastDigit else {
    throw PESEL.Failure.invalidChecksum(
      checksum,
      lastDigit
    )
  }
  return pesel
}

private func extractDigits(from rawValue: String) -> [UInt8] {
  var asciiDigits = [UInt8]()
  for value in rawValue {
    guard
      let asciiValue = value.asciiValue,
      asciiValue >= 48 && asciiValue <= 57
    else { continue }
    
    asciiDigits.append(asciiValue % 48)
  }
  return asciiDigits
}
