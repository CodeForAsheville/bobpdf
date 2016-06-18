require 'capybara'
require 'capybara/webkit'
Capybara.default_driver = :webkit

class Bob
  class << self
    include Capybara::DSL

    def base_uri; "http://dev-big-old-book.pantheonsite.io"; end

    def pdf_url(url)
      basename = File.basename(url)
      `phantomjs rasterize.js '#{url}' tmp/#{basename}.pdf`
    end

    def visit_raster(url)
      visit(url)
      pdf_url(url)
    end

    def toc_links
      visit_raster(base_uri + '/re-entry-resources-for-asheville-nc')

      page.all('.entry-content a').map{ |p| p['href'] }
    end

    def toc_scrape
      toc_links.reject{ |l| l == '#' }.each do |href|
        visit_raster(href)
      end
    end
  end
end

# Bob.toc_links
# Bob.toc_scrape