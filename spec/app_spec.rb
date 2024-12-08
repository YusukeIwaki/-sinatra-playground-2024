require 'spec_helper'

RSpec.describe 'app' do
  let(:app) { App }

  it 'should create user and update profile' do
    User.delete_all
    Profile.delete_all

    expect { post '/users' }.to change { User.count }.by(1)
    expect(last_response.status).to eq(200)
    user = User.last

    response = JSON.parse(last_response.body)
    user_id = response['id']
    expect(user_id).to eq(user.id)

    expect {
      patch "/users/#{user_id}", {
        display_name: 'YusukeIwaki',
        email: 'iwaki@example.com',
      }.to_json, 'CONTENT_TYPE' => 'application/json'
    }.to change { Profile.where(user: user).count }.by(1)
    profile = Profile.where(user: user).last

    expect(last_response.status).to eq(200)
    response = JSON.parse(last_response.body)
    expect(response['id']).to eq(user.id)
    expect(response['profile']['display_name']).to eq(profile.display_name)
    expect(response['profile']['email']).to eq(profile.email)

    patch "/users/#{user_id}", {
      display_name: 'YusukeIwaki2',
      email: 'iwaki2@example.com',
    }.to_json, 'CONTENT_TYPE' => 'application/json'

    profile.reload
    expect(profile.display_name).to eq('YusukeIwaki2')
    expect(profile.email).to eq('iwaki2@example.com')
  end
end
