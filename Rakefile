require 'erb'
require 'json'

task default: :build

default_deps = %W(git-core
                  curl
                  build-essential)

mri_deps = %W(autoconf
              bison
              libssl-dev
              libyaml-dev
              libreadline6-dev
              zlib1g-dev
              libncurses5-dev)

jruby_deps = %W(openjdk-7-jre)

ruby_version = nil
add_deps = nil

add_gems = nil

task :config do
  ruby_version = ENV['ruby']
  add_deps = ENV['deps']
  add_gems = ENV['gems']
  
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
    add_gems= STDIN.gets.chomp
  end
  
  add_deps = add_deps.split(/,?\s+/)
  add_gems = add_gems.split(/,?\s+/)
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
                              gems: add_gems.join(' '))
  
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
