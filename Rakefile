require 'tmpdir'
require 'jekyll'
require 'net/http'
require 'json'
require 'shellwords'
require 'rubocop/rake_task'

CONFIG = {
  'layouts' => '_layouts',
  'posts' => 'src/_posts',
  'post_ext' => 'md',
  'github_repo' => 'christophermanning/christophermanning.github.io'
}

RuboCop::RakeTask.new

task default: [:rubocop]

# https://github.com/plusjade/jekyll-bootstrap/blob/master/Rakefile
# Usage: rake post title="A Title" [date="2012-02-09"] [tags=[tag1, tag2]]
desc "Begin a new post in #{CONFIG['posts']}"
task :post do
  unless FileTest.directory?(CONFIG['posts'])
    abort("rake aborted: '#{CONFIG['posts']}' directory not found.")
  end
  title = ENV['title'] || 'new-post'
  tags = ENV['tags'] || '[]'
  slug = title.downcase.strip.tr(' ', '-').gsub(/[^\w-]/, '')
  begin
    date = (ENV['date'] ? Time.parse(ENV['date']) : Time.now).strftime('%Y-%m-%d')
  rescue
    puts 'Error - date format must be YYYY-MM-DD, please check you typed it correctly!'
    exit(-1)
  end

  filename = File.join(CONFIG['posts'], "#{date}-#{slug}.#{CONFIG['post_ext']}")
  abort("#{filename} already exists; rake aborted!") if File.exist?(filename)

  puts "Creating new post: #{filename}"
  open(filename, 'w') do |post|
    post.puts '---'
    post.puts 'layout: post'
    post.puts "title: \"#{title.tr('-', ' ')}\""
    post.puts 'description: ""'
    post.puts 'category: '
    post.puts "tags: #{tags}"
    post.puts '---'
    post.puts ''
  end
end

desc 'Generate and deploy to gh-pages'
task :deploy do
  Dir.mktmpdir do |tmp|
    ENV['JEKYLL_ENV'] = 'production'
    config = {
      'baseurl' => 'https://www.christophermanning.org',
      'destination' => tmp,
    }
    Jekyll::Site.new(Jekyll.configuration(config)).process

    FileUtils.cp 'CNAME', tmp

    Dir.chdir tmp

    FileUtils.touch '.nojekyll'

    system 'git init'
    system 'git config user.name "Christopher Manning"'
    system 'git config user.email ""'
    system 'git add .'
    message = "Site updated at #{Time.now.utc}"
    system "git commit -m #{message.shellescape}"
    system "git remote add origin git@github.com:#{CONFIG['github_repo']}.git"
    system 'git push origin master --force'
  end
end
