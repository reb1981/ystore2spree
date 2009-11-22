require File.join(File.dirname(__FILE__), '..', '..', 'helper')

class TestApplication < Test::Unit::TestCase
  def run_application(*arguments)
    original_stdout = $stdout
    original_stderr = $stderr

    fake_stdout = StringIO.new
    fake_stderr = StringIO.new

    $stdout = fake_stdout
    $stderr = fake_stderr

    result = nil
    begin
      result = Y2s::Harvestor::Application.run!(*arguments)
    ensure
      $stdout = original_stdout
      $stderr = original_stderr
    end

    @stdout = fake_stdout.string
    @stderr = fake_stderr.string

    result
  end

  def stub_options(options)
    stub(options).opts { 'Usage:' }

    stub(Y2s::Harvestor::Options).new { options }

    options
  end

  def self.should_exit_with_code(code)
    should "exit with code #{code}" do
      assert_equal code, @result
    end
  end

  context "when options indicate help usage" do
    setup do
      stub_options :show_help => true
      stub(Y2s::Harvestor::Application).new { raise "Shouldn't have made this far"}

      assert_nothing_raised do
        @result = run_application("-h")
      end
    end

    should_exit_with_code 1

    should 'should puts option usage' do
      assert_match 'Usage:', @stderr
    end

    should 'not display anything on stdout' do
      assert_equal '', @stdout.squeeze.strip
    end
  end

  context "when options indicate an invalid argument" do
    setup do
      stub_options :invalid_argument => '--invalid-argument'
      stub(Y2s::Harvestor).new { raise "Shouldn't have made this far"}

      assert_nothing_raised do
        @result = run_application("--invalid-argument")
      end
    end

    should_exit_with_code 1

    should 'display invalid argument' do
      assert_match '--invalid-argument', @stderr
    end

    should 'display usage on stderr' do
      assert_match 'Usage:', @stderr
    end

    should 'not display anything on stdout' do
      assert_equal '', @stdout.squeeze.strip
    end

  end

  context "when options are good" do
    setup do
      @options   = stub_options :spree_dir => '/path/to/spree/app',
                                :store_url => 'http://store.example.com/'
      @harvestor = "harvestor"
      stub(@harvestor).run
      stub(Y2s::Harvestor).new { @harvestor }

      assert_nothing_raised do
        @result = run_application("/path/to/spree/app", "http://store.example.com/")
      end
    end

    should_exit_with_code 0

    should "create harvestor with options" do
      assert_received(Y2s::Harvestor) {|subject| subject.new(@options) }
    end

    should "run harvestor" do
      assert_received(@harvestor) {|subject| subject.run }
    end
  end

end
