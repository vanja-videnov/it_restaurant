FactoryGirl.define do
  factory :menu do
    date "2016-03-22"
  end
  factory :menu_easter,class: Menu do
    date "2016-03-22"
  end
end
