require 'rails_helper'
require 'spec_helper'

describe Author do

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :nationality }
  it { is_expected.to validate_uniqueness_of :name }

	 context "#factory" do
    it 'should be valid' do
      expect(Fabricate(:author)).to be_valid
    end
  end


end
