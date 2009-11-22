class Y2s
  class Harvestor
    class Options < Hash
      attr_reader :opts, :orig_args

      def initialize(args)
        super()

        @orig_args = args.clone
        self[:environment] = 'development'

        require 'optparse'
        @opts = OptionParser.new do |o|
          o.banner = <<END_OF_EXAMPLE
Usage: #{File.basename($0)} [options] path-to-spree-project url-of-ystore
e.g. #{File.basename($0)} /var/www/store/current http://store.example.com/
END_OF_EXAMPLE
          o.separator ""

          o.on('-e', '--environment [RAILS_ENV]', 'specify the Rails environment to operate within') do |environment|
            self[:environment] = environment
          end

          o.separator ""

          o.on_tail('-h', '--help', 'display this help and exit') do
            self[:show_help] = true
          end
        end

        begin
          @opts.parse!(args)
          self[:spree_dir] = args.shift
          self[:store_url] = args.shift
        rescue OptionParser::InvalidOption => e
          self[:invalid_argument] = e.message
        end
      end

      def merge(other)
        self.class.new(@orig_args + other.orig_args)
      end

    end
  end
end
