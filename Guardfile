guard 'bundler' do
  watch('Gemfile')
end

guard 'cucumber', :cli => '--color --format progress' do
  watch(%r{^lib/(.+)\.rb$})
  watch(%r{^lib/signnow/(.+)\.rb$})
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})          { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
end
