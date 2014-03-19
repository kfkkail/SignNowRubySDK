require 'base64'

Given(/^I am an API user of SignNow$/) do
  @api_user = SN::User.new(access_token: 'Basic' + Base64.strict_encode64(SN.Settings.client_id + ':' + SN.Settings.client_secret))
end

Given(/^I have (?:a|the) users?$/) do |table|
  @users = []
  table.hashes.each do |u|
    u['first_name'] = u['first_name'] + '-' + Time.now.to_f.to_s
    u['last_name'] = u['last_name'] + '-' + Time.now.to_f.to_s
    u['email'] = Time.now.to_f.to_s + u['email']
    @users << SN::User.create(u)
  end
end

Then(/^I should receive an access token$/) do
  @users.first.access_token.should be
end

Then(/^I should receive an id$/) do
  @users.first.id.should be
end

When(/^I try to create the user it should fail$/) do |table|
  hash = table.hashes[0]
  hash['first_name'] = hash['first_name'].gsub /#/, Time.now.to_f.to_s
  hash['last_name'] = hash['last_name'].gsub /#/, Time.now.to_f.to_s
  hash['email'] = hash['email'].gsub /#/, Time.now.to_f.to_s
  expect { SN::User.create(hash) }.to raise_error SN::InvalidStateError
end

When(/^I get the data for the user$/) do
  @result_user = SN::User.get(@users.first.access_token)
end

Then(/^I should have data for the user$/) do
  @result_user.id.should be == @users.first.id
end