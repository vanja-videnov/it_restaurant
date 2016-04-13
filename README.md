# it_restaurant
Ruby restaurant ordering application for waiters and managers

### Assumptions
* Ruby is installed
* Rails is installed

### Grab the code
* git clone https://github.com/vanja-videnov/it_restaurant.git
* cd it_restaurant

### Start application
* bundle install
* rails generate rspec:install
* rake db:create
* rake db:migrate
* rails server

### Basic setup
* rake it_restaurant:create_manager
* rake it_restaurant:create_waiter
* rake it_restaurant:create_basic_categories
* rake it_restaurant:create_tables
</br></br>
&ensp;<i>With this tasks you have created manager user with username(vanja@test.com) and password(123456vv), waiter user with email(sanja@test.com) and password(123456vv), two tables and two basic categories(food and drink)</i>

##### NOTE: Before using this app you should use some of the specific rake tasks (if there is appropriate) or do next tasks<br>
* Login as manager
* Create new menu and subcategories;
* Add new items


### Specific rake tasks
* <u>show all specific tasks:</u>

  rake -T it_restaurant
* <u>create waiter with email and password:</u>

 rake it_restaurant:create_waiter_with_params[email,password] </br></br>
&ensp;<i>where email is in format example@email.com and password has minimum 6 characters</i>

* <u>give specific user admin privileges:</u>

 rake it_restaurant:set_admin[email] </br></br>
&ensp;<i>where user with given email is already saved in database</i>
* <u>create new menu:</u>

 rake it_restaurant:create_menu[name] </br></br>
&ensp;<i>where name can be empty</i>

* <u>create new category for menu</u>

 rake it_restaurant:create_category[name]
