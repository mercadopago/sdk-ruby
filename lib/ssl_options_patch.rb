# This is a workaround for issue #9450 in Ruby core
# https://bugs.ruby-lang.org/issues/9450
#
# Add an :ssl_options accessor to Net::HTTP, which controls the options
# attribute on the resulting SSLContext. This allows the user to customize
# behavior of SSL connections, like disabling specific protocol versions.

require 'net/http'

(Net::HTTP::SSL_IVNAMES << :@ssl_options).uniq!
(Net::HTTP::SSL_ATTRIBUTES << :options).uniq!

Net::HTTP.class_eval do
  attr_accessor :ssl_options
end
