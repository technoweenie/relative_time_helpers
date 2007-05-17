require File.dirname(__FILE__) + '/../../../../test/test_helper'

class RelativeTimeHelpersTest < Test::Unit::TestCase
  include ActiveReload::RelativeTimeHelpers

  def setup
    @current_time_class = ActiveReload::RelativeTimeHelpers.time_class
    ActiveReload::RelativeTimeHelpers.time_class = Time
  end
  
  def teardown
    ActiveReload::RelativeTimeHelpers.time_class = @current_time_class
  end

  def test_should_show_today
    assert_equal 'today', relative_time(Time.now.utc)
  end

  def test_should_show_yesterday
    assert_equal 'yesterday', relative_time(1.day.ago.utc)
  end
  
  def test_should_show_tomorrow
    assert_equal 'tomorrow', relative_time(1.day.from_now.utc)
  end
  
  def test_should_show_date_with_year
    assert_equal 'Nov 15th, 2005', relative_time(Time.utc(2005, 11, 15))
  end
  
  def test_should_show_date
    Time.stubs(:now).returns(Time.utc(2006, 6, 1, 11))
    assert_equal 'Nov 15th', relative_time(Time.utc(2006, 11, 15))
  end
  
  def test_should_show_span_on_the_same_day
    assert_equal 'Nov 15th', relative_time_span([Time.utc(2007, 11, 15), Time.utc(2007, 11, 15)])
  end
  
  def test_should_show_span_on_the_same_day_on_different_year
    assert_equal 'Nov 15th, 2006', relative_time_span([Time.utc(2006, 11, 15), Time.utc(2006, 11, 15)])
  end
  
  def test_should_show_span_on_the_same_month
    assert_equal 'Nov 15th - 16th', relative_time_span([Time.utc(2007, 11, 15), Time.utc(2007, 11, 16)])
    assert_equal 'Nov 15th - 16th', relative_time_span([Time.utc(2007, 11, 16), Time.utc(2007, 11, 15)])
  end
  
    def test_should_show_span_on_the_same_month_on_different_year
    assert_equal 'Nov 15th - 16th, 2006', relative_time_span([Time.utc(2006, 11, 15), Time.utc(2006, 11, 16)])
    assert_equal 'Nov 15th - 16th, 2006', relative_time_span([Time.utc(2006, 11, 16), Time.utc(2006, 11, 15)])
  end
  
  def test_should_show_span_on_the_different_month
    assert_equal 'Nov 15th - Dec 16th', relative_time_span([Time.utc(2007, 11, 15), Time.utc(2007, 12, 16)])
    assert_equal 'Nov 15th - Dec 16th', relative_time_span([Time.utc(2007, 12, 16), Time.utc(2007, 11, 15)])
  end
  
  def test_should_show_span_on_the_different_month_on_different_year
    assert_equal 'Nov 15th - Dec 16th, 2006', relative_time_span([Time.utc(2006, 11, 15), Time.utc(2006, 12, 16)])
    assert_equal 'Nov 15th - Dec 16th, 2006', relative_time_span([Time.utc(2006, 12, 16), Time.utc(2006, 11, 15)])
  end
  
  def test_should_show_span_on_the_different_year
    assert_equal 'Nov 15th, 2006 - Dec 16th, 2007', relative_time_span([Time.utc(2006, 11, 15), Time.utc(2007, 12, 16)])
    assert_equal 'Nov 15th, 2006 - Dec 16th, 2007', relative_time_span([Time.utc(2007, 12, 16), Time.utc(2006, 11, 15)])
  end
end