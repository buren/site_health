require "tempfile"

module SiteHealth
  module Checkers
    # Checks for various HTML misstakes (backed by the excellent HTMLProofer gem)
    class HTMLProofer < Checker
      def call
        tempfile(page.body) do |file|
          proofer = ::HTMLProofer.check_file(file.path, config.html_proofer.to_h)
          proofer.run rescue RuntimeError # NOTE: HTMLProofer raises if errors are found
          build_test_failures(proofer.failed_tests)
        end
      end

      def build_test_failures(failed_tests)
        failed_tests.map do |failed_test|
          # HTMLProofer expects internal links to be present on disk, Jekyll-style,
          # since we're checking remote pages we ignore those failures
          if config.html_proofer.ignore_missing_internal_links &&
             (failed_test.include?("internally linking to") ||
             failed_test.include?("internal image"))
            next
          end

          failed_test.split(".html:").last.strip # Removes file name from error message
        end.compact
      end

      def tempfile(string)
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
