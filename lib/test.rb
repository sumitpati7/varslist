content = File.read("./lib/varslist.rb")
Dir.mkdir("_plugin") unless File.exist?("_plugin")
File.open("./_plugin/creator.rb","w+") { |f| f.write(content) }