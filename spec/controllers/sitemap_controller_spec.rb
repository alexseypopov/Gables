require 'spec_helper'

describe SitemapController do
  before(:all) do
    Region.seed
    Vaultware.import(Rails.root.join("spec/lib/test.xml"))
  end

  context '#sitemap' do
    it 'should not crash' do
      get 'show', :format => :xml
      response.should be_success
    end
  end
end
