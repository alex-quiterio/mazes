require 'spec_helper'

describe User do

  context "#factory" do
    it 'should be valid' do
      expect(Fabricate(:user)).to be_valid
    end
  end

  context "#validations" do
    it "should not admit users within a certain criteria" do
      expect(Fabricate.build(:user, email: nil)).to be_invalid
    end
  end

  expected_roles = ['guest', 'admin', 'normal']
  context '#role' do
    it 'should have "guest" as default value' do
      expect(Fabricate(:user, role: nil)).to be_guest
    end

    it 'should support other role at start' do
      expect(Fabricate(:admin_user)).to be_admin
    end

    it "has a range of valid roles such as: #{expected_roles}" do
      expect(User.roles.keys).to include(*expected_roles)
    end
  end


end
