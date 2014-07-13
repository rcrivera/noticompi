class HomeController < ApplicationController
	require 'open-uri'
  
  def index

		primerahora = Nokogiri::HTML(open("http://www.primerahora.com/ultimas-noticias/"))
		primerahora.encoding = 'utf-8'
		primerahora_raw_articles = primerahora.css('article.activity')

		@articles = Array.new
		primerahora_raw_articles.each do |raw_article|
			article = Article.new
			article.title = raw_article.css('span.burbuja/@title').to_s[0...-8]
			article.summary = raw_article.css('a.c01').text.to_s
			article.url = "http://www.primerahora.com" + raw_article.css('figure/a/@href').to_s
			
			date = raw_article.css('div.container/span').text.match(/..\/..\/..../).to_s
			time = raw_article.css('div.container/span').text.match(/..:.. .\..\./).to_s
 			hour = time[0..1].to_i
 			if time[6..9] == 'p.m.'
 				hour+=12
 			end

 			article.date = DateTime.new(date[6..9].to_i, date[0..1].to_i, date[3..4].to_i, hour, time[3..4].to_i, 0,'+4')

 			article.image_url = raw_article.css('img/@src').to_s
 			puts article.image_url


			# puts d.strftime("%c")
			
			@articles << article
		end
  end
end

# :title, :url, :date, :summary, :image_url, :source_icon_url

# <article class="activity">
#   <figure class="threecol"><a href="/noticias/policia-tribunales/nota/arrestanpadreporpresuntoincestocontrasuhijaenutuado-1022024/"><img src='http://receph.apextech.netdna-cdn.com/images/tnph3/140/119/1/1/140/119/2014/07/12/abuso-sexual140211.jpg' width="135px" height="115px" alt=""></a></figure>
#   <section class="eightcol last">
#     <div class="container">
#       <h5 style="background-color:#FFF029 !important">Policía y Tribunales</h5>
#       <span>Por Primerahora.com
#       | 07/12/2014  02:51 p.m.</span> <span class="bubbleComments burbuja comments" id='bubble1022024' rel='noticias' title='Arrestan padre por presunto incesto contra su hija en Utuado-1022024'></span>  
#     </div>
#     <h2><a href="/noticias/policia-tribunales/nota/arrestanpadreporpresuntoincestocontrasuhijaenutuado-1022024/">Arrestan padre por presunto incesto contra su hija en Utuado</a></h2>
#     <p><a href="/noticias/policia-tribunales/nota/arrestanpadreporpresuntoincestocontrasuhijaenutuado-1022024/" class="c01">Según informes preliminares, la menor pudo haber sido víctima de abuso desde los 7 años.</a></p>
#   </section>
# </article>

