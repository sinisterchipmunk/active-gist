require 'fakeweb'

def json(name)
  File.read(File.expand_path("../fixtures/#{name}.json", File.dirname(__FILE__)))
end

FakeWeb.allow_net_connect = false
FakeWeb.register_uri(:get, 'https://username:password@api.github.com/gists', :response => json('all_gists'))
FakeWeb.register_uri(:get, 'https://username:password@api.github.com/gists/public', :response => json('public_gists'))
FakeWeb.register_uri(:get, 'https://username:password@api.github.com/gists/starred', :response => json('starred_gists'))
FakeWeb.register_uri(:get, 'https://username:password@api.github.com/gists/2', :response => json('gist_2'))
