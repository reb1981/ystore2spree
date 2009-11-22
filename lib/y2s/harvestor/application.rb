class Y2s
  class Harvestor

    class Application

      class << self
        def run!(*arguments)

          env_opts = if ENV['Y2S_OPTS']
            Y2s::Harvestor::Options.new(ENV['Y2S_OPTS'].split(' '))
          end
          options = Y2s::Harvestor::Options.new(arguments)
          options = options.merge(env_opts) if env_opts

          if options[:invalid_argument]
            $stderr.puts options[:invalid_argument]
            options[:show_help] = true
          end

          if options[:show_help]
            $stderr.puts options.opts
            return 1
          end

          if options[:spree_dir].nil? || options[:spree_dir].squeeze.strip == ""
            $stderr.puts "Spree installation directory not specified"
            $stderr.puts options.opts
            return 1
          end

          if options[:store_url].nil? || options[:store_url].squeeze.strip == ""
            $stderr.puts "Yahoo Store URL not specified"
            $stderr.puts options.opts
            return 1
          end

          harvestor = Y2s::Harvestor.new(options)
          harvestor.run
          return 0

        end
      end
    end
  end
end
