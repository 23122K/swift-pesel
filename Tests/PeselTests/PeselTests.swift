import Pesel
import Testing

@Suite
struct PESELTests {
  @Test(arguments: valid)
  func expectValidPeselNumber(_ rawValue: String) throws {
    #expect(throws: Never.self) {
      try PESEL(rawValue)
    }
  }
  
  @Test
  func expectedToDetectInvalidDateFailure() {
    let failure = #expect(throws: PESEL.Failure.self) {
      try PESEL("00000000000")
    }
    #expect(failure == .invalidDate(0, 0, 0))
  }
  
  @Test
  func expectedToDetectInvalidChecksum() {
    let failure = #expect(throws: PESEL.Failure.self) {
      try PESEL("01234567890")
    }
    #expect(
      {
        switch failure {
        case .invalidChecksum:
          true
          
        default:
          false
        }
      }()
    )
  }
  
  @Test(arguments: invalid)
  func expectedToDetectInvalidFormat(_ rawValue: String) {
    let failure = #expect(throws: PESEL.Failure.self) {
      _ = try PESEL(rawValue)
    }
    #expect(
      {
        switch failure {
        case let .invalidFormat(capturedRawValue):
          rawValue == capturedRawValue
          
        default:
          false
        }
      }()
    )
  }
}

extension PESELTests {
  private static let valid = """
  55030101230
  96311856924
  46052869554
  69251464694
  36061194286
  34122195229
  47080662456
  15050434888
  92272329484
  52231934348
  28102943423
  95211639491
  46051255761
  74021946812
  57270626612
  44301234382
  02030295546
  44101124768
  02280845391
  01290371791
  39312289456
  38050448938
  45221638885
  62062011129
  20051175722
  40071153922
  45013162341
  73060543536
  46221077911
  96272293145
  72290913827
  19120649383
  44061377596
  90123058921
  89252462347
  93282954952
  75212812448
  69082835195
  12022616356
  28041819951
  84230769951
  15241733318
  35010339262
  08250378267
  85082913965
  93312187527
  99070351435
  66270717718
  85241434458
  15281344455
  07290273811
  68042667726
  73230598911
  52111939515
  67101571224
  15022789945
  83112981416
  04220493929
  89222383672
  67322441522
  47111193395
  89242823398
  62111638611
  26301384151
  32242937626
  60320967614
  49260239195
  02070372494
  95292395873
  97262672241
  00462211493
  82102717853
  89103046171
  90281981354
  19030259843
  33252486623
  99291535922
  58072415828
  52042063262
  88011043874
  00230812833
  83290883674
  44321775344
  42303112596
  06321178121
  83290736835
  30301186262
  06020332198
  58050198992
  06082579713
  87290747813
  37050334951
  98210956893
  87280695115
  28320357398
  35283196133
  76050656133
  69261834465
  79032475834
  45041562689
  """
  .split(separator: "\n")
  .map(String.init)
  
  private static let invalid = #"""
  Mock
  O1234567890
  78812381*1d
  
  """#
  .split(separator: "\n")
  .map(String.init)
}
