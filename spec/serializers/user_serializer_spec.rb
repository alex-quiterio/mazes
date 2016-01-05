require 'rails_helper'
require 'spec_helper'

describe UserSerializer do

 let(:user) { Fabricate(:user, remember_token: 'eureka') }
 let(:user_json) { { id: user.id, email: user.email, role: user.role } }
 subject { UserSerializer.new(user) }

 it { expect(subject.as_json).to eq(user_json) }

end
