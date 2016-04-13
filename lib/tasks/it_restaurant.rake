namespace :it_restaurant do
  desc 'create manager'
  task create_manager: :environment do
    manager = User.new(email: 'vanja@test.com', manager: true, name: 'Manager', telephone: '1234567890', password: '123456vv')
    manager.save()
  end

  desc 'create waiter'
  task create_waiter: :environment do
    waiter = User.new(email: 'sanja@test.com', manager: false, name: 'Waiter', telephone: '1234567890', password: '123456vv')
    waiter.save()
  end

  desc 'create waiter with params'
  task :create_waiter_with_params, [:arg1, :arg2] =>:environment  do |task, args|
    waiter = User.new(email: args[:arg1], manager: false, name: 'Waiter', telephone: '1234567890', password: args[:arg2])

    if waiter.valid?
      waiter.save()

    elsif waiter.errors.any?
      waiter.errors.full_messages.each do |msg|
        puts msg
      end
    else
      puts "****NOT VALID****"
    end
  end

  desc 'give admin privilege'
  task :set_admin, [:arg1] =>:environment  do |task, args|
    waiter = User.find_by_email(args[:arg1])
    waiter.manager = true

    if waiter.valid?
      waiter.save()

    elsif waiter.errors.any?
      waiter.errors.full_messages.each do |msg|
        puts msg
      end
    else
      puts "****NOT VALID****"
    end
  end

  desc 'create new menu with name and current date'
  task :create_menu, [:arg1] =>:environment  do |task, args|
    menu = Menu.new(name: args[:arg1], date: Date.current)

    if menu.valid?
      menu.save()

    elsif menu.errors.any?
      menu.errors.full_messages.each do |msg|
        puts msg
      end
    else
      puts "****NOT VALID****"
    end
  end

  desc 'create tables'
  task create_tables: :environment  do |task, args|
    table = Table.new(number: 1)
    table2 = Table.new(number: 2)
    table.save()
    table2.save()
  end

  desc 'create food and drink categories'
  task create_basic_categories: :environment  do |task, args|
    food = Category.new(name: 'Food')
    drink = Category.new(name: 'Drink')
    food.save()
    drink.save()
  end

  desc 'create category with name'
  task :create_category, [:arg1] =>:environment  do |task, args|
    category = Category.new(name: args[:arg1])

    if category.valid?
      category.save()

    elsif category.errors.any?
      category.errors.full_messages.each do |msg|
        puts msg
      end
    else
      puts "****NOT VALID****"
    end
  end

end