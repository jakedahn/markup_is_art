def get_flash
  flash = request.cookies["flash"]
  response.delete_cookie("flash")
  return flash  
end

def set_flash(message)
  response.set_cookie("flash", :value => message, :path => '/')
end

def partial(template, *args)
  options = args.extract_options!
  options.merge!(:layout => false)
  if collection = options.delete(:collection) then
    collection.inject([]) do |buffer, member|
      buffer << haml(template, options.merge(
                                :layout => false, 
                                :locals => {template.to_sym => member}
                              )
                   )
    end.join("\n")
  else
    haml(template, options)
  end
end

def mustachify(img)

  @file = img
  @filename = img[:filename]
  @filetype = File.extname(@filename)
  @stored_name = Digest::SHA1.hexdigest(@file[:filename]+Time.now.to_s+@filename)+@filetype
    
  dst = Magick::Image.read(open(img[:tempfile])) {self.size = "640x480"}.first
  src = Magick::Image.read('public/images/mustaches/1.png') {self.size = "284x140"}.first

  result = dst.composite(src, Magick::CenterGravity, Magick::OverCompositeOp)
  result.write("./tmp/"+@stored_name)
    
  return "./tmp/"+@stored_name
  
end

def h(text)
  Rack::Utils.escape_html(text)
end

