# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = "hashicorp/bionic64"
  config.vm.network :forwarded_port, host: 4000, guest: 4000
  config.ssh.forward_agent = true

  config.vm.provision 'shell', inline: <<-SHELL
    apt-get update
    apt-get -y install git

    # https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
    apt-get -y install \
      autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev libdb-dev
  SHELL

  config.vm.provision 'shell', privileged: false, inline: <<-SHELL
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
    echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

    source ~/.bash_profile

    rbenv install 2.7.2
    rbenv global 2.7.2

    gem install bundler -v 1.16.1

    rbenv rehash

    cd /vagrant
    bundle install
  SHELL

  # reattach with `screen -dr`
  config.vm.provision 'shell', privileged: false, run: 'always', inline: <<-SHELL
    cd /vagrant && screen -S vagrant -d -m bundle exec jekyll serve --host 0.0.0.0 --watch --force_polling
  SHELL
end
