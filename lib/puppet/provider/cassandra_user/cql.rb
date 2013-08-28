require 'puppet/provider/cassandra'

Puppet::Type.type(:cassandra_user).provide(:cql, :parent => Puppet::Provider::Cassandra) do
  desc "Manage Cassandra user accounts via CQL"

  def exists?
    client.run('list users').each do |u|
      return true if u['name'] == @resource[:name]
    end
    return false
  end

  def create
    client.run("CREATE USER #{@resource[:name]} WITH PASSWORD '#{@resource[:password]}'")
  end

  def destroy
    client.run("DROP USER #{@resource[:name]}")
  end

  def password
    client.run("SELECT salted_hash FROM credentials WHERE username = '#{@resource[:name]}'").entries[0]['salted_hash']
  end

  def password=(p)
    client.run("ALTER USER #{@resource[:name]} WITH PASSWORD '#{@resource[:password]}'")
  end

  def superuser
    client.run('list users').each do |u|
      return u['super'].to_s.to_sym if u['name'] == @resource[:name]
    end
  end

  def superuser=(s)
    flag = case s
      when :true then 'SUPERUSER'
      when :false then 'NOSUPERUSER'
    end

    client.run("ALTER USER #{@resource[:name]} #{flag}")
  end
end

