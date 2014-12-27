require_relative '../base_spec'

describe Abrupt::Transformation::Website::Readability do
  it_should_behave_like 'convertable object' do
    let(:expected_values) do
      [{ readability: 4.5212887507066,
         syllables: 399,
         words: 232,
         numberOfLinks: 11,
         bigwords: 44,
         sentences: 61,
         language: 'de' },
       { readability: 6.6552643905041,
         syllables: 287,
         words: 163,
         numberOfLinks: 21,
         bigwords: 44,
         sentences: 46,
         language: 'de' },
       { readability: 6.65643905041,
         syllables: 28,
         words: 123,
         numberOfLinks: 21,
         bigwords: 24,
         sentences: 26,
         language: 'de' }]
    end
  end
end
