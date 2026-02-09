defmodule LlmWelcome.GitHub.API do
  @moduledoc """
  Authenticated GitHub API client using GitHub App installation tokens.
  """

  require Logger

  @github_api "https://api.github.com"

  def list_installation_repos(installation_id) do
    with {:ok, token} <- get_installation_token(installation_id) do
      fetch_all_pages("#{@github_api}/installation/repositories", token, "repositories")
    end
  end

  def get_repo(installation_id, owner, name) do
    with {:ok, token} <- get_installation_token(installation_id) do
      request(:get, "#{@github_api}/repos/#{owner}/#{name}", token)
    end
  end

  # Token management

  defp get_installation_token(installation_id) do
    jwt = generate_jwt()

    case request_with_token(
           :post,
           "#{@github_api}/app/installations/#{installation_id}/access_tokens",
           jwt
         ) do
      {:ok, %{"token" => token}} -> {:ok, token}
      {:error, _} = error -> error
    end
  end

  defp generate_jwt do
    app_id = Application.fetch_env!(:llm_welcome, :github_app_id)
    private_key_pem = Application.fetch_env!(:llm_welcome, :github_private_key)

    now = System.system_time(:second)

    claims = %{
      "iat" => now - 60,
      "exp" => now + 600,
      "iss" => app_id
    }

    jwk = JOSE.JWK.from_pem(private_key_pem)
    jws = %{"alg" => "RS256"}

    {_, token} =
      jwk
      |> JOSE.JWT.sign(jws, claims)
      |> JOSE.JWS.compact()

    token
  end

  # HTTP helpers

  defp request(method, url, token) do
    request_with_token(method, url, token)
  end

  defp request_with_token(method, url, token) do
    Req.new(
      method: method,
      url: url,
      headers: [
        {"authorization", "Bearer #{token}"},
        {"accept", "application/vnd.github+json"},
        {"x-github-api-version", "2022-11-28"}
      ]
    )
    |> Req.request()
    |> handle_response()
  end

  defp handle_response({:ok, %Req.Response{status: status, body: body}})
       when status in 200..299 do
    {:ok, body}
  end

  defp handle_response({:ok, %Req.Response{status: status, body: body}}) do
    Logger.error("GitHub API error: status=#{status} body=#{inspect(body)}")
    {:error, {status, body}}
  end

  defp handle_response({:error, exception}) do
    Logger.error("GitHub API request failed: #{inspect(exception)}")
    {:error, exception}
  end

  defp fetch_all_pages(url, token, key, acc \\ []) do
    resp =
      Req.new(
        method: :get,
        url: url,
        headers: [
          {"authorization", "Bearer #{token}"},
          {"accept", "application/vnd.github+json"},
          {"x-github-api-version", "2022-11-28"}
        ]
      )
      |> Req.request()

    case resp do
      {:ok, %Req.Response{status: 200, body: body, headers: headers}} ->
        items = if key, do: Map.get(body, key, []), else: body
        all = acc ++ items

        case next_page_url(headers) do
          nil -> {:ok, all}
          next_url -> fetch_all_pages(next_url, token, key, all)
        end

      {:ok, %Req.Response{status: status, body: body}} ->
        Logger.error("GitHub API error: status=#{status} body=#{inspect(body)}")
        {:error, {status, body}}

      {:error, exception} ->
        Logger.error("GitHub API request failed: #{inspect(exception)}")
        {:error, exception}
    end
  end

  defp next_page_url(headers) do
    case List.keyfind(headers, "link", 0) do
      {_, [value | _]} ->
        value
        |> String.split(",")
        |> Enum.find_value(fn part ->
          if String.contains?(part, "rel=\"next\"") do
            Regex.run(~r/<([^>]+)>/, part, capture: :all_but_first)
            |> case do
              [url] -> url
              _ -> nil
            end
          end
        end)

      _ ->
        nil
    end
  end
end
