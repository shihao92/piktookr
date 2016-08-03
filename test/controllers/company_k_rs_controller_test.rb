require 'test_helper'

class CompanyKRsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_kr = company_krs(:one)
  end

  test "should get index" do
    get company_krs_url
    assert_response :success
  end

  test "should get new" do
    get new_company_kr_url
    assert_response :success
  end

  test "should create company_kr" do
    assert_difference('CompanyKr.count') do
      post company_krs_url, params: { company_kr: {  } }
    end

    assert_redirected_to company_kr_url(CompanyKr.last)
  end

  test "should show company_kr" do
    get company_kr_url(@company_kr)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_kr_url(@company_kr)
    assert_response :success
  end

  test "should update company_kr" do
    patch company_kr_url(@company_kr), params: { company_kr: {  } }
    assert_redirected_to company_kr_url(@company_kr)
  end

  test "should destroy company_kr" do
    assert_difference('CompanyKr.count', -1) do
      delete company_kr_url(@company_kr)
    end

    assert_redirected_to company_krs_url
  end
end
