defmodule CogApi.HTTP.Client do
  @behaviour CogApi.Client

  alias CogApi.Endpoint

  alias CogApi.HTTP.Bundles
  alias CogApi.HTTP.Groups
  alias CogApi.HTTP.Permissions
  alias CogApi.HTTP.Relays
  alias CogApi.HTTP.RelayGroups
  alias CogApi.HTTP.Roles
  alias CogApi.HTTP.Rules
  alias CogApi.HTTP.Triggers
  alias CogApi.HTTP.Users

  def authenticate(%Endpoint{token: nil}=endpoint) do
    CogApi.HTTP.Authentication.get_and_merge_token(endpoint)
  end

  def bundle_index(%Endpoint{}=endpoint) do
    Bundles.index(endpoint)
  end

  def bundle_show(%Endpoint{}=endpoint, bundle_id) do
    Bundles.show(endpoint, bundle_id)
  end

  def bundle_update(%Endpoint{}=endpoint, bundle_id, params) do
    Bundles.update(endpoint, bundle_id, params)
  end

  def bundle_delete(%Endpoint{}=endpoint, bundle_id) do
    Bundles.delete(endpoint, bundle_id)
  end

  def bundle_create(%Endpoint{}=endpoint, params) do
    Bundles.create(endpoint, params)
  end

  def group_index(%Endpoint{}=endpoint) do
    Groups.index(endpoint)
  end

  def group_show(%Endpoint{}=endpoint, group_id) do
    Groups.show(endpoint, group_id)
  end

  def group_find(%Endpoint{}=endpoint, params) do
    Groups.find(endpoint, params)
  end

  def group_create(%Endpoint{}=endpoint, name) do
    Groups.create(endpoint, name)
  end

  def group_update(%Endpoint{}=endpoint, group_id, params) do
    Groups.update(endpoint, group_id, params)
  end

  def group_delete(%Endpoint{}=endpoint, group_id) do
    Groups.delete(endpoint, group_id)
  end

  def group_add_user(%Endpoint{}=endpoint, group, user) do
    Groups.add_user(endpoint, group, user)
  end

  def group_remove_user(%Endpoint{}=endpoint, group, user) do
    Groups.remove_user(endpoint, group, user)
  end

  def permission_index(%Endpoint{}=endpoint) do
    Permissions.index(endpoint)
  end

  def permission_create(%Endpoint{}=endpoint, name) do
    Permissions.create(endpoint, name)
  end

  def relay_index(%Endpoint{}=endpoint) do
    Relays.index(endpoint)
  end

  def relay_show(relay_id, %Endpoint{}=endpoint) do
    Relays.show(relay_id, endpoint)
  end

  def relay_create(params, %Endpoint{}=endpoint) do
    Relays.create(params, endpoint)
  end

  def relay_update(relay_id, params, %Endpoint{}=endpoint) do
    Relays.update(relay_id, params, endpoint)
  end

  def relay_delete(relay_id, %Endpoint{}=endpoint) do
    Relays.delete(relay_id, endpoint)
  end

  def relay_group_index(%Endpoint{}=endpoint) do
    RelayGroups.index(endpoint)
  end

  def relay_group_show(relay_group_id, %Endpoint{}=endpoint) do
    RelayGroups.show(relay_group_id, endpoint)
  end

  def relay_group_create(params, %Endpoint{}=endpoint) do
    RelayGroups.create(params, endpoint)
  end

  def relay_group_update(relay_group_id, params, %Endpoint{}=endpoint) do
    RelayGroups.update(relay_group_id, params, endpoint)
  end

  def relay_group_delete(relay_group_id, %Endpoint{}=endpoint) do
    RelayGroups.delete(relay_group_id, endpoint)
  end

  def relay_group_add_relay(relay_group_id, relay_id, %Endpoint{}=endpoint) do
    RelayGroups.add_relay(relay_group_id, relay_id, endpoint)
  end

  def relay_group_remove_relay(relay_group_id, relay_id, %Endpoint{}=endpoint) do
    RelayGroups.remove_relay(relay_group_id, relay_id, endpoint)
  end

  def relay_group_add_bundle(relay_group_id, bundle_id, %Endpoint{}=endpoint) do
    RelayGroups.add_bundle(relay_group_id, bundle_id, endpoint)
  end

  def relay_group_remove_bundle(relay_group_id, bundle_id, %Endpoint{}=endpoint) do
    RelayGroups.remove_bundle(relay_group_id, bundle_id, endpoint)
  end

  def role_index(endpoint) do
    Roles.index(endpoint)
  end

  def role_show(endpoint, field) do
    Roles.show(endpoint, field)
  end

  def role_create(endpoint, params) do
    Roles.create(endpoint, params)
  end

  def role_update(%Endpoint{}=endpoint, role_id, params) do
    Roles.update(endpoint, role_id, params)
  end

  def role_delete(%Endpoint{}=endpoint, role_id) do
    Roles.delete(endpoint, role_id)
  end

  def role_grant(%Endpoint{}=endpoint, role, group) do
    Roles.grant(endpoint, role, group)
  end

  def role_revoke(%Endpoint{}=endpoint, role, group) do
    Roles.revoke(endpoint, role, group)
  end

  def role_add_permission(endpoint, role, permission) do
    Roles.add_permission(endpoint, role, permission)
  end

  def role_remove_permission(endpoint, role, permission) do
    Roles.remove_permission(endpoint, role, permission)
  end

  def rule_index(command, %Endpoint{}=endpoint) do
    Rules.index(command, endpoint)
  end

  def rule_create(rule_text, %Endpoint{}=endpoint) do
    Rules.create(rule_text, endpoint)
  end

  def rule_delete(rule_id, %Endpoint{}=endpoint) do
    Rules.delete(rule_id, endpoint)
  end

  def trigger_by_name(%Endpoint{}=endpoint, name) do
    Triggers.by_name(endpoint, name)
  end

  def trigger_create(%Endpoint{}=endpoint, params) do
    Triggers.create(endpoint, params)
  end

  def trigger_delete(%Endpoint{}=endpoint, id) do
    Triggers.delete(endpoint, id)
  end

  def trigger_index(%Endpoint{}=endpoint) do
    Triggers.index(endpoint)
  end

  def trigger_show(%Endpoint{}=endpoint, id) do
    Triggers.show(endpoint, id)
  end

  def trigger_update(%Endpoint{}=endpoint, id, params) do
    Triggers.update(endpoint, id, params)
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
