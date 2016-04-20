defmodule CogApi.HTTP.ChatHandlesTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client
  import CogApi.HTTP.ResourceHelpers

  doctest CogApi.HTTP.ChatHandles

  describe "chat_handles_create" do
    it "allows creating a new chat handle for a user" do
      cassette "chat_handles_create" do
        endpoint = valid_endpoint
        user = find_or_create_user(endpoint, "chat_handles_create")

        handle = Client.chat_handle_create(
          endpoint,
          user.id,
          %{chat_provider: "slack", handle: "mpeck"}
        ) |> get_value

        assert present handle.id
        assert handle.handle == "mpeck"
      end
    end

    context "when the chat handle does not exist for the provider" do
      it "returns an error" do
        cassette "chat_handles_create_no_handle" do
          endpoint = valid_endpoint
          user = find_or_create_user(endpoint, "chat_handles_create_no_handle")

          {:error, [error]} = Client.chat_handle_create(
            endpoint,
            user.id,
            %{chat_provider: "slack", handle: "not_real"}
          )

          assert error == "User with handle 'not_real' not found"
        end
      end
    end
  end

  describe "chat_handles_delete" do
    it "allows deleting a chat handle" do
      cassette "chat_handles_delete" do
        endpoint = valid_endpoint
        user = find_or_create_user(endpoint, "chat_handles_delete")
        handle = Client.chat_handle_create(
          endpoint,
          user.id,
          %{chat_provider: "slack", handle: "christian"}
        ) |> get_value

        response = Client.chat_handle_delete(endpoint, handle.id)

        assert response == :ok
      end
    end
  end
end