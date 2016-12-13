# File: Rakefile
# Usage: rake

# Define tasks

desc 'Default'
task default: :check do
end

list = ['haml', 'sinatra', 'rainbow', 'terminal-table', 'thor']
list << %w(base64_compatible coderay)
list.flatten!

desc 'Install gems'
task :gems do
  list.each { |name| system("gem install #{name}") }
end

desc 'Check installation'
task :check do
  cmd = `gem list`.split("\n")
  names = cmd.map { |i| i.split(' ')[0] }
  fails = []
  list.each { |i| fails << i unless names.include?(i) }

  if fails.size.zero?
    puts '[ OK ] Installed gems!'
  else
    puts '[FAIL] Installed gems!: ' + fails.join(',')
  end
  testfile = './tests/all.rb'
  a = `cat #{testfile}|grep "_test"|wc -l`
  b = `vdir -R tests/ |grep "_test.rb"|wc -l`
  if a.to_i == b.to_i
    puts "[ OK ] All ruby tests into #{testfile}"
  else
    puts "[FAIL] some ruby tests are not into #{testfile}"
  end

  puts "[INFO] Running #{testfile}"
  system(testfile)
end

desc 'Update this project'
task :update do
  system('git pull')
end

desc 'Clean output dir'
task :clean do
  system('rm output/*')
end
