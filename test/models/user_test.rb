require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new( nickname: "user_nickname", 
                      email: "user@mail.com",
                      password: "password",
                      password_confirmation: "password",
                      introduction: "introduction",
                      icon_image_id: "icon_image_id",
                      deleted: true
                    )
  end

  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.nickname = "     "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.nickname = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 247 + "@mail.com"
    assert_not @user.valid?
  end
  
   test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    user = @user.dup
    # user.email = @user.email.upcase
    # データベースに設定したので削除
    @user.save
    assert_not user.valid?
  end
  
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
