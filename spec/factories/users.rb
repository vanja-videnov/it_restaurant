FactoryGirl.define do
  factory :user_waiter, class: User do
    name 'Sanja Sanja'
    email 'sanja@rbt.com'
    telephone '1234567890'
    password '123456vv'
    manager false
  end
end
