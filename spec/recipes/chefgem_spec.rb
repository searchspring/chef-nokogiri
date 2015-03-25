require_relative '../spec_helper'

describe 'nokogiri::chefgem' do
  before do
  end
  platforms = {
    'centos-6.5' => {
      :platform_family => 'rhel',
    },
    'amazon' => {
      :platform_family => 'rhel',
    },
    'ubuntu-12.04' => {
      :platform_family => 'debian',
    }
  }
  platforms.each do |platform,data|
    (os,version) = platform.split('-')
    context "On #{os} #{version}" do
      let(:chef_run) do
        runner = ChefSpec::SoloRunner.new
        runner.node.set[:platform] = os
        runner.node.set[:version] = version
        runner.node.set[:platform_family] = data[:platform_family]
        runner.converge(described_recipe) 
      end

      it "should include_recipe build-essential" do
        expect(chef_run).to include_recipe "build-essential"
      end
      it "should include_recipe libxml2" do
        expect(chef_run).to include_recipe "libxml2"
      end
      it "should chef_gem install nokogiri" do
        expect(chef_run).to install_chef_gem 'nokogiri'
      end
    end
  end
  context "On debian based systems" do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(
        :platform => "ubuntu",
        :version => "12.04"
      )
      runner.converge(described_recipe)
    end

    it "should install zlib1g-dev" do
      expect(chef_run).to install_package "zlib1g-dev"
    end
  end
end
