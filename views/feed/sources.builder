xml.instruct! :xml, version: "1.0", encoding: "utf-8"
xml.feed xmlns: "http://www.w3.org/2005/Atom" do
  xml.title       "New MCG Sources"
  xml.description "http://mcg.herokuapp.com/の新着ソース"
  xml.link        "http://mcg-source-list.herokuapp.com/"
  xml.link        "http://mcg-source-list.herokuapp.com/feed/sources.atom", rel: "self"
  xml.id          "http://mcg-source-list.herokuapp.com/feed/sources.atom"
  xml.updated     Time.now.xmlschema

  sources.each do |source|
    xml.entry do
      xml.title   source.title
      xml.link    href: source.mcg_url
      xml.updated source.created_at.xmlschema
      xml.id      source.mcg_url
    end
  end
end
