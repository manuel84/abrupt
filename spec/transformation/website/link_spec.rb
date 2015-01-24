require_relative '../base_spec'

describe Abrupt::Transformation::Website::Link do
  it_should_behave_like 'convertable object' do
    let(:expected_values) do
      [{ :a =>
             [{ :href => "http://www.rikscha-mainz.de" },
              { :plaintext => "sprechen sie uns an", :href => "/Kontakt/" }] },
       { :form => [{ :formAction => "/Gesendet/" }],
         :a =>
             [{ :plaintext => "startseite", :href => "/" },
              { :plaintext => "allgemeinen geschaef", :href => "/agb-rikscha.pdf" }] }]
    end
  end
end
