class Parser
  def initialize
    @url = 'http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt='
  end

  def web_search(keyword)
    doc = Nokogiri::HTML(open(@url), nil, 'utf-8')
    doc.search("//div[@class = 'm_item recette_classique']//div[@class = 'm_titre_resultat']/a").each do |el|
      @web_search << el.text
    end
  end
end

