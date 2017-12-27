require 'tempfile'

module SiteHealth
	module Checkers
    class HTMLProofer < Checker
      def call
        tempfile(page.body) do |file|
          proofer = ::HTMLProofer.check_file(file.path, SiteHealth.config.html_proofer)
          proofer.run rescue RuntimeError # NOTE: HTMLProofer raises if errors are found
          proofer.failed_tests
        end
      end

      def tempfile(string)
        result = nil
        file = Tempfile.new([name, '.html'])

        begin
          file.write(string)
        ensure
          file.close
        end

        yield(file).tap { file.unlink }
      end

      def name
        'html_proofer'
      end

      def types
        %i[html]
      end
    end
  end
end