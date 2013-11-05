require 'fakeweb'

def json(name)
  File.read(File.expand_path("../fixtures/#{name}.json", File.dirname(__FILE__)))
end

RSpec.configure do |c|
  c.before { FakeWeb.allow_net_connect = false }
  c.after  { FakeWeb.allow_net_connect = true  }
end

FakeWeb.register_uri(:get, 'https://username:password@api.github.com/gists', :response => json('all_gists'))
FakeWeb.register_uri(:get, 'https://username:password@api.github.com/gists/public', :response => json('public_gists'))
FakeWeb.register_uri(:get, 'https://username:password@api.github.com/gists/starred', :response => json('starred_gists'))
FakeWeb.register_uri(:get, 'https://username:password@api.github.com/gists/2', :response => json('gist_2'))
FakeWeb.register_uri(:post, 'https://username:password@api.github.com/gists', :response => json('new_gist'))
FakeWeb.register_uri(:get, 'https://username:password@api.github.com/gists/1', :response => json('gist_1_newer'))
FakeWeb.register_uri(:patch, 'https://username:password@api.github.com/gists/1', :response => json('gist_1_updated'))
FakeWeb.register_uri(:get, 'https://username:password@api.github.com/gists/2/star', :response => json('gist_2_star'))
FakeWeb.register_uri(:get, 'https://username:password@api.github.com/gists/1/star', :response => json('gist_1_star'))
FakeWeb.register_uri(:put, 'https://username:password@api.github.com/gists/2/star', :response => json('gist_put_star'))
FakeWeb.register_uri(:delete, 'https://username:password@api.github.com/gists/1/star', :response => json('gist_delete_star'))
FakeWeb.register_uri(:delete, 'https://username:password@api.github.com/gists/1', :response => json('gist_destroy'))
FakeWeb.register_uri(:post, 'https://username:password@api.github.com/gists/1/fork', :response => json('gist_forked'))
