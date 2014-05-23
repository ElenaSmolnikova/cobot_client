require 'spec_helper'

describe CobotClient::NavigationLinkService, '#install_links' do
  let(:service) { CobotClient::NavigationLinkService.new(api_client, 'co-up') }
  let(:api_client) { double(:api_client) }

  context 'when there are links already' do
    before(:each) do
      api_client.stub(:get).with(
        'co-up', '/navigation_links') { [{label: 'test link'}] }
    end

    it 'installs no links' do
      api_client.should_not_receive(:post)

      service.install_links [double(:link)]
    end

    it 'returns the links' do
      expect(service.install_links([double(:link)]).map(&:label)).to eql(['test link'])
    end
  end

  context 'when there are no links installed' do
    let(:link) { double(:link, section: 'admin/manage', label: 'test link', iframe_url: '/test') }

    before(:each) do
      api_client.stub(:get).with('co-up', '/navigation_links') { [] }
    end

    it 'installs the links' do
      api_client.should_receive(:post).with('co-up', '/navigation_links', {
        section: 'admin/manage', label: 'test link', iframe_url: '/test'
      }) { {} }

      service.install_links [link]
    end

    it 'returns the links created' do
      api_client.stub(:post) { {label: 'test link'} }

      expect(service.install_links([link]).map(&:label)).to eql(['test link'])
    end
  end
end
