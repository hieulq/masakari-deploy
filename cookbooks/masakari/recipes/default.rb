git "/home/stack/masakari" do
  repository 'https://github.com/ntt-sic/masakari.git'
  user 'stack'
  group 'stack'
  action :checkout
end

user "openstack" do
  supports :manage_home => true
  comment 'required by masakari'
  home '/home/openstack'
  shell '/bin/bash'
  action :create
end

template "/etc/sudoers.d/openstack" do
  source 'sudoers.d.openstack.erb'
  mode '0440'
  owner 'root'
  group 'root'
end

case node[:platform]
when 'ubuntu', 'debian'
  %w{git python-daemon dpkg-dev debhelper}.each do |pkg|
    package pkg do
      action :install
    end
  end

  execute "masakari-controller_1.0.0-1_all.deb" do
    command 'sudo ./debian/rules binary'
    cwd '/home/stack/masakari/masakari-controller'
    creates '/home/stack/masakari/masakari-controller_1.0.0-1_all.deb'
  end

  execute "masakari-hostmonitor_1.0.0-1_all.deb" do
    command 'sudo ./debian/rules binary'
    cwd '/home/stack/masakari/masakari-hostmonitor'
    creates '/home/stack/masakari/masakari-hostmonitor_1.0.0-1_all.deb'
  end

  execute "masakari-instancemonitor_1.0.0-1_all.deb" do
    command 'sudo ./debian/rules binary'
    cwd '/home/stack/masakari/masakari-instancemonitor'
    creates '/home/stack/masakari/masakari-instancemonitor_1.0.0-1_all.deb'
  end

  execute "masakari-processmonitor_1.0.0-1_all.deb" do
    command 'sudo ./debian/rules binary'
    cwd '/home/stack/masakari/masakari-processmonitor'
    creates '/home/stack/masakari/masakari-processmonitor_1.0.0-1_all.deb'
  end
when 'redhat', 'centos'
end