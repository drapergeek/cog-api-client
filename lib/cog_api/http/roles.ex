defmodule CogApi.HTTP.Roles do
  alias CogApi.Endpoint
  alias CogApi.HTTP.ApiResponse
  alias CogApi.HTTP.Base
  alias CogApi.Resources.Permission
  alias CogApi.Resources.Role

  def index(%Endpoint{}=endpoint) do
    Base.get(endpoint, "roles")
    |> ApiResponse.format(%{"roles" => [Role.format]})
  end

  def show(%Endpoint{}=endpoint, %{name: role_name}) do
    Base.get(endpoint, "roles?name=#{role_name}")
    |> ApiResponse.format(%{"role" => Role.format})
  end
  def show(%Endpoint{}=endpoint, id) do
    Base.get(endpoint, "roles/#{id}")
    |> ApiResponse.format(%{"role" => Role.format})
  end

  def create(%Endpoint{}=endpoint, params) do
    Base.post(endpoint, "roles", %{"role" => params})
    |> ApiResponse.format(%{"role" => Role.format})
  end

  def update(%Endpoint{}=endpoint, role_id, params) do
    Base.patch(endpoint, "roles/#{role_id}", %{"role" => params})
    |> ApiResponse.format(%{"role" => Role.format})
  end

  def delete(%Endpoint{}=endpoint, role_id) do
    Base.delete(endpoint, "roles/#{role_id}")
    |> ApiResponse.format(%{"role" => Role.format})
  end

  def add_permission(endpoint, role, permission) do
    build_role_with_new_permissions(endpoint, role, permission, :grant)
  end

  def remove_permission(endpoint, role, permission) do
    build_role_with_new_permissions(endpoint, role, permission, :revoke)
  end

  defp build_role_with_new_permissions(endpoint, role = %{id: role_id}, permission, action) do
    with {:ok, permissions} <- update_permissions(endpoint, role_id, permission, action) do
      {:ok, %{role | permissions: permissions}}
    end
  end

  defp update_permissions(endpoint, role_id, permission, action) do
    permission_name = Permission.full_name(permission)
    path = "roles/#{role_id}/permissions"
    Base.post(endpoint, path, %{permissions: %{action =>  [permission_name]}})
    |> ApiResponse.format(%{"permissions" => [Permission.format]})
  end
end
