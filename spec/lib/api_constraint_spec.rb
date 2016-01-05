require 'spec_helper'

describe ApiConstraint do
  let!(:api_constraint) { ApiConstraint.new('myst', version: 2.3) }
  let!(:default_api_constraint) { ApiConstraint.new('myst', version: 1, default: true) }

  describe '#matches?' do
    it 'should return true when Accept header matches the version' do
      request = double(host: 'test', headers: { 'Accept' => 'application/vnd.myst-v2.3+json' })
      expect(api_constraint.matches?(request)).to be(true)
    end

    it 'should return false when Accept header matches wrong the version' do
      request = double(host: 'test', headers: { 'Accept' => 'application/vnd.myst-v2+json' })
      expect(api_constraint.matches?(request)).to be(false)
    end

    it 'should return false when Accept header matches wrong the version' do
      request = double(host: 'test', headers: {})
      expect(default_api_constraint.matches?(request)).to be(true)
    end
  end
end
