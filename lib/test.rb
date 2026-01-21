content = File.read("./lib/varslist.rb")
FileUtils.mkdir_p("_plugin")
File.write("./_plugin/creator.rb", content)