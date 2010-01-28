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

def link_to url_fragment, mode=:path_only
  case mode
  when :path_only
    base = request.script_name
  when :full_url
    if (request.scheme == 'http' && request.port == 80 ||
        request.scheme == 'https' && request.port == 443)
      port = ""
    else
      port = ":#{request.port}"
    end
    base = "#{request.scheme}://#{request.host}#{port}#{request.script_name}"
  else
    raise "Unknown script_url mode #{mode}"
  end
  "#{base}#{url_fragment}"
end

def update_votes_total(id)
  @total = Image.find(id).votes.sum('value')
  Image.update(id, {"vote_total" => @total})
  return true
end

def mustachify(img)

  @file = img
  @filename = img[:filename]
  @filetype = File.extname(@filename)
  @stored_name = Digest::SHA1.hexdigest(@file[:filename]+Time.now.to_s+@filename)+@filetype
  
  @manipulated = RComposite::Canvas.new(640, 480) do
    layer :file => 'public/images/mustaches/1.png' do
      offset 176, 171
    end
    layer :file => open(img[:tempfile]) do
      image.resize!(640, 480)
    end
  end
  @manipulated.save_as "./tmp/"+@stored_name
  
  return "./tmp/"+@stored_name
  
end

def h(text)
  Rack::Utils.escape_html(text)
end

