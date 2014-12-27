require_relative '../base_spec'

describe Abrupt::Transformation::Website::Link do
  it_should_behave_like 'convertable object' do
    let(:expected_values) do
      [{:form => [{:formAction => "/Bestellt/"}],
        :a =>
            [{:href => "http://www.rikscha-mainz.de"},
             {:plaintext => "startseite", :href => "/"},
             {:plaintext => "angebot", :href => "/Angebot/"},
             {:plaintext => "fuhrpark", :href => "/Fuhrpark/"},
             {:plaintext => "kontakt", :href => "/Kontakt/"},
             {:plaintext => "galerie", :href => "/Galerie/"},
             {:plaintext => "epostkarten", :href => "/ePostkarten/"},
             {:plaintext => "stellenangebote", :href => "/Stellenangebote/"},
             {:plaintext => "partner", :href => "/Partner/"},
             {:plaintext => "impressum", :href => "/Impressum/"},
             {:plaintext => "<span&nbsp;style=\"fo",
              :href => "http://m.rikscha-mainz.de"}]},
       {:a =>
            [{:href => "http://www.rikscha-mainz.de"},
             {:plaintext => "startseite", :href => "/"},
             {:plaintext => "angebot", :href => "/Angebot/"},
             {:plaintext => "fuhrpark", :href => "/Fuhrpark/"},
             {:plaintext => "kontakt", :href => "/Kontakt/"},
             {:plaintext => "galerie", :href => "/Galerie/"},
             {:plaintext => "epostkarten", :href => "/ePostkarten/"},
             {:plaintext => "stellenangebote", :href => "/Stellenangebote/"},
             {:plaintext => "partner", :href => "/Partner/"},
             {:plaintext => "impressum", :href => "/Impressum/"},
             {:plaintext => "<span&nbsp;style=\"fo", :href => "http://m.rikscha-mainz.de"},
             {:href => "/Bild/klein/Galerie/Picknick/"},
             {:href => "/Bild/klein/Galerie/Krumelmonster1/"},
             {:plaintext => "gross", :href => "/Bild/gross/Galerie/SchlossWaldhausen/"},
             {:href => "/Bild/klein/Galerie/Picknick/"},
             {:href => "/Bild/klein/Galerie/Krumelmonster1/"},
             {:href => "/Bild/klein/Galerie/Picknick/"},
             {:href => "/Bild/klein/Galerie/Krumelmonster1/"},
             {:plaintext => "gross", :href => "/Bild/gross/Galerie/SchlossWaldhausen/"},
             {:href => "/Bild/klein/Galerie/Picknick/"},
             {:href => "/Bild/klein/Galerie/Krumelmonster1/"}]}]
    end
  end
end