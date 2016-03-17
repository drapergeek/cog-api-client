defmodule CogApi.Fake.Client do
  @behaviour CogApi.Client

  alias CogApi.Endpoint
  alias CogApi.Fake.Groups
  alias CogApi.Fake.Roles
  alias CogApi.Fake.Permissions
  alias CogApi.Fake.Bundles
  alias CogApi.Fake.Users

  def authenticate(%Endpoint{token: nil}=endpoint) do
    CogApi.Fake.Authentication.get_and_merge_token(endpoint)
  end

  def bundle_index(%Endpoint{}=endpoint) do
    Bundles.index(endpoint)
  end

  def bundle_update(%Endpoint{}=endpoint, bundle_id, params) do
    Bundles.update(endpoint, bundle_id, params)
  end

  def group_index(%Endpoint{}=endpoint) do
    Groups.index(endpoint)
  end

  def group_show(%Endpoint{}=endpoint, group_id) do
    Groups.show(endpoint, group_id)
  end

  def group_create(%Endpoint{}=endpoint, params) do
    Groups.create(endpoint, params)
  end

  def permission_index(%Endpoint{}=endpoint) do
    Permissions.index(endpoint)
  end

  def permission_create(%Endpoint{}=endpoint, name) do
    Permissions.create(endpoint, name)
  end

  def role_index(endpoint) do
    Roles.index(endpoint)
  end

  def role_show(endpoint, id) do
    Roles.show(endpoint, id)
  end

  def role_create(endpoint, params) do
    Roles.create(endpoint, params)
  end

  def role_update(endpoint, role_id, params) do
    Roles.update(endpoint, role_id, params)
  end

  def role_delete(%Endpoint{}=endpoint, role_id) do
    Roles.delete(endpoint, role_id)
  end

  def user_index(%Endpoint{}=endpoint) do
    Users.index(endpoint)
  end

  def user_show(%Endpoint{}=endpoint, user_id) do
    Users.show(endpoint, user_id)
  end

  def user_create(%Endpoint{}=endpoint, params) do
    Users.create(endpoint, params)
  end

  def user_update(%Endpoint{}=endpoint, user_id, params) do
    Users.update(endpoint, user_id, params)
  end

  def user_delete(%Endpoint{}=endpoint, user_id) do
    Users.delete(endpoint, user_id)
  end
end
