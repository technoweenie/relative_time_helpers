require File.dirname(__FILE__) + '/../../../../test/test_helper'
require 'stubba'

class RelativeTimeHelpersTest < Test::Unit::TestCase
  include ActiveReload::RelativeTimeHelpers

  def setup
    @current_time_class = ActiveReload::RelativeTimeHelpers.time_class
    ActiveReload::RelativeTimeHelpers.time_class = Time
    Time.stubs(:now).returns(Time.utc(2007, 6, 1, 11))
  end
  
  def teardown
    ActiveReload::RelativeTimeHelpers.time_class = @current_time_class
  end

  def test_should_show_today
    assert_equal 'today', relative_date(Time.now.utc)
  end

  def test_should_show_yesterday
    assert_equal 'yesterday', relative_date(1.day.ago.utc)
  end
  
  def test_should_show_tomorrow
    assert_equal 'tomorrow', relative_date(1.day.from_now.utc)
  end
  
  def test_should_show_date_with_year
    assert_equal 'Nov 15th, 2005', relative_date(Time.utc(2005, 11, 15))
  end
  
  def test_should_show_date
    assert_equal 'Nov 15th', relative_date(Time.utc(2007, 11, 15))
  end
  
  def test_should_show_date_span_on_the_same_day
    assert_equal 'Nov 15th', relative_date_span([Time.utc(2007, 11, 15), Time.utc(2007, 11, 15)])
  end
  
  def test_should_show_date_span_on_the_same_day_on_different_year
    assert_equal 'Nov 15th, 2006', relative_date_span([Time.utc(2006, 11, 15), Time.utc(2006, 11, 15)])
  end
  
  def test_should_show_date_span_on_the_same_month
    assert_equal 'Nov 15th - 16th', relative_date_span([Time.utc(2007, 11, 15), Time.utc(2007, 11, 16)])
    assert_equal 'Nov 15th - 16th', relative_date_span([Time.utc(2007, 11, 16), Time.utc(2007, 11, 15)])
  end
  
  def test_should_show_date_span_on_the_same_month_on_different_year
    assert_equal 'Nov 15th - 16th, 2006', relative_date_span([Time.utc(2006, 11, 15), Time.utc(2006, 11, 16)])
    assert_equal 'Nov 15th - 16th, 2006', relative_date_span([Time.utc(2006, 11, 16), Time.utc(2006, 11, 15)])
  end
  
  def test_should_show_date_span_on_the_different_month
    assert_equal 'Nov 15th - Dec 16th', relative_date_span([Time.utc(2007, 11, 15), Time.utc(2007, 12, 16)])
    assert_equal 'Nov 15th - Dec 16th', relative_date_span([Time.utc(2007, 12, 16), Time.utc(2007, 11, 15)])
  end
  
  def test_should_show_date_span_on_the_different_month_on_different_year
    assert_equal 'Nov 15th - Dec 16th, 2006', relative_date_span([Time.utc(2006, 11, 15), Time.utc(2006, 12, 16)])
    assert_equal 'Nov 15th - Dec 16th, 2006', relative_date_span([Time.utc(2006, 12, 16), Time.utc(2006, 11, 15)])
  end
  
  def test_should_show_date_span_on_the_different_year
    assert_equal 'Nov 15th, 2006 - Dec 16th, 2007', relative_date_span([Time.utc(2006, 11, 15), Time.utc(2007, 12, 16)])
    assert_equal 'Nov 15th, 2006 - Dec 16th, 2007', relative_date_span([Time.utc(2007, 12, 16), Time.utc(2006, 11, 15)])
  end
  
  # Time, Single Date
  def test_should_show_time_span_on_the_same_day_with_same_time
    assert_equal '5:00 PM Nov 15th', relative_time_span([Time.utc(2007, 11, 15, 17, 00, 00), Time.utc(2007, 11, 15, 17, 00, 00)])
  end
  
  def test_should_show_time_span_on_the_same_day_with_same_time_on_different_year
    assert_equal '5:00 PM Nov 15th, 2006', relative_time_span([Time.utc(2006, 11, 15, 17, 0), Time.utc(2006, 11, 15, 17, 0)])
  end
  
  def test_should_show_time_span_on_the_same_day_with_different_times_in_same_half_of_day
    assert_equal '10:00 - 11:00 AM Nov 15th', relative_time_span([Time.utc(2007, 11, 15, 10), Time.utc(2007, 11, 15, 11, 0)])
  end
  
  def test_should_show_time_span_on_the_same_day_with_different_times_in_different_half_of_day
    assert_equal '10:00 AM - 2:00 PM Nov 15th', relative_time_span([Time.utc(2007, 11, 15, 10, 0), Time.utc(2007, 11, 15, 14, 0)])
  end
  
  def test_should_show_time_span_on_the_same_day_with_different_times_in_different_half_of_day_in_different_year
    assert_equal '10:00 AM - 2:00 PM Nov 15th, 2006', relative_time_span([Time.utc(2006, 11, 15, 10, 0), Time.utc(2006, 11, 15, 14, 0)])
  end
  
  def test_should_show_time_span_on_different_days_in_same_year
    assert_equal '10:00 AM Nov 15th - 2:00 PM Dec 16th, 2006', relative_time_span([Time.utc(2006, 11, 15, 10, 0), Time.utc(2006, 12, 16, 14, 0)])
  end
  
  def test_should_show_time_span_on_different_days_in_different_years
    assert_equal '10:00 AM Nov 15th, 2006 - 2:00 PM Dec 16th, 2007', relative_time_span([Time.utc(2006, 11, 15, 10, 0), Time.utc(2007, 12, 16, 14, 0)])
  end
  
  def test_should_show_time_span_on_different_days_in_current_year
    assert_equal '10:00 AM Nov 15th - 2:00 PM Dec 16th', relative_time_span([Time.utc(2007, 11, 15, 10, 0), Time.utc(2007, 12, 16, 14, 0)])
  end
  
  # prettier_time
  def test_should_not_show_leading_zero_in_hour
    assert_equal '2:00 PM', prettier_time(Time.utc(2007, 11, 15, 14, 0))
  end
  
  def test_should_convert_to_12_hour_time
    assert_equal '2:00 AM', prettier_time(Time.utc(2007, 11, 15, 2, 0))
  end
  
  def test_should_handle_midnight_correctly
    assert_equal '12:00 AM', prettier_time(Time.utc(2007, 11, 15, 0, 0))
  end
end