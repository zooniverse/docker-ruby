require 'erb'
require 'json'

task default: :build

default_deps = %W(git-core
                  curl
                  ca-certificates
                  autoconf
                  bison
                  build-essential
                  libssl-dev
                  libyaml-dev
                  libreadline6-dev
                  zlib1g-dev
                  libncurses5-dev)

def conf
  @conf ||= JSON.parse(File.read('./.config'))
end

def ruby_version
  @ruby_version ||= (ENV['ruby'] || conf['default_ruby'])
end

task :config do
  if File.exist?('.config')
    puts 'This will overwrite your existing .config file'
  end
  
  print 'Enter your docker hub username: [zooniverse] '
  name = STDIN.gets.chomp
  
  print 'Enter your default ruby version: [2.1.2] '
  version = STDIN.gets.chomp

  print 'Enter additional dependencies: []'
  deps = STDIN.gets.chomp
  
  name = 'zooniverse' if name.empty?
  version = '2.1.2' if version.empty?
  deps = deps.split(/,?\s+/)
  
  config_path = File.expand_path('./.config')
  File.open(config_path, 'w') do |file|
    file.write({username: name,
                default_ruby: version,
                dependencies:  deps}.to_json)
  end
  puts '.config file saved'
end

task :build => [:compile_docker] do
  sh "sudo docker build -t #{ conf['username'] }/ruby:#{ ruby_version } ."
  sh "rm Dockerfile"
end

task :compile_docker do
  unless ruby_version
    raise StandardError.new("Please specify a ruby version") 
  end

  deps = default_deps | conf['dependencies']
  if ruby_version.match(/jruby/) && deps.select{ |dep| dep.match(/jdk/) }.empty?
    deps.push('openjdk-7-jre')
  end

  build_opts = OpenStruct.new(ruby: ruby_version,
                              dependencies: deps.join(' '))
  
  dockerfile = ERB.new(File.read("./Dockerfile.erb"))
    .result(build_opts.instance_eval { binding })

  File.open('Dockerfile', 'w') do |file|
    file.write dockerfile
  end
end

task :deploy do
  sh "sudo docker push #{ conf['username'] }/ruby"
end
