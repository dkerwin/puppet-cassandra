require 'puppet/util/cassandra/cql'

class Puppet::Provider::Cassandra < Puppet::Provider

  attr_reader :client

  ## Class method. Required to work from prefetch 
  def self.client(resource=@resource)
    @api ||= Puppet::Util::Cassandra::CQL.new(resource)
  end

  ## Instance method. Wrapper around the class method
  def client
    ## @resource is filled when child class is initiated
    self.class.client(@resource)
  end
end
