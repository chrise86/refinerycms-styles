require 'spec_helper'

module Refinery
  module Style
    describe ImageCategory do
      describe "validations" do
        subject do
          FactoryGirl.create(:image_category)
        end

        it { should be_valid }
        its(:errors) { should be_empty }
      end
    end
  end
end
