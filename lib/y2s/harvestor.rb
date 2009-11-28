class Y2s

  class MissingSpreeDir < StandardError; end
  class MissingStoreUrl < StandardError; end
  class SpreeDirDoesNotExist < StandardError; end

  class Harvestor
    autoload :Application, 'y2s/harvestor/application'
    autoload :Options, 'y2s/harvestor/options'

    attr_accessor :spree_dir, :store_url, :options

    def initialize(options = {})
      self.options = options

      self.spree_dir = options[:spree_dir]
      if self.spree_dir.nil? || self.spree_dir.squeeze.strip == ""
        raise MissingSpreeDir
      end

      self.store_url = options[:store_url]
      if self.store_url.nil? || self.store_url.squeeze.strip == ""
        raise MissingStoreUrl
      end

      if !File.exist?(self.spree_dir)
        raise SpreeDirDoesNotExist
      end

    end
  end
end
