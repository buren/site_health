module SiteHealth
  module Checkers
    # Checks if HTML-meta description is present
    class MissingDescription < Checker
      def call
        return false if page.redirect?

        page.search("//meta").map do |meta|
          name = (meta.attributes["name"] || meta.attributes["http-equiv"]).to_s.strip
          next unless name == "description"

          return meta.attributes["content"].to_s.strip.empty?
        end

        true
      end

      def name
        "missing_description"
      end

      def types
        %i[html]
      end
    end
  end
end
