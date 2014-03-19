When(/^I get the the user's token$/) do
  @token = SN::Token.get(@users.first.access_token)
end

Then(/^I should receive token data back$/) do
  expect(@token).to be
end

When(/^I generate the the user's token$/) do
  u = @users.first
  @token = SN::Token.create(username: u.email, password: u.password, grant_type: 'password', scope: '*')
  u.access_token = @token.access_token
end

When(/^I generate their tokens$/) do
  @users.each do |u|
    token = SN::Token.create(username: u.email, password: u.password, grant_type: 'password', scope: '*')
    u.access_token = token.access_token
  end
end

Then(/^I should have an access_token$/) do
  expect(@token.access_token).to be
end