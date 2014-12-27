require_relative '../base_spec'

describe Abrupt::Transformation::Website::Subject do
  it_should_behave_like 'convertable object' do
    let(:expected_values) do
      [{ words: %w(try https com src lt http protocol Fahrtbeginn web write),
         subjects: { Liste__Sprache_: '4',
                     Portal_Abk: '4',
                     R: '4',
                     Begriffskl: '4',
                     Portal_Kommunikation_als_Thema: '4',
                     Abk: '4',
                     Liste__Abk: '4',
                     Kofferwort: '4',
                     Zeitliche_Systematik: '4',
                     Liste: '4',
                     Einzelwort: '4' },
         wordlimit: '20',
         classLimit: 18,
         language: 'de',
         depth: 3 },
       { words: %w(http protocol com try lt https src jpg write location push),
         subjects: { Liste__Sprache_: '3',
                     Portal_Abk: '3',
                     R: '3',
                     Begriffskl: '3',
                     Essen_und_Trinken: '2',
                     Portal_Kommunikation_als_Thema: '3',
                     Abk: '3',
                     Liste__Abk: '3',
                     Kofferwort: '3',
                     Zeitliche_Systematik: '3',
                     Liste: '3',
                     Einzelwort: '3' },
         wordlimit: '20',
         classLimit: 17,
         language: 'de',
         depth: 3 }]
    end
  end
end
