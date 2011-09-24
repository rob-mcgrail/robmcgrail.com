module SolrHelpers
  def self.xml(o, h)
    record = Nokogiri::XML::Builder.new do |xml|
      xml.add(:allowDups => 'false') {
        h.each do |k,v|
          xml.field(o.__send__(v.to_sym), {:name => k.to_s})
        end
      }
    end
    record.to_xml
  end
end

