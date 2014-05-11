require "docpeeker/version"
require 'nokogiri'

module Docpeeker

  RUBYDOC_URLS = ["http://www.ruby-doc.org/core-2.1.1/Enumerable.html",
                    "http://www.ruby-doc.org/core-2.1.1/Array.html",
                    "http://www.ruby-doc.org/core-2.1.1/Hash.html",
                    "http://www.ruby-doc.org/core-2.1.1/String.html",
                    "http://www.ruby-doc.org/stdlib-2.1.1/libdoc/set/rdoc/Set.html",
                    "http://www.ruby-doc.org/core-2.1.1/Bignum.html",
                    "http://www.ruby-doc.org/core-2.1.1/Object.html",
                    "http://www.ruby-doc.org/core-2.1.1/Module.html",
                    "http://www.ruby-doc.org/core-2.1.1/Class.html",
                    "http://www.ruby-doc.org/core-2.1.1/Numeric.html",
                    "http://www.ruby-doc.org/core-2.1.1/Float.html",
                    "http://www.ruby-doc.org/core-2.1.1/File.html",
                    "http://www.ruby-doc.org/core-2.1.1/IO.html",
                    "http://www.ruby-doc.org/core-2.1.1/Fixnum.html",
                    "http://www.ruby-doc.org/core-2.1.1/Range.html",
                    "http://www.ruby-doc.org/core-2.1.1/Regexp.html",
                    "http://www.ruby-doc.org/core-2.1.1/Symbol.html",
                    "http://www.ruby-doc.org/core-2.1.1/Time.html"
                  ]

  def self.lookup(method_name)
    RUBYDOC_URLS.each do |base_url|
      page = objectify_page(base_url)
      a_array = create_a_array(page)
      method_append_pairs = pair_down_a_array(a_array)
      append = find_url_append(method_name, method_append_pairs)
      final_url = create_final_url(base_url, append)
      puts "Opening a tab..." if open_tab(final_url)
    end
    puts "Done!"
  end

  private

  def self.objectify_page(url)
    Nokogiri::HTML(open("#{url}"))  # => creates a nokogiri object of a url
  end

  def self.create_a_array(nokogiri_page_object)
    nokogiri_page_object.css('div#method-list-section').css('a')   # => creates an array of <a> elements(as nokogiri objects)
  end

  def self.grab_method_and_link(a_object)
    [a_object.text, a_object[:href]] # => creates 2 element array of <a>'s method(as a string, without # in front) and the url-append
  end

  def self.pair_down_a_array(a_array)
    text_link_pairs = []
    a_array.each { |a| text_link_pairs << grab_method_and_link(a) } # => reduces an array of <a> objects to sub-arrays of their method and url-append
    text_link_pairs
  end

  def self.find_url_append(desired_method, method_append_pairs)
    method_append_pairs.each do |pair|
      return pair[1] if (pair[0] == "##{desired_method}")
    end
    false    
  end

  def self.create_final_url(base_url, append)
    append ? base_url + append : false
  end

  def self.open_tab(url)
    `open #{url};` if url
  end
end
