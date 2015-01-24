require_relative '../base_spec'

describe Abrupt::Transformation::Website::Subject do
  it_should_behave_like 'convertable object' do
    let(:expected_values) do
      [{ :words => ["unterbreiten", "document"],
         :subjects =>
             { :Liste__Sprache_ => "3",
               :Portal_Abk => "3",
               :R => "3",
               :Begriffskl => "3",
               :Portal_Kommunikation_als_Thema => "3",
               :Abk => "3",
               :Liste__Abk => "3",
               :Kofferwort => "3",
               :Zeitliche_Systematik => "3",
               :Liste => "3",
               :Einzelwort => "3" },
         :wordlimit => "20",
         :classLimit => 17,
         :language => "de",
         :depth => 3 },
       { :words => ["input", "google"],
         :subjects =>
             { :Liste__Sprache_ => "3",
               :Portal_Abk => "3",
               :R => "3",
               :Begriffskl => "3",
               :Portal_Kommunikation_als_Thema => "3",
               :Abk => "3",
               :Liste__Abk => "3",
               :Kofferwort => "3",
               :Zeitliche_Systematik => "3",
               :Liste => "3",
               :Einzelwort => "3" },
         :wordlimit => "20",
         :classLimit => 18,
         :language => "de",
         :depth => 3 }]
    end
  end
end
