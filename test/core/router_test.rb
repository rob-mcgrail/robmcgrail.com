require 'test/unit'
require File.dirname(__FILE__) + '/fixtures/testing_controller.rb'

class RouterTest < Test::Unit::TestCase

  def setup
    R.add 'test', 'TestingController#basic', 'basic'
    R.add 'testing/:cat/:year', 'TestingController#params_test', 'params_test'
  end

  def test_takes_and_retrieves_static_url
    assert_equal 'abcd', R.connect('/test')
  end

  def test_creates_static_url_url_helper
    assert_equal '/test', R.basic_url
  end

  def test_retrieves_static_url_with_trailing_slash
    assert_equal 'abcd', R.connect('/test/')
  end

  def test_handles_slashes_in_static_urls
    R.add 'test/thing/another/many', 'TestingController#basic', 'basic'
    assert_equal 'abcd', R.connect('/test/thing/another/many')

    R.add 'test/thing/another', 'TestingController#basic', 'basic'
    assert_equal 'abcd', R.connect('/test/thing/another')

    R.add 'test/thing', 'TestingController#basic', 'basic'
    assert_equal 'abcd', R.connect('/test/thing')
  end

  def test_not_fussy_about_prefixed_slashes
    assert_equal 'abcd', R.connect('/test')

    assert_equal 'abcd', R.connect('test')

    assert_equal '/test', R.basic_url

    R.add '/anothertest', 'TestingController#basic', 'basic'
    assert_equal 'abcd', R.connect('/anothertest')

    R.add '/anothertest', 'TestingController#basic', 'basic'
    assert_equal 'abcd', R.connect('anothertest')

    R.add '/anothertest', 'TestingController#basic', 'basic'
    assert_equal '/anothertest', R.basic_url
  end

  def test_handles_homepage_urls
    R.add '/', 'TestingController#home', 'home'

    assert_equal 'home', R.connect('/')
    assert_equal 'home', R.connect('')
    assert_equal '/', R.home_url
  end

  def test_handles_special_characters_in_static_urls
    R.add '/a//b/', 'TestingController#basic', 'x'
    assert_equal 'abcd', R.connect('/a//b/')

    R.add 'x+y', 'TestingController#basic', 'x'
    assert_equal 'abcd', R.connect('/x+y')

    R.add 'x&y', 'TestingController#basic', 'x'
    assert_equal 'abcd', R.connect('/x&y')

    R.add '--', 'TestingController#basic', 'x'
    assert_equal 'abcd', R.connect('/--')

    R.add '__', 'TestingController#basic', 'x'
    assert_equal 'abcd', R.connect('/__')

    R.add '??', 'TestingController#basic', 'x'
    assert_equal 'abcd', R.connect('/??')

    R.add '**', 'TestingController#basic', 'x'
    assert_equal 'abcd', R.connect('/**')
  end

  def test_understands_params
    assert_equal 'things and 2010', R.connect('/testing/things/2010')
  end

  def test_not_fussy_about_prefixed_slashes_for_params
    assert_equal 'things and 2010', R.connect('/testing/things/2010')

    assert_equal 'things and 2010', R.connect('testing/things/2010')
  end

  def test_retrieves_dynamic_url_with_trailing_slash
    assert_equal 'things and 2010', R.connect('/testing/things/2010/')
  end

  def test_handles_static_slashes_in_dynamic_urls
    R.add 'test/thing/another/many/:cat/:year', 'TestingController#params_test', 'params_test'
    assert_equal 'things and 2010', R.connect('/test/thing/another/many/things/2010')

    R.add 'test/thing/another/:cat/:year', 'TestingController#params_test', 'params_test'
    assert_equal 'things and 2010', R.connect('/test/thing/another/things/2010')

    R.add 'test/thing/:cat/:year', 'TestingController#params_test', 'params_test'
    assert_equal 'things and 2010', R.connect('/test/thing/things/2010')
  end


  def test_url_helpers_with_params
    assert_equal '/testing/things/2010', R.params_test_url(:cat => 'things', :year => 2010)
  end

  def test_handles_special_characters_in_dynamic_urls
    assert_equal 'a+b and a+b', R.connect('/testing/a+b/a+b')
    assert_equal 'a&b and a&b', R.connect('/testing/a&b/a&b')
    assert_equal 'a-b and a-b', R.connect('/testing/a-b/a-b')
    assert_equal 'a_b and a_b', R.connect('/testing/a_b/a_b')
    assert_equal 'a?b and a?b', R.connect('/testing/a?b/a?b')
    assert_equal 'a*b and a*b', R.connect('/testing/a*b/a*b')
  end
end

