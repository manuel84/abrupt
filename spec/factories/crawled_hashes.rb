FactoryGirl.define do
  factory :rikscha_website_data, class: Hash do
    data do
      { :website =>
            { :domain => "http://www.rikscha-mainz.de",
              :url =>
                  [{ :name => "http://www.rikscha-mainz.de",
                     :state =>
                         { :name => "index",
                           :readability =>
                               { :readability => 5.288413836478,
                                 :syllables => 395,
                                 :words => 225,
                                 :numberOfLinks => 12,
                                 :bigwords => 48,
                                 :sentences => 53,
                                 :language => "de" },
                           :input => nil,
                           :subject =>
                               { :words => ["unterbreiten", "document"],
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
                           :complexity =>
                               { :contrast =>
                                     { :_1 =>
                                           { :A_tag_With_Low_Contrast => 0,
                                             :TextNodes_With_Low_Contrast => 0,
                                             :paragrahps_with_too_long_lines => 0 } },
                                 :vizweb =>
                                     { :numberOfLeaves => 1,
                                       :textArea => "0",
                                       :numberOfTextGroups => 0,
                                       :visualComplexity => 0.79690559961371,
                                       :numberOfImageAreas => 0,
                                       :hue => 0.78842163085938,
                                       :horizontalSymmetry => "1",
                                       :horizontalBalance => "null",
                                       :colorfulness => 13.723379102371,
                                       :nontextArea => 1.3333333333333 },
                                 :differenceMatrix =>
                                     [{ :matrix =>
                                            [0.0,
                                             37.735924528226,
                                             69.0,
                                             18.0,
                                             41.569219381653,
                                             24.657656011876,
                                             12.649110640674,
                                             37.735924528226,
                                             0.0,
                                             34.885527085025,
                                             21.260291625469,
                                             25.612496949731,
                                             26.832815729997,
                                             33.226495451672,
                                             69.0,
                                             34.885527085025,
                                             0.0,
                                             51.0,
                                             56.364882684168,
                                             60.934390946328,
                                             66.098411478643,
                                             18.0,
                                             21.260291625469,
                                             51.0,
                                             0.0,
                                             34.467375879228,
                                             22.360679774998,
                                             18.439088914586,
                                             41.569219381653,
                                             25.612496949731,
                                             56.364882684168,
                                             34.467375879228,
                                             0.0,
                                             20.396078054371,
                                             33.466401061363,
                                             24.657656011876,
                                             26.832815729997,
                                             60.934390946328,
                                             22.360679774998,
                                             20.396078054371,
                                             0.0,
                                             21.908902300207,
                                             12.649110640674,
                                             33.226495451672,
                                             66.098411478643,
                                             18.439088914586,
                                             33.466401061363,
                                             21.908902300207,
                                             0.0],
                                        :palette =>
                                            [4.0,
                                             4.0,
                                             4.0,
                                             12.0,
                                             12.0,
                                             40.0,
                                             4.0,
                                             4.0,
                                             73.0,
                                             4.0,
                                             4.0,
                                             22.0,
                                             28.0,
                                             28.0,
                                             28.0,
                                             12.0,
                                             24.0,
                                             16.0,
                                             16.0,
                                             4.0,
                                             8.0] }],
                                 :ratios =>
                                     { :pageSize =>
                                           { :pageSize_in_pixel_squared => 289600,
                                             :pageWidth_in_pixel => 400,
                                             :pageHeight_in_pixel => 724 },
                                       :img_Tag =>
                                           { :img_Area_in_pixel_squared => 2730,
                                             :img_document_tag_percentage => 0.94267955801105,
                                             :img_document_tag_ratio => 106.08058608059 } },
                                 :vicramComplexity => 0.6395 },
                           :link =>
                               { :a =>
                                     [{ :href => "http://www.rikscha-mainz.de" },
                                      { :plaintext => "sprechen sie uns an", :href => "/Kontakt/" }] },
                           :picture =>
                               { :duration => 3.9,
                                 :images =>
                                     [{ :mimetype => "image/JPEG",
                                        :duration => 3.9,
                                        :filename => "random.jpg",
                                        :type => "normal",
                                        :geometry => "285x379" },
                                      { :mimetype => "image/PNG",
                                        :duration => 0.0,
                                        :filename => "RikschaLogo.png",
                                        :type => "article",
                                        :geometry => "135x111" }] } } },
                   { :name => "http://www.rikscha-mainz.de/Kontakt/",
                     :state =>
                         { :name => "state5",
                           :readability =>
                               { :readability => 5.1171449882608,
                                 :syllables => 399,
                                 :words => 226,
                                 :numberOfLinks => 13,
                                 :bigwords => 46,
                                 :sentences => 49,
                                 :language => "de" },
                           :input =>
                               { :text =>
                                     [{ :id => "termin_von",
                                        :maxlength => 10,
                                        :name => "von",
                                        :value => nil,
                                        :class => "text",
                                        :required => nil,
                                        :type => "text",
                                        :size => 10 },
                                      { :id => "termin_bis",
                                        :maxlength => 10,
                                        :name => "bis",
                                        :value => nil,
                                        :class => "text",
                                        :type => "text",
                                        :size => 10 },
                                      { :id => "termin_zeit",
                                        :maxlength => 5,
                                        :name => "zeit",
                                        :value => nil,
                                        :class => "textdisabled",
                                        :type => "text",
                                        :disabled => nil,
                                        :size => 5 },
                                      { :id => "name",
                                        :maxlength => 60,
                                        :placeholder => "Vorname Nachname",
                                        :name => "name",
                                        :value => nil,
                                        :class => "text",
                                        :required => nil,
                                        :type => "text",
                                        :size => 40 },
                                      { :maxlength => 60,
                                        :placeholder => "Straße Hausnummer",
                                        :name => "strasse",
                                        :value => nil,
                                        :class => "text",
                                        :type => "text",
                                        :size => 40 },
                                      { :maxlength => 60,
                                        :placeholder => "PLZ Ort",
                                        :name => "ort",
                                        :value => nil,
                                        :class => "text",
                                        :type => "text",
                                        :size => 40 },
                                      { :maxlength => 60,
                                        :name => "telefon",
                                        :value => nil,
                                        :class => "text",
                                        :type => "text",
                                        :size => 40 },
                                      { :id => "lieferungOrt",
                                        :placeholder => "Lieferort",
                                        :name => "lieferungOrt",
                                        :value => nil,
                                        :type => "text",
                                        :size => 20 },
                                      { :maxlength => 60,
                                        :name => "aufmerksam_sonstiges",
                                        :value => nil,
                                        :class => "text",
                                        :type => "text",
                                        :size => 40 }],
                                 :submit =>
                                     [{ :name => "action",
                                        :value => "Anfrage senden",
                                        :onclick => "return(senden());",
                                        :class => "bold",
                                        :type => "submit" }],
                                 :email =>
                                     [{ :id => "email",
                                        :maxlength => 60,
                                        :name => "email",
                                        :value => nil,
                                        :class => "text",
                                        :required => nil,
                                        :type => "email",
                                        :size => 40 }],
                                 :textarea => [{ :cols => 60, :name => "bemerkung", :rows => 5 }],
                                 :checkbox =>
                                     [{ :id => "blumenSeide",
                                        :name => "blumen",
                                        :value => "Seidenrosen",
                                        :type => "checkbox" },
                                      { :id => "herz", :name => "herz", :value => "Herz", :type => "checkbox" },
                                      { :id => "aufmerksam_internet",
                                        :name => "aufmerksam_internet",
                                        :value => "Internet",
                                        :type => "checkbox" },
                                      { :id => "aufmerksam_messe",
                                        :name => "aufmerksam_messe",
                                        :value => "Messe",
                                        :type => "checkbox" },
                                      { :id => "aufmerksam_zeitschrift",
                                        :name => "aufmerksam_zeitschrift",
                                        :value => "Zeitschrift",
                                        :type => "checkbox" },
                                      { :id => "aufmerksam_empfehlung",
                                        :name => "aufmerksam_empfehlung",
                                        :value => "Empfehlung",
                                        :type => "checkbox" },
                                      { :id => "agb",
                                        :name => "agb",
                                        :value => "ja",
                                        :required => nil,
                                        :type => "checkbox" }],
                                 :radio =>
                                     [{ :id => "angebot_3tage",
                                        :name => "angebot",
                                        :value => "3 Tage",
                                        :onclick => "angebotGewaehlt('3Tage');",
                                        :required => nil,
                                        :type => "radio" },
                                      { :id => "angebot_hz_fahrer",
                                        :name => "angebot",
                                        :value => "HZ-Fahrer",
                                        :onclick => "angebotGewaehlt('HZ-Fahrer');",
                                        :required => nil,
                                        :type => "radio" },
                                      { :id => "angebot_2tage",
                                        :name => "angebot",
                                        :value => "2 Tage",
                                        :onclick => "angebotGewaehlt('2Tage');",
                                        :required => nil,
                                        :type => "radio" },
                                      { :id => "angebot_rikschafahrt",
                                        :name => "angebot",
                                        :value => "Rikschafahrt",
                                        :onclick => "angebotGewaehlt('Rikschafahrt');",
                                        :required => nil,
                                        :type => "radio" },
                                      { :id => "angebot_1tag",
                                        :name => "angebot",
                                        :value => "1 Tag",
                                        :onclick => "angebotGewaehlt('1Tag');",
                                        :required => nil,
                                        :type => "radio" },
                                      { :id => "angebot_mondscheinfahrt",
                                        :name => "angebot",
                                        :value => "Mondscheinfahrt",
                                        :onclick => "angebotGewaehlt('Mondscheinfahrt');",
                                        :required => nil,
                                        :type => "radio" },
                                      { :id => "angebot_sonstiges",
                                        :name => "angebot",
                                        :value => "sonstiges",
                                        :onclick => "angebotGewaehlt('sonstiges');",
                                        :required => nil,
                                        :type => "radio" },
                                      { :id => "angebot_picknicktour",
                                        :name => "angebot",
                                        :value => "Picknicktour",
                                        :onclick => "angebotGewaehlt('Picknicktour');",
                                        :required => nil,
                                        :type => "radio" },
                                      { :id => "angebot_sonstigesFahrer",
                                        :name => "angebot",
                                        :value => "sonstiges Fahrer",
                                        :onclick => "angebotGewaehlt('sonstigesFahrer');",
                                        :required => nil,
                                        :type => "radio" },
                                      { :id => "lieferungBringen",
                                        :name => "lieferung",
                                        :value => "Bringen",
                                        :type => "radio",
                                        :checked => nil },
                                      { :id => "lieferungAbholung",
                                        :name => "lieferung",
                                        :value => "Abholung",
                                        :type => "radio" },
                                      { :id => "lieferungAnhaenger",
                                        :name => "lieferung",
                                        :value => "Anhänger",
                                        :type => "radio" }] },
                           :subject =>
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
                                 :depth => 3 },
                           :complexity =>
                               { :contrast =>
                                     { :_1 =>
                                           { :A_tag_With_Low_Contrast => 1,
                                             :TextNodes_With_Low_Contrast => 1,
                                             :paragrahps_with_too_long_lines => 0 } },
                                 :vizweb =>
                                     { :numberOfLeaves => 17,
                                       :textArea => "0.0074666341145833",
                                       :numberOfTextGroups => 1,
                                       :visualComplexity => 0.98656564934711,
                                       :numberOfImageAreas => 1,
                                       :hue => 0.92692057291667,
                                       :horizontalSymmetry => "1",
                                       :horizontalBalance => "null",
                                       :colorfulness => 13.811903651406,
                                       :nontextArea => 0.0044080946180556 },
                                 :differenceMatrix =>
                                     [{ :matrix =>
                                            [0.0,
                                             347.57157536254,
                                             83.138438763306,
                                             155.335121592,
                                             193.98969044771,
                                             207.84609690827,
                                             67.0,
                                             347.57157536254,
                                             0.0,
                                             264.43524727237,
                                             192.26284092356,
                                             153.5903642811,
                                             139.73546436034,
                                             314.05254337451,
                                             83.138438763306,
                                             264.43524727237,
                                             0.0,
                                             72.228803118977,
                                             110.85125168441,
                                             124.70765814496,
                                             70.491134194308,
                                             155.335121592,
                                             192.26284092356,
                                             72.228803118977,
                                             0.0,
                                             38.794329482542,
                                             52.621288467691,
                                             129.71507237018,
                                             193.98969044771,
                                             153.5903642811,
                                             110.85125168441,
                                             38.794329482542,
                                             0.0,
                                             13.856406460551,
                                             164.66025628548,
                                             207.84609690827,
                                             139.73546436034,
                                             124.70765814496,
                                             52.621288467691,
                                             13.856406460551,
                                             0.0,
                                             177.78920102188,
                                             67.0,
                                             314.05254337451,
                                             70.491134194308,
                                             129.71507237018,
                                             164.66025628548,
                                             177.78920102188,
                                             0.0],
                                        :palette =>
                                            [4.0,
                                             4.0,
                                             4.0,
                                             206.0,
                                             205.0,
                                             203.0,
                                             52.0,
                                             52.0,
                                             52.0,
                                             96.0,
                                             93.0,
                                             92.0,
                                             116.0,
                                             116.0,
                                             116.0,
                                             124.0,
                                             124.0,
                                             124.0,
                                             4.0,
                                             4.0,
                                             71.0] }],
                                 :ratios =>
                                     { :pageSize =>
                                           { :pageSize_in_pixel_squared => 1164339,
                                             :pageWidth_in_pixel => 619,
                                             :pageHeight_in_pixel => 1881 },
                                       :img_Tag =>
                                           { :img_Area_in_pixel_squared => 3612,
                                             :img_document_tag_percentage => 0.3102189310845,
                                             :img_document_tag_ratio => 322.35299003322 } },
                                 :vicramComplexity => 1.3497 },
                           :link =>
                               { :form => [{ :formAction => "/Gesendet/" }],
                                 :a =>
                                     [{ :plaintext => "startseite", :href => "/" },
                                      { :plaintext => "allgemeinen geschaef", :href => "/agb-rikscha.pdf" }] },
                           :picture => { :duration => 0.0 } } }] } }
    end
  end
end
