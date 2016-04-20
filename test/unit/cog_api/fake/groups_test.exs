defmodule CogApi.Fake.GroupsTest do
  use CogApi.FakeCase

  alias CogApi.Fake.Client
  alias CogApi.Resources.Group

  doctest CogApi.Fake.Groups

  describe "group_index" do
    it "returns a list of groups" do
      name = "foobar"
      {:ok, _ } = Client.group_create(valid_endpoint, %{name: name})

      {:ok, groups} = Client.group_index(valid_endpoint)

      first_group = List.first groups
      assert present first_group.id
      assert first_group.name == name
    end
  end

  describe "group_show" do
    context "when the group exists" do
      it "returns the group" do
        params = %{name: "Developers"}
        {:ok, created_group} = Client.group_create(valid_endpoint, params)

        {:ok, found_group} = Client.group_show(valid_endpoint, created_group.id)

        assert found_group.id == created_group.id
      end
    end
  end

  describe "group_find" do
    it "finds and returns a group by name" do
      group_names = ~w(group_1 group_2 group_3)
      Enum.each(group_names, fn(name) -> Client.group_create(valid_endpoint, %{name: name}) end)
      {:ok, group} = Client.group_find(valid_endpoint, name: Enum.at(group_names, 1))

      assert present group.id
      assert group.name == Enum.at(group_names, 1)
    end
  end

  describe "create" do
    it "returns the created group" do
      name = "foobar"
      {:ok, group} = Client.group_create(valid_endpoint, %{name: name})

      assert present group.id
      assert group.name == name
    end
  end

  describe "create" do
    it "updates the group on the server and returns the updated group" do
      name = "foobar"

      {:ok, group} = Client.group_create(valid_endpoint, %{name: name})

      assert present group.id
      assert group.name == name
    end
  end

  describe "delete" do
    it "deletes the group from the server" do
      {:ok, group} = Client.group_create(valid_endpoint, %{name: "new group"})

      assert :ok == Client.group_delete(valid_endpoint, group.id)

      {:ok, groups} = Client.group_index(valid_endpoint)

      refute Enum.member?(groups, group)
    end

    context "when the group cannot be deleted" do
      it "returns an error" do
        {:error, [error]} = Client.group_delete(valid_endpoint, "not real")

        assert error == "Resource not found for: groups"
      end
    end
  end

  describe "group_add_role" do
    it "returns the roles that are associated with that group" do
      role = Client.role_create(valid_endpoint, %{name: "role"}) |> get_value
      group = Client.group_create(valid_endpoint, %{name: "group"}) |> get_value

      updated_group = Client.group_add_role(valid_endpoint, %Group{id: group.id}, role) |> get_value

      first_role = List.first updated_group.roles
      assert updated_group.name == group.name
      assert first_role.id == role.id
    end
  end

  describe "group_remove_role" do
    it "returns the roles that are associated with that group" do
      role = Client.role_create(valid_endpoint, %{name: "role123"}) |> get_value
      group = Client.group_create(valid_endpoint, %{name: "group123"}) |> get_value
      group = Client.group_add_role(valid_endpoint, group, role) |> get_value
      assert group.roles != []

      updated_group = Client.group_remove_role(valid_endpoint, %Group{id: group.id}, role) |> get_value

      assert updated_group.name == group.name
      assert updated_group.roles == []
    end
  end

  describe "group_add_user" do
    it "adds the user to the group" do
      group = Client.group_create(valid_endpoint, %{name: "user_group"}) |> get_value
      first_user = Client.user_create(valid_endpoint, %{email_address: "bob@example.com"}) |> get_value
      second_user = Client.user_create(valid_endpoint, %{email_address: "sam@example.com"}) |> get_value
      assert group.users == []

      {:ok, group} = Client.group_add_user(valid_endpoint, group, first_user)
      {:ok, group} = Client.group_add_user(valid_endpoint, group, second_user)

      assert ids_for(group.users) == [first_user.id, second_user.id]

      first_user = Client.user_show(valid_endpoint, first_user.id) |> get_value
      assert ids_for(first_user.groups) == [group.id]

      second_user = Client.user_show(valid_endpoint, second_user.id) |> get_value
      assert ids_for(second_user.groups) == [group.id]
    end
  end

  describe "group_remove_user" do
    it "removes the user from the group" do
      {group, user} = create_group_with_user(valid_endpoint)

      {:ok, group} = Client.group_remove_user(valid_endpoint, group, user)

      assert group.users == []

      user = Client.user_show(valid_endpoint, user.id) |> get_value
      assert user.groups == []
    end
  end

  defp ids_for(records) do
    Enum.map(records, &(&1.id))
  end

  def create_group_with_user(endpoint) do
    group = Client.group_create(endpoint, %{name: "Group"}) |> get_value
    user = Client.user_create(endpoint, %{username: "User"}) |> get_value
    {:ok, group} = Client.group_add_user(endpoint, group, user)

    user = Client.user_show(endpoint, user.id) |> get_value
    {group, user}
  end
end
