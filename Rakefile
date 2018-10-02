if ENV['RACK_ENV']
#in docker

else
#in host

  Name=File.basename(Dir.pwd)
  def docker_run(env=ENV['DOCKER_OPT'])%(docker run --rm -it -v "#{Dir.pwd}":/#{Name} -w /#{Name} -e GITHUB_TOKEN=#{ENV["GITHUB_TOKEN"]} -e RACK_ENV=development #{env} golang:latest);end

  desc "run 'release' in docker"
  task :release do
    sh("#{docker_run} ./bin/release.sh")
  end

  desc "run 'bash' in docker"
  task :bash  do |task, args|
    sh("#{docker_run} /bin/bash")
  end

end
