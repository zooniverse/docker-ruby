require 'erb'
require 'yaml'

task default: :create

default_ruby_build_release = 'v20170405'
default_base_image = 'ubuntu:14.04'

default_deps = %W(wget
                  build-essential
                  ca-certificates)

mri_deps = %W(autoconf
              bison
              libssl-dev
              libyaml-dev
              libreadline6-dev
              zlib1g-dev
              libncurses5-dev)

jruby_deps = %W(openjdk-7-jre-headless)

ruby_version = nil
add_deps = nil
add_gems = nil
base_image = nil
config_opts = nil
ruby_build_release = nil

task :config do
  if config = ENV.has_key?('file') ? YAML.load(File.read(ENV['file'])) : nil
    ruby_version = config['ruby']
    add_deps = config['deps'] || []
    add_gems = config['gems'] || []
    base_image = config['base_image'] || default_base_image
    config_opts = config['build_opts'] || []
    ruby_build_release = config['ruby_build_release'] || default_ruby_build_release

    next unless config.empty?
  end

  ruby_version = ENV['ruby']
  add_deps = ENV['deps']
  add_gems = ENV['gems']
  base_image = ENV['base_image']
  config_opts = ENV['build_opts']
  ruby_build_release = ENV['ruby_build']

  unless ruby_version
    print 'Enter ruby version: '
    ruby_version = STDIN.gets.chomp
  end

  unless add_deps
    print 'Enter additional dependencies: '
    add_deps = STDIN.gets.chomp
  end

  unless add_gems
    print 'Enter additional gems: '
    add_gems = STDIN.gets.chomp
  end

  unless base_image
    print "Enter base docker image [#{ default_base_image }]: "
    base_image = STDIN.gets.chomp
    base_image = default_base_image if base_image.empty?
  end

  unless ruby_build_release
    print "Enter ruby build release [#{ default_ruby_build_release }]: "
    ruby_build_release = STDIN.gets.chomp
    ruby_build_release = default_ruby_build_release if ruby_build_release.empty?
  end

  unless config_opts
    print "Enter ruby build configuration options: "
    config_opts = STDIN.gets.chomp
  end

  add_deps = add_deps.split(/,?\s+/)
  add_gems = add_gems.split(/,?\s+/)
  config_opts = config_opts.split(/,?\s+/)
end

task :create => [:config, :compile_docker] do
  sh "mkdir -p #{ ruby_version }"
  sh "mv Dockerfile #{ ruby_version }"
end

task :compile_docker do
  deps = default_deps | add_deps
  if ruby_version.match(/jruby/) && deps.select{ |dep| dep.match(/jdk/) }.empty?
    deps.concat(jruby_deps)
  else
    deps.concat(mri_deps)
  end

  build_opts = OpenStruct.new(ruby: ruby_version,
                              dependencies: deps.join(' '),
                              gems: add_gems.join(' '),
                              image: base_image,
                              ruby_build: ruby_build_release,
                              opts: config_opts.map{|opt| "--#{opt}"}.join(' '))

  dockerfile = ERB.new(File.read("./Dockerfile.erb"))
               .result(build_opts.instance_eval { binding })

  File.open('Dockerfile', 'w') do |file|
    file.write dockerfile
  end
end

task :build => [:create] do
  sh "cd #{ ruby_version }/ && sudo docker build -t #{ ENV['hub_name'] }/ruby:#{ ruby_version } ."
end

task :deploy do
  sh "sudo docker push #{ ENV['hub_name'] }/ruby"
end
