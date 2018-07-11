# frozen_string_literal: true

module SiteHealth
  # Enhance Struct to work with keywords
  class KeyStruct < Struct
    def initialize(**keyword_args)
      keyword_args.each do |key, value|
        if members.include?(key)
          self[key] = value
        else
          raise ArgumentError, "Unknown key struct member: #{key}"
        end
      end
    end
  end
end
