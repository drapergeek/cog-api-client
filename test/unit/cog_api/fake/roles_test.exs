defmodule CogApi.Fake.RolesTest do
  use CogApi.FakeCase

  alias CogApi.Fake.Client
  alias CogApi.Resources.Group
  alias CogApi.Resources.Permission

  doctest CogApi.Fake.Roles

  describe "role_create" do
    it "requires a token" do
      {response, error_message} = Client.role_create(%Endpoint{}, %{name: nil})

      assert response == :error
      assert error_message == "You must provide an authenticated endpoint"
    end

    it "returns the created role" do
      name = "foobar"
      params = %{name: name}
      {:ok, role} = Client.role_create(fake_endpoint, params)

      assert present role.id
      assert role.name == name
    end
  end

  describe "role_show" do
    context "when the role exists" do
      it "returns the role" do
        params = %{name: "QA Analyst"}
        {:ok, created_role} = Client.role_create(fake_endpoint, params)

        {:ok, found_role} = Client.role_show(fake_endpoint, created_role.id)

        assert found_role.id == created_role.id
        assert found_role.groups == []
      end

      it "returns the groups that are associated with that role" do
        role = Client.role_create(fake_endpoint, %{name: "role"}) |> get_value
        group = Client.group_create(fake_endpoint, %{name: "group"}) |> get_value

        group = Client.role_grant(fake_endpoint, role, group) |> get_value

        role = Client.role_show(fake_endpoint, role.id) |> get_value

        assert role.groups == [group]
      end
    end
  end

  describe "role_show by name" do
    context "when the role exists" do
      it "returns the role" do
        params = %{name: "QA Analyst"}
        {:ok, created_role} = Client.role_create(fake_endpoint, params)

        {:ok, found_role} = Client.role_show(fake_endpoint, %{name: created_role.name})

        assert found_role.id == created_role.id
      end
    end
  end

  describe "role_index" do
    it "requires an authenticated endpoint" do
      {response, error_message} = Client.role_index(%Endpoint{})

      assert response == :error
      assert error_message == "You must provide an authenticated endpoint"
    end

    it "returns a list of roles" do
      name = "foobar"
      params = %{name: name}
      {:ok, _} = Client.role_create(fake_endpoint, params)

      {:ok, roles} = Client.role_index(fake_endpoint)

      first_role = List.first roles
      assert present first_role.id
      assert first_role.name == name
    end
  end

  describe "role_update" do
    it "returns the updated role" do
      {:ok, new_role} = Client.role_create(fake_endpoint, %{name: "new role"})
      {:ok, updated_role} = Client.role_update(
        fake_endpoint,
        new_role.id,
        %{name: "updated role"}
      )

      assert updated_role.name == "updated role"
    end
  end

  describe "role_delete" do
    it "deletes the role from the server" do
      {:ok, role} = Client.role_create(fake_endpoint, %{name: "new role"})

      Client.role_delete(fake_endpoint, role.id)

      {:ok, roles} = Client.role_index(fake_endpoint)

      refute Enum.member?(roles, role)
    end

    it "returns :ok" do
      {:ok, role} = Client.role_create(fake_endpoint, %{name: "new role"})
      assert :ok == Client.role_delete(fake_endpoint, role.id)
    end
  end

  describe "role_grant" do
    it "returns the roles that are associated with that group" do
      role = Client.role_create(fake_endpoint, %{name: "role"}) |> get_value
      group = Client.group_create(fake_endpoint, %{name: "group"}) |> get_value

      updated_group = Client.role_grant(fake_endpoint, role, %Group{id: group.id}) |> get_value

      first_role = List.first updated_group.roles
      assert updated_group.name == group.name
      assert first_role.id == role.id
    end
  end

  describe "role_revoke" do
    it "returns the roles that are associated with that group" do
      role = Client.role_create(fake_endpoint, %{name: "role123"}) |> get_value
      group = Client.group_create(fake_endpoint, %{name: "group123"}) |> get_value
      group = Client.role_grant(fake_endpoint, role, group) |> get_value
      assert group.roles != []

      updated_group = Client.role_revoke(fake_endpoint, role, %Group{id: group.id}) |> get_value

      assert updated_group.name == group.name
      assert updated_group.roles == []
    end
  end

  describe "role_add_permission" do
    it "adds the permission to the role" do
      role = Client.role_create(fake_endpoint, %{name: "role"}) |> get_value
      permission = Client.permission_create(fake_endpoint, "permission") |> get_value
      assert role.permissions == []

      permission_without_id = Map.delete permission, :id
      role = Client.role_add_permission(fake_endpoint, role, permission_without_id) |> get_value

      assert role.permissions == [permission]
    end

    context "when the permission cannot be added" do
      it "returns an :error" do
        role = Client.role_create(fake_endpoint, %{name: "designer"}) |> get_value
        permission = %Permission{name: "fake_permission", namespace: "s3"}

        {:error, error} = Client.role_add_permission(fake_endpoint, role, permission)

        assert error == ["Not found permissions - s3:fake_permission"]
      end
    end
  end

  describe "role_remove_permission" do
    it "removes the permission from the role" do
      role = Client.role_create(fake_endpoint, %{name: "role"}) |> get_value
      permission = Client.permission_create(fake_endpoint, "permission") |> get_value
      role = Client.role_add_permission(fake_endpoint, role, permission) |> get_value
      assert role.permissions == [permission]

      permission_without_id = Map.delete permission, :id
      role = Client.role_remove_permission(fake_endpoint, role, permission_without_id) |> get_value

      assert role.permissions == []
    end
  end
end
