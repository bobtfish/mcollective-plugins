module MCollective
  class Discovery
    class Zookeeper 
      require 'zk'

      class << self
        def discover(filter, timeout, limit=0, client=nil)
          config = Config.instance

          zkhosts = config.pluginconf["registration.zkhosts"] || "localhost:2181"
          zkpath = config.pluginconf["registration.zkpath"] || "/mcollective"
          newerthan = Time.now.to_i - Integer(config.pluginconf["registration.criticalage"] || 3600)

          zk = ::ZK.new(zkhosts)

          zk.children(zkpath)
        end
      end
    end
  end
end

