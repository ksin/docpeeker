require "docpeeker/version"
require 'nokogiri'

module Docpeeker

  RUBYDOC_URLS = {"Enumerable" => "http://www.ruby-doc.org/core-2.1.1/Enumerable.html",
                  "Array" => "http://www.ruby-doc.org/core-2.1.1/Array.html",
                  "Hash" => "http://www.ruby-doc.org/core-2.1.1/Hash.html",
                  "String" => "http://www.ruby-doc.org/core-2.1.1/String.html",
                  "Set" => "http://www.ruby-doc.org/stdlib-2.1.1/libdoc/set/rdoc/Set.html",
                  "Bignum" => "http://www.ruby-doc.org/core-2.1.1/Bignum.html",
                  "Object" => "http://www.ruby-doc.org/core-2.1.1/Object.html",
                  "Module" => "http://www.ruby-doc.org/core-2.1.1/Module.html",
                  "Class" => "http://www.ruby-doc.org/core-2.1.1/Class.html",
                  "Numeric" => "http://www.ruby-doc.org/core-2.1.1/Numeric.html",
                  "Float" => "http://www.ruby-doc.org/core-2.1.1/Float.html",
                  "File" => "http://www.ruby-doc.org/core-2.1.1/File.html",
                  "IO" => "http://www.ruby-doc.org/core-2.1.1/IO.html",
                  "Fixnum" => "http://www.ruby-doc.org/core-2.1.1/Fixnum.html",
                  "Range" => "http://www.ruby-doc.org/core-2.1.1/Range.html",
                  "Regexp" => "http://www.ruby-doc.org/core-2.1.1/Regexp.html",
                  "Symbol" => "http://www.ruby-doc.org/core-2.1.1/Symbol.html",
                  "Time" => "http://www.ruby-doc.org/core-2.1.1/Time.html"
                  }

  def self.lookup(method_name)
    end_early if method_name == (nil || '') # end program early for no arguments
    classes = match_class(method_name)
    specific_method = get_method(method_name)
    if classes.empty? # when there is no class name specified, show all pages for the method
      RUBYDOC_URLS.each do |class_name, base_url|
        show_pages(base_url, method_name, method_name)
      end
    else 
      classes.each do |class_name|
        base_url = RUBYDOC_URLS[class_name]
        show_pages(base_url, specific_method, method_name)
      end
    end
    puts "Done!"
  end

  private

  def self.end_early
    puts "You need to enter a method name. (try: docpeeker Integer#to_s // docpeeker map // docpeeker Array.slice)"
    exit
  end

  def self.match_class(method_name) # finds the class of the method_name (ie: "Array" in Array#each or Array.each)
    RUBYDOC_URLS.keys.select { |class_name| method_name.capitalize.match(/#{class_name}[\.#]/) }
  end

  def self.get_method(method_name) # finds the name of the method (ie: "each" in Array#each or Array.each)
    method_name.match(/(?!.+?[\.#])(?![\.#]).+/)
  end

  def self.show_pages(base_url, specific_method, method_name)
    page = objectify_page(base_url)
    a_array = create_a_array(page)
    method_append_pairs = pair_down_a_array(a_array)
    append = find_url_append(specific_method, method_append_pairs)
    final_url = create_final_url(base_url, append)
    method_name.capitalize! if method_name =~ /[\.#]/
    puts "Opening a tab for #{method_name}..." if open_tab(final_url)
  end

  def self.objectify_page(url)
    Nokogiri::HTML(open("#{url}"))  # => creates a nokogiri object of a url
  end

  def self.create_a_array(nokogiri_page_object)
    nokogiri_page_object.css('div#method-list-section').css('a')   # => creates an array of <a> elements(as nokogiri objects)
  end

  def self.pair_down_a_array(a_array)
    a_array.map { |a| grab_method_and_link(a) } # => reduces an array of <a> objects to sub-arrays of their method and url-append
  end

  def self.grab_method_and_link(a_object)
    [a_object.text, a_object[:href]] # => creates 2 element array of <a>'s method(as a string, without # in front) and the url-append 
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
