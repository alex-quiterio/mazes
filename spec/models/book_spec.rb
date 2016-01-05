require 'rails_helper'
require 'spec_helper'

describe Book do

    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :author }

    context "#factory" do
      it 'should be valid' do
        expect(Fabricate(:book)).to be_valid
      end
    end
end
