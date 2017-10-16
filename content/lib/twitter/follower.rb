require 'rubygems'
require 'mechanize' 

def login
  agent = WWW::Mechanize.new
  agent.user_agent_alias = 'Mac FireFox'
  page = agent.get('http://twitter.com/')
  login_form = page.forms.first
  login_form['username_or_email'] = "id" #自分のtwitter idを入力
  login_form['password'] = "pass"        #自分のパスワードを入力
  home_page = agent.submit(login_form)
  agent
end

def getcode(agent, id)
  agent = login
  page = agent.get("http://twitter.com/#{id}")
  code = (page/:link).each{|link|
    href = link[:href]
    if(href =~ /(\d+)\.rss/)
      return Regexp.last_match(1)
    end
  }
  return 0
end
def follow(agent, code)
  agent.get("http://twitter.com/friendships/create/#{code}")
end

agent = login
ARGF.each{|line|
  code = getcode(agent, line.chomp)
  follow(agent, code)
}
