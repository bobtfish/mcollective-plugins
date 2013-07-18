module MCollective
  module Agent
    # A registration agent that places information from the meta
    # registration class into a zookeeper instance.
    #
    # To get this going you need:
    #
    #  - The meta registration plugin everywhere [1]
    #  - A zookeeper instance
    #  - The zk gem installed
    #
    # The following configuration options exist:
    #  - plugin.registration.zkhosts where the zookeeper host(s) are default: localhost:2181
    #  - plugin.registration.zkpath the path name in zookeeper to store nodes under. default: /mcollective
    #
    # Released under the terms of the Apache 2 licence
    class Registration
      attr_reader :timeout, :meta

      def initialize
        @meta = {:license => "Apache 2",
          :author => "Tomas Doran <bobtfish@bobtfish.net>",
          :url => "https://github.com/puppetlabs/mcollective-plugins"}

        require 'zk'

        @timeout = 2

        @config = Config.instance

        zkhosts = @config.pluginconf["registration.zkhosts"] || "localhost:2181"
        @zkpath = @config.pluginconf["registration.zkpath"] || "/mcollective"

        Log.instance.debug("Connecting to zookeeper @ #{zkhosts} path #{@zkpath}")

    #ZK.logger = Log.instance
        @zk = ZK.new(zkhosts)
      end

      def handlemsg(msg, connection)
        Log.instance.debug("Handle message #{msg}")
        req = msg[:body]

        if (req.kind_of?(Array))
          Log.instance.warn("Got no facts - did you forget to add 'registration = Meta' to your server.cfg?");
          return nill
        end

        req[:lastseen] = Time.now.to_i

        updatetype = nil
        before = Time.now.to_f
        begin
          @zk.set("#{@zkpath}/#{req[:identity]}", "#{req[:identity]}")
          updatetype = "set"
        rescue ZK::Exceptions::NoNode
          @zk.create("#{@zkpath}/#{req[:identity]}", "#{req[:identity]}")
          updatetype = "create"
        ensure
          after = Time.now.to_f
          Log.instance.debug("Updated data for host #{req[:identity]} with #{updatetype} in #{after - before}s")
        end

        nil
      end

      def help
      end
    end
  end
end

# vi:tabstop=2:expandtab:ai:filetype=ruby

