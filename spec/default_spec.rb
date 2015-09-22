require 'spec_helper'


describe 'guacamole::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(file_cache_path: '/var/chef/cache', log_level: :debug).converge(described_recipe) }
  it 'should include tomcat recipe by default' do
    expect(chef_run).to include_recipe'guacamole::tomcat'
  end
  it 'creates a libtelnet-0.20-2.el6.x86_64.rpm' do
    expect(chef_run).to create_remote_file_if_missing('/var/chef/cache/libtelnet-0.20-2.el6.x86_64.rpm')
    expect(chef_run).to create_remote_file_if_missing('/var/chef/cache/libtelnet-devel-0.20-2.el6.x86_64.rpm')
  end
end
