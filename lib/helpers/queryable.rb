module Queryable
  # Adapting `build_query` to encode nested fields also
  # Reference https://apidock.com/rails/ActiveSupport/CoreExtensions/Hash/to_query
  def build_query(params, namespace = nil)
    query_string = params.collect do |key, value|
                     value.is_a?(Hash) ? build_query(value, key) : (namespace ? "#{namespace}[#{key}]" : "#{key}=#{value}" )
                   end.flatten.sort * "&"
    URI.escape(query_string)
  end

  # In order to search customer using metatada, the query string must be
  # something like that: metadata.user_name=xxx&metadata.user_nickname=adams.
  def sanitize_query(query)
    query.gsub('[', '.').gsub(']', '')
  end
end
