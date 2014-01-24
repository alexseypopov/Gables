base_url = "http://#{request.host_with_port}"
xml.instruct! :xml, :version=>'1.0'
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  @models.each do |model|
    xml.url {
      xml.lastmod model.updated_at.iso8601

      case model
      when Floorplan
        xml.loc floorplan_url(model)
      when Property
        xml.loc property_url(model)
      when Region
        xml.loc find_where_url(:query => model.name)
      end
    }
  end
end
