Fabricator(:user) do
  name 'H. G. Wells'
  email { sequence(:email) { |i| "g.wells_#{i}@gutenberg.com" } }
  password { FFaker::Internet.password }
  role :normal
end

Fabricator(:admin_user, from: :user) do
  name 'Baruch Spinoza'
  email { sequence(:email) {|i| "b.spinoza_#{i}@gutenberg.org"} }
  role :admin
end

Fabricator(:user_authenticated, from: :user) do
 remember_token { FFaker::Internet.password }
 remember_created_at { Time.now }
end
