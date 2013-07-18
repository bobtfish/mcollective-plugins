metadata    :name        => "zookeeper",
            :description => "Zookeeper based discovery for databases built using registration",
            :author      => "Tomas Doran <bobtfish@bobtfish.net>",
            :license     => "ASL 2.0",
            :version     => "0.1",
            :url         => "http://marionette-collective.org/",
            :timeout     => 0

discovery do
    capabilities [:identity]   # TODO: [:classes, :facts, :identity, :agents]
end

