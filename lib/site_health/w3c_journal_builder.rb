module SiteHealth
  W3CJournal = KeyStruct.new(
    :message,
    :value,
    :source,
    :type,
    :explanation,
    :parent,
    :line,
    :context,
    :element,
    :error?,
    :warning?,
    :col,
    :message_id,
    :message_count,
    :skipped_string
  )

  module W3CJournalBuilder
    # @param [W3CValidators::Result]
    # @return [W3CJournal]
    def self.build(result)
      W3CJournal.new(
        message: (result.message || "").strip,
        value: result.value,
        source: result.source,
        type: result.type,
        explanation: result.explanation,
        parent: result.parent,
        line: result.line,
        context: result.context,
        element: result.element,
        error?: result.is_error?,
        warning?: result.is_warning?,
        col: result.col,
        message_id: result.message_id,
        message_count: result.message_count,
        skipped_string: result.skippedstring
      )
    end
  end
end