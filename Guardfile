guard 'shell', :all_on_start => true do
  watch /^(client|server)\/.+\.(coffee|styl|jade)$/ do 
    `make`
  end
end

guard 'livereload' do
  watch /^build\/build\..+$/
end

notification :off