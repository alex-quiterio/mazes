require 'spec_helper'

describe ApiConstraint do
  let(:api_name) { 'mysterious_app' }
  let!(:api_constraint) { ApiConstraint.new(api_name, version: 2.3) }
  let!(:default_api_constraint) { ApiConstraint.new(api_name, version: 1, default: true) }

  describe '#matches?' do
    it 'should return true when Accept header matches the version' do
      request = double(host: 'test', headers: { 'Accept' => "application/vnd.#{api_name}-v2.3+json" })
      expect(api_constraint.matches?(request)).to be(true)
    end

    it 'should return false when Accept header matches wrong the version' do
      request = double(host: 'test', headers: { 'Accept' => "application/vnd.#{api_name}-v2+json" })
      expect(api_constraint.matches?(request)).to be(false)
    end

    it 'should return false when Accept header matches wrong the version' do
      request = double(host: 'test', headers: {})
      expect(default_api_constraint.matches?(request)).to be(true)
    end
  end
end
