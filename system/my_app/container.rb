require "dry/system/container"
require "pathname"

module MyApp
  class Container < Dry::System::Container
    configure do |config|
      config.name = :my_app
      config.default_namespace = "my_app"
      config.root = Pathname(__dir__).join("../..").realpath.to_s
      config.auto_register = %w[lib]
    end

    load_paths! "lib"
  end
end
