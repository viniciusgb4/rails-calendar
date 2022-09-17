require 'system/mobile/mobile_application_system_test_case'

class CalendarMobileTest < MobileApplicationSystemTestCase
  def setup
    @user = users(:one)
    @user.confirm
    sign_in @user
  end

  test "check if show more is compacted" do
    visit root_path

    content = page.first('tr[show-more="show_more"]').evaluate_script <<-SCRIPT
            (function () {
              var element = document.getElementsByClassName('show-more__link')[0];
              var content = window.getComputedStyle( element, ':before' ).getPropertyValue('content');
          
              return content;
             })()
    SCRIPT
    assert_equal content, '"+"'

  end

end
