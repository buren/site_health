require "tempfile"

module SiteHealth
  module Checkers
    class HTMLProofer < Checker
      def call
        tempfile(page.body) do |file|
          config = SiteHealth.config.html_proofer
          proofer = ::HTMLProofer.check_file(file.path, config.to_h)
          proofer.run rescue RuntimeError # NOTE: HTMLProofer raises if errors are found
          proofer.failed_tests.map do |failed_test|
            failed_test.split(".html:").last # Removes file name from error message
          end
        end
      end

      def tempfile(string)
        result = nil
        file = Tempfile.new([name, ".html"])

        begin
          file.write(string)
        ensure
          file.close
        end

        yield(file).tap { file.unlink }
      end

      def name
        "html_proofer"
      end

      def types
        %i[html]
      end
    end
  end
end
