
def run(cmd)
  puts(cmd)
  system(cmd)
end

def run_test_file(file)
  run %Q(ruby -I"lib:test" -rubygems #{file})
end

def run_all_tests
  run "rake test"
end

watch('test/helper\.rb') { system('clear'); run_all_tests }
watch('test/test_.*\.rb') { |m| system('clear'); run_test_file(m[0]) }
watch('lib/.*') { |m| system('clear'); run_all_tests }

# Ctrl-\
Signal.trap('QUIT') do
  system('clear')
  puts " --- Running all tests ---\n\n"
  run_all_tests
end

# Ctrl-C
Signal.trap('INT') { abort("\n") }

