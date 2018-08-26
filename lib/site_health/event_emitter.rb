# frozen_string_literal: true

module SiteHealth
  module EventEmitter
    # Returns an event emitter class with given event names
    # @return [Object] the event emitter class
    # @param [String, Symbol] event_names
    # @example Simple event emitter
    #    class CrawlEvent < EventEmitter.define(:found_url, :page_title)
    #    end
    #
    #    event = CrawlEvent.new do |on|
    #      on.every_found_url { {|url| puts "Found URL: #{url}" }
    #      on.every_page_title { {|title| puts "Page title: #{title}" }
    #      # you can add multiple blocks
    #      on.every_page_title do |title|
    #        puts "[WARNING] Title too long!: #{title}" if title.length > 155
    #      end
    #    end
    #
    #    event.emit_page_title(page_title)
    #    event.emmit_found_url(url)
    def self.define(*event_names)
      # rubocop:disable Metrics/BlockLength
      Class.new do
        def initialize
          yield(self) if block_given?
        end

        define_method(:events) { event_names }

        event_names.each do |name|
          define_method(:emit) do |*args|
            public_send("emit_#{args.shift}", *args)
          end

          define_method("emit_#{name}") do |*args|
            blocks_for(name).each { |block| block.call(*args) }
          end

          define_method(:emit_each) do |*args|
            public_send("emit_each_#{args.shift}", *args)
          end

          define_method("emit_each_#{name}") do |array|
            blocks_for(name).each do |block|
              array.each { |o| block.call(o) }
            end
          end

          define_method("every_#{name}") do |*_args, &block|
            raise(ArgumentError, 'block must be given!') unless block
            blocks_for(name) << block
          end

          define_method(:blocks_for) do |block_name|
            variable_name = "@#{block_name}_blocks"
            if value = instance_variable_get(variable_name)
              value
            else
              instance_variable_set(variable_name, [])
            end
          end
        end
      end
      # rubocop:enable Metrics/BlockLength
    end
  end
end
