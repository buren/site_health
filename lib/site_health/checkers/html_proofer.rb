# frozen_string_literal: true

require 'tempfile'
SiteHealth.require_optional_dependency('html-proofer')

module SiteHealth
  # Checks for various HTML misstakes (backed by the excellent HTMLProofer gem)
  class HTMLProofer < Checker
    name 'html_proofer'
    types 'html'

    protected

    def check
      tempfile(page.body) do |file|
        proofer = ::HTMLProofer.check_file(file.path, config.html_proofer.to_h)
        # NOTE: HTMLProofer raises if errors are found
        begin
          proofer.run
        rescue StandardError
        end

        errors = build_test_failures(proofer.failed_tests).each do |error|
          add_issue(title: error)
        end

        add_data(errors: errors)
      end
    end

    # @return [Array<String>] list failures
    def build_test_failures(failed_tests)
      failed_tests.map do |failed_test|
        next if ignore_test_failure?(failed_test)

        failed_test.split('.html:').last.strip # Removes file name from error message
      end.compact
    end

    # HTMLProofer expects internal links to be present on disk, Jekyll-style,
    # since we're checking remote pages we ignore those failures
    # @return [TrueClass, FalseClass] returns true if the failed test should be ignored
    def ignore_test_failure?(failed_test)
      return false unless config.html_proofer.ignore_missing_internal_links
      return true if failed_test.include?('internally linking to')
      return true if failed_test.include?('internal image')
      return true if failed_test.include?('internal script')

      false
    end

    # Creates a tempfile around the passed block
    # @return [Object] whatever the passed block returns
    # @yieldparam [Tempfile] the temporary file
    def tempfile(string)
      file = Tempfile.new([name, '.html'])
      begin
        file.write(string)
      ensure
        file.close
      end
      yield(file).tap { file.unlink }
    end
  end

  SiteHealth.register_checker(HTMLProofer)
end
