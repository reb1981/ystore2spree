require File.join(File.dirname(__FILE__), '..', 'helper')
require 'tmpdir'

class TestHarvestorInitialization < Test::Unit::TestCase

  context "without spree dir set" do
    should 'raise a MissingSpreeDir' do
      assert_raise Y2s::MissingSpreeDir do
        Y2s::Harvestor.new(:store_url => "http://example.com")
      end
    end
  end

  context "without store url set" do
    should 'raise a MissingStoreUrl' do
      assert_raise Y2s::MissingStoreUrl do
        Y2s::Harvestor.new(:spree_dir => "/tmp/store")
      end
    end
  end

  context "spree dir does not exist" do

    setup do
      @tmpdir = Dir.mktmpdir # in ruby 1.8.7
      @fauxdir = "#{@tmpdir}xyz"
    end

    teardown do
      Dir.rmdir(@tmpdir)
    end

    should 'raise a SpreeDirDoesNotExist' do
      assert_raise Y2s::SpreeDirDoesNotExist do
        Y2s::Harvestor.new(:store_url => "http://example.com", :spree_dir => @fauxdir)
      end
    end
  end
end
