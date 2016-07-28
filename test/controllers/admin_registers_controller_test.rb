require 'test_helper'

class AdminRegistersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_register = admin_registers(:one)
  end

  test "should get index" do
    get admin_registers_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_register_url
    assert_response :success
  end

  test "should create admin_register" do
    assert_difference('AdminRegister.count') do
      post admin_registers_url, params: { admin_register: { avatar: @admin_register.avatar, email: @admin_register.email, name: @admin_register.name, password: @admin_register.password, password_confirmation: @admin_register.password_confirmation, role: @admin_register.role, status: @admin_register.status } }
    end

    assert_redirected_to admin_register_url(AdminRegister.last)
  end

  test "should show admin_register" do
    get admin_register_url(@admin_register)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_register_url(@admin_register)
    assert_response :success
  end

  test "should update admin_register" do
    patch admin_register_url(@admin_register), params: { admin_register: { avatar: @admin_register.avatar, email: @admin_register.email, name: @admin_register.name, password: @admin_register.password, password_confirmation: @admin_register.password_confirmation, role: @admin_register.role, status: @admin_register.status } }
    assert_redirected_to admin_register_url(@admin_register)
  end

  test "should destroy admin_register" do
    assert_difference('AdminRegister.count', -1) do
      delete admin_register_url(@admin_register)
    end

    assert_redirected_to admin_registers_url
  end
end
