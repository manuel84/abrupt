require_relative '../base_spec'

describe Abrupt::Transformation::Website::Picture do
  it_should_behave_like 'convertable object' do
    let(:expected_values) do
      [{:duration => 3.9,
        :images =>
            [{:mimetype => "image/JPEG",
              :duration => 3.9,
              :filename => "random.jpg",
              :type => "normal",
              :geometry => "285x379"},
             {:mimetype => "image/PNG",
              :duration => 0.0,
              :filename => "RikschaLogo.png",
              :type => "article",
              :geometry => "135x111"}]},
       {:duration => 0.0}]
    end
  end
end