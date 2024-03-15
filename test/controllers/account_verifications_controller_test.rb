require "test_helper"

class AccountVerificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get confirm_email" do
    get account_verifications_confirm_email_url
    assert_response :success
  end
end
