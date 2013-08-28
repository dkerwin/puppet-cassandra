require 'cql'

module Puppet
  module Util
    module Cassandra
      class CQL

        def initialize(resource)
          @resource = resource
          
          Puppet.debug "Cassandra API initialized"

          unless @client
            @client = Cql::Client.connect(host: '127.0.0.1', credentials: {username: @resource[:admin_user], password: @resource[:admin_pass]})
            @client.use('system_auth')
          end
        end

        def run(statement)
          @client.execute(statement)
        end
      end
    end
  end
end
