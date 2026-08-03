# frozen_string_literal: true

module Mercadopago
  module Pagination
    # Lazy +Enumerator+ that auto-fetches all pages from a MercadoPago search endpoint.
    #
    # @example
    #   sdk.payment.search_auto_paging_iter(status: 'approved').each do |payment|
    #     process(payment)
    #   end
    class Iterator
      include Enumerable

      DEFAULT_PAGE_SIZE = 100

      # @param search_fn [Proc] callable that accepts +filters+ and +request_options+ and
      #   returns a response hash with +:status+ and +:response+ keys
      # @param filters [Hash, nil] initial search filters; +:limit+ and +:offset+ are managed
      # @param request_options [Object, nil] per-call overrides forwarded to search_fn
      # @param limit [Integer] items per page
      def initialize(search_fn, filters: nil, request_options: nil, limit: DEFAULT_PAGE_SIZE)
        @search_fn       = search_fn
        @filters         = (filters || {}).dup
        @request_options = request_options
        @limit           = limit.to_i.positive? ? limit.to_i : DEFAULT_PAGE_SIZE
      end

      # Lazily yields each result item across all pages.
      # Compatible with +Enumerable+ (+map+, +select+, +first+, etc.).
      def each
        return enum_for(:each) unless block_given?

        offset = (@filters[:offset] || @filters['offset'] || 0).to_i

        loop do
          page_filters = @filters.merge(limit: @limit, offset: offset)
          result = @search_fn.call(page_filters, @request_options)

          body    = result.is_a?(Hash) ? (result[:response] || result['response'] || {}) : {}
          results = (body.is_a?(Hash) ? (body['results'] || body[:results]) : nil) || []
          paging  = (body.is_a?(Hash) ? (body['paging']  || body[:paging])  : nil) || {}
          total   = (paging['total'] || paging[:total] || 0).to_i

          break if results.empty?

          results.each { |item| yield item }

          offset += results.size
          break if offset >= total
        end
      end
    end
  end
end
