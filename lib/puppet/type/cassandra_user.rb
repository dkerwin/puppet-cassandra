require 'bcrypt'

Puppet::Type.newtype(:cassandra_user) do
  @doc = <<-EOT
    Manage cassandra user accounts with CQL statements
    
    Example:
      
      cassandra_user { 'bozo':
        admin_user => 'cassandra',
        admin_pass => 'cassandra',
        password   => '1qay2wsx',
        superuser  => true,
      }
  EOT

  def munge_boolean(value)
    case value
    when true, "true", :true
      :true
    when false, "false", :false
      :false
    else
      fail("munge_boolean only takes booleans")
    end
  end

  ensurable

  newparam(:name) do
    desc "The user account"
    newvalues(/^.+/)
    isnamevar
  end

  newparam(:admin_user) do
    desc "Admin user to required to connect to cassandra"
    newvalues(/^.+/)

    defaultto :cassandra
  end

  newparam(:admin_pass) do
    desc "Admin password to required to connect to cassandra"
    newvalues(/^.+/)

    defaultto :cassandra
  end

  newproperty(:password) do
    desc "The users password"
    newvalues(/^.+/)

    def insync?(is)
      if BCrypt::Password.new(is) == @should[0]
        return true
      else
        return false
      end
    end
    
    ## Override the @should string with the hashed version to sanitize log output
    def should_to_s(newvalue)
      return BCrypt::Password.create(newvalue)
    end
  end

  newproperty(:superuser, :boolean => true) do
    desc "Boolean flag for superuser permissions"

    newvalues(:true, :false)
    defaultto :false

    munge do |value|
      @resource.munge_boolean(value)
    end
  end
end
