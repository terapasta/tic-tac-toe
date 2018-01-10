class IncompatibleChars
  Data = [
    {:desc=>"No.", :sjis=>34690, :utf8=>8470},
    {:desc=>"K.K.", :sjis=>34691, :utf8=>13261},
    {:desc=>"TEL", :sjis=>34692, :utf8=>8481},
    {:desc=>"(上)", :sjis=>34693, :utf8=>12964},
    {:desc=>"(中)", :sjis=>34694, :utf8=>12965},
    {:desc=>"(下)", :sjis=>34695, :utf8=>12966},
    {:desc=>"(左)", :sjis=>34696, :utf8=>12967},
    {:desc=>"(右)", :sjis=>34697, :utf8=>12968},
    {:desc=>"(株)", :sjis=>34698, :utf8=>12849},
    {:desc=>"(有)", :sjis=>34699, :utf8=>12850},
    {:desc=>"(代)", :sjis=>34700, :utf8=>12857},
    {:desc=>"明治", :sjis=>34701, :utf8=>13182},
    {:desc=>"大正", :sjis=>34702, :utf8=>13181},
    {:desc=>"昭和", :sjis=>34703, :utf8=>13180},
    {:desc=>"平成", :sjis=>34686, :utf8=>13179},
    {:desc=>"mm", :sjis=>34671, :utf8=>13212},
    {:desc=>"cm", :sjis=>34672, :utf8=>13213},
    {:desc=>"km", :sjis=>34673, :utf8=>13214},
    {:desc=>"mg", :sjis=>34674, :utf8=>13198},
    {:desc=>"kg", :sjis=>34675, :utf8=>13199},
    {:desc=>"cc", :sjis=>34676, :utf8=>13252},
    {:desc=>"m2", :sjis=>34677, :utf8=>13217},
    {:desc=>"ミリ", :sjis=>34655, :utf8=>13129},
    {:desc=>"キロ", :sjis=>34656, :utf8=>13076},
    {:desc=>"センチ", :sjis=>34657, :utf8=>13090},
    {:desc=>"メートル", :sjis=>34658, :utf8=>13133},
    {:desc=>"グラム", :sjis=>34659, :utf8=>13080},
    {:desc=>"トン", :sjis=>34660, :utf8=>13095},
    {:desc=>"アール", :sjis=>34661, :utf8=>13059},
    {:desc=>"ヘクタール", :sjis=>34662, :utf8=>13110},
    {:desc=>"リットル", :sjis=>34663, :utf8=>13137},
    {:desc=>"ワット", :sjis=>34664, :utf8=>13143},
    {:desc=>"カロリー", :sjis=>34665, :utf8=>13069},
    {:desc=>"ドル", :sjis=>34666, :utf8=>13094},
    {:desc=>"センチ", :sjis=>34667, :utf8=>13091},
    {:desc=>"パーセント", :sjis=>34668, :utf8=>13099},
    {:desc=>"ページ", :sjis=>34670, :utf8=>13115},
    {:desc=>"(1)", :sjis=>34624, :utf8=>9312},
    {:desc=>"(2)", :sjis=>34625, :utf8=>9313},
    {:desc=>"(3)", :sjis=>34626, :utf8=>9314},
    {:desc=>"(4)", :sjis=>34627, :utf8=>9315},
    {:desc=>"(5)", :sjis=>34628, :utf8=>9316},
    {:desc=>"(6)", :sjis=>34629, :utf8=>9317},
    {:desc=>"(7)", :sjis=>34630, :utf8=>9318},
    {:desc=>"(8)", :sjis=>34631, :utf8=>9319},
    {:desc=>"(9)", :sjis=>34632, :utf8=>9320},
    {:desc=>"(10)", :sjis=>34633, :utf8=>9321},
    {:desc=>"(11)", :sjis=>34634, :utf8=>9322},
    {:desc=>"(12)", :sjis=>34635, :utf8=>9323},
    {:desc=>"(13)", :sjis=>34636, :utf8=>9324},
    {:desc=>"(14)", :sjis=>34637, :utf8=>9325},
    {:desc=>"(15)", :sjis=>34638, :utf8=>9326},
    {:desc=>"(16)", :sjis=>34639, :utf8=>9327},
    {:desc=>"(17)", :sjis=>34640, :utf8=>9328},
    {:desc=>"(18)", :sjis=>34641, :utf8=>9329},
    {:desc=>"(19)", :sjis=>34642, :utf8=>9330},
    {:desc=>"(20)", :sjis=>34643, :utf8=>9331},
    {:desc=>"I", :sjis=>34644, :utf8=>8544},
    {:desc=>"II", :sjis=>34645, :utf8=>8545},
    {:desc=>"III", :sjis=>34646, :utf8=>8546},
    {:desc=>"IV", :sjis=>34647, :utf8=>8547},
    {:desc=>"V", :sjis=>34648, :utf8=>8548},
    {:desc=>"VI", :sjis=>34649, :utf8=>8549},
    {:desc=>"VII", :sjis=>34650, :utf8=>8550},
    {:desc=>"VIII", :sjis=>34651, :utf8=>8551},
    {:desc=>"IX", :sjis=>34652, :utf8=>8552},
    {:desc=>"X", :sjis=>34653, :utf8=>8553},
    {:desc=>"ダブルコーテーション右寄り", :sjis=>34688, :utf8=>12317},
    {:desc=>"ダブルコーテーション左より", :sjis=>34689, :utf8=>12319},
    {:desc=>"縦の下に横", :sjis=>33243, :utf8=>8869},
    {:desc=>"横棒", :sjis=>33148, :utf8=>45},
    {:desc=>"横棒", :sjis=>33117, :utf8=>45},
    {:desc=>"横棒", :sjis=>33951, :utf8=>45},
  ].freeze

  def initialize(sjis_string)
    @sjis_string = sjis_string
  end

  def convert
    each_convert_and_join(@sjis_string.each_codepoint.to_a)
  end

  private
    def each_convert_and_join(sjis_codepoints)
      sjis_codepoints.inject([]) { |acc, sjc|
        ic = Data.detect{ |ic| ic[:sjis] == sjc }
        char = if ic != nil
          ic[:utf8].chr(Encoding::UTF_8)
        else
          begin
            sjc.chr(Encoding::SHIFT_JIS).encode(Encoding::UTF_8)
          rescue => e
            pp "#{e.inspect} / #{sjc}"
            '?'
          end
        end
        acc << char
        acc
      }.join
    end
end