require File.join(File.dirname(__FILE__), '..', '..', 'helper')

class TestOptions < Test::Unit::TestCase

  def setup
  end

  def setup_options(*arguments)
    @options = Y2s::Harvestor::Options.new(arguments)
  end

  def self.for_options(*options)
    context options.join(' ') do
      setup { setup_options *options }
      yield
    end
  end

  context "default options" do
    setup { setup_options }

    should 'not have spree_dir' do
      assert ! @options[:spree_dir]
    end

    should 'not have store url' do
      assert ! @options[:store_url]
    end

    should "have environment" do
      assert_equal "development", @options[:environment]
    end

  end

  for_options '--environment', 'testing' do
    should 'have environment testing' do
      assert_equal 'testing', @options[:environment]
    end
  end

  for_options '-e', 'testing' do
    should 'have environment testing' do
      assert_equal 'testing', @options[:environment]
    end
  end

  for_options '--help' do
    should 'show help' do
      assert @options[:show_help]
    end
  end

  for_options '-h' do
    should 'show help' do
      assert @options[:show_help]
    end
  end

  for_options '--zomg-invalid' do
    should 'be an invalid argument' do
      assert @options[:invalid_argument]
    end
  end

  context "merging options" do
    should "take options from each" do
      options = Y2s::Harvestor::Options.new(["--environment", "testing"]).
        merge Y2s::Harvestor::Options.new([])
      assert_equal 'testing', options[:environment]
    end

    should "shadow options" do
      options = Y2s::Harvestor::Options.new([]).
        merge Y2s::Harvestor::Options.new(["--environment", "testing"])
      assert_equal 'testing', options[:environment]
    end
  end
end
