Then(/^I will receive a document id$/) do
  @document.id.should be
end

Given(/^I (?:have|create) a document from file "(.*?)"$/) do |filename|
  @document = SN::Document.create(filename: File.join(Dir.pwd, filename), user_token: @users.first.access_token)
end

When(/^I update the document$/) do
  @update_result = @document.save
end

Then(/^I should get a successful response$/) do
  @update_result.should be_true
end

When(/^I add a text field to the document$/) do |table|
  @field = SN::Field.new(table.hashes.first)
  @document.fields << @field
end

Then(/^I should have that field in the document$/) do
  user = @users.first
  doc = SN::Document.get(id: @document.id, access_token: user.access_token)
  label = @field.label

  @field = doc.fields.first { |f| f.label == label }

  expect(@field.id).to be
  expect(@field.label).to be == label
end

When(/^I add a text element to the document$/) do |table|
  @document.texts << SN::TextElement.new(table.hashes.first)
end


When(/^I add a signature element to the document$/) do |table|
  @element = SN::SignatureElement.new(table.hashes.first)
  @document.signatures << @element
end

When(/^I add a check element to the document$/) do |table|
  @document.checks << SN::CheckElement.new(table.hashes.first)
end

When(/^I (?:have|create) an invitation to the document for both users$/) do
  user = @users.first
  second_user = @users.at(1)
  @invitation = SN::Invitation.create(document_id: @document.id, from_user_token: user.access_token ,from_user_email: user.email, to_user_email: second_user.email)
end

Then(/^I should have an invitation$/) do
  @invitation.should be
end

When(/^I get get a list of documents$/) do
  @list_of_docs = SN::Document.all(@users.first.access_token)
end

Then(/^I should get a list of those documents$/) do
  @list_of_docs.size.should be_equal 2
end

When(/^I get that document$/) do
  @doc_result = SN::Document.get(id: @document.id, access_token: @users.first.access_token)
end

When(/^I download that document$/) do
  @downloaded_doc = SN::Document.download(id: @document.id, access_token: @users.first.access_token)
end

Then(/^I should receive a document$/) do
  @doc_result.id.should eq @document.id
end

Then(/^I should receive a file/) do
  @downloaded_doc.should be
end

When(/^I generate a signing link$/) do
  u = @users.at(1)
  @link = SN::Document.generate_signing_link(username: u.email, password: u.password, id: @document.id)
end

Then(/^I should have a link to the document$/) do
  expect(@link).to be
end

When(/^I create a role based invitation to the document for both users$/) do
  user = @users.first
  second_user = @users.at(1)
  doc = SN::Document.get(id: @document.id, access_token: user.access_token)

  recipient = SN::RoleBasedInvitation::Recipient.new(email: second_user.email, role: @field.role, role_id: doc.roles.first.unique_id)

  @invitation = SN::RoleBasedInvitation.create({
    document_id: @document.id,
    from: user.email,
    from_user_token: user.access_token,
    subject: 'test',
    message: 'message',
    to: [recipient]
  })
end