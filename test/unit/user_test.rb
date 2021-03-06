require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many(:user_friendships)
  should have_many(:friends)

	test "a user should enter a first name" do
  		user = User.new
  		assert !user.save
  		assert !user.errors[:first_name].empty?
  	end

  	test "a user should enter a last name" do
  		user = User.new
  		assert !user.save
  		assert !user.errors[:last_name].empty?
  	end

  	test "a user should enter a profile name" do
  		user = User.new
  		assert !user.save
  		assert !user.errors[:profile_name].empty?
  	end

  	test "a user should have a unique profile name" do
  		user = User.new
  		user.profile_name = users(:joe).profile_name
  		
        assert !user.save
  		assert !user.errors[:profile_name].empty?
  	end

    test "a user should have a profile name without spaces" do
      user = User.new(first_name: 'Joe', last_name: 'Sergeant', email: 'joe@prowlr.tv')
      user.password = user.password_confirmation = '123456'
      
      user.profile_name = "My Profile With Spaces"

      assert !user.save
      assert !user.errors[:profile_name].empty?

      assert user.errors[:profile_name].include?("must be formatted correctly")
    end

    test "a user can have a correctly formatted profile name" do 
      user = User.new(first_name: 'Joe', last_name: 'Sergeant', email: 'joe@prowlr.tv')
      user.password = user.password_confirmation = '123456'

      user.profile_name = 'joeserg1'

      assert user.valid?
    end

    test "that no error is raised when truing to access a friend list" do
      assert_nothing_raised do
        users(:jack).friends
      end
    end

    test "that creating friendships on a user works" do
      users(:jack).friends << users(:chloe)
      users(:jack).friends.reload
      assert users(:jack).friends.include?(users(:chloe))
    end

end
