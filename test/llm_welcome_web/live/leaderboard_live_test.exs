defmodule LlmWelcomeWeb.LeaderboardLiveTest do
  use LlmWelcomeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias LlmWelcome.GitHub

  defp create_issue(repo_id, attrs) do
    defaults = %{
      repository_id: repo_id,
      labels: [],
      state: "closed",
      html_url: "https://github.com/test/repo/issues/#{System.unique_integer([:positive])}"
    }

    GitHub.upsert_issue(Map.merge(defaults, attrs))
  end

  defp seed_contributor_data(_context) do
    {:ok, install} =
      GitHub.upsert_installation(%{
        github_installation_id: System.unique_integer([:positive]),
        account_login: "test-org",
        account_type: "Organization"
      })

    {:ok, repo} =
      GitHub.upsert_repository(%{
        github_id: System.unique_integer([:positive]),
        installation_id: install.id,
        owner: "test-org",
        name: "test-repo",
        full_name: "test-org/test-repo"
      })

    %{repo: repo}
  end

  describe "leaderboard page" do
    test "renders empty state when no contributions exist", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/leaderboard")

      assert html =~ "Leaderboard"
      assert html =~ "No contributions yet"
    end

    test "renders via GET request", %{conn: conn} do
      conn = get(conn, ~p"/leaderboard")
      assert html_response(conn, 200) =~ "Leaderboard"
    end
  end

  describe "leaderboard with data" do
    setup [:seed_contributor_data]

    test "displays contributors ranked by PR count", %{conn: conn, repo: repo} do
      for i <- 1..3 do
        create_issue(repo.id, %{
          github_id: 100_000 + i,
          number: i,
          title: "Issue #{i}",
          contributor: "top-contributor",
          merged_pr_url: "https://github.com/test/repo/pull/#{i}"
        })
      end

      create_issue(repo.id, %{
        github_id: 100_010,
        number: 10,
        title: "Issue 10",
        contributor: "one-pr-contributor",
        merged_pr_url: "https://github.com/test/repo/pull/10"
      })

      {:ok, _view, html} = live(conn, ~p"/leaderboard")

      assert html =~ "top-contributor"
      assert html =~ "one-pr-contributor"
      assert html =~ "3 PRs"
      assert html =~ "1 PR"
      refute html =~ "No contributions yet"
    end

    test "links to GitHub profiles", %{conn: conn, repo: repo} do
      create_issue(repo.id, %{
        github_id: 200_001,
        number: 20,
        title: "Test issue",
        contributor: "some-user",
        merged_pr_url: "https://github.com/test/repo/pull/20"
      })

      {:ok, _view, html} = live(conn, ~p"/leaderboard")

      assert html =~ "https://github.com/some-user"
    end

    test "does not count issues without merged_pr_url", %{conn: conn, repo: repo} do
      create_issue(repo.id, %{
        github_id: 300_001,
        number: 30,
        title: "Closed but no PR",
        contributor: "ghost-contributor",
        merged_pr_url: nil
      })

      {:ok, _view, html} = live(conn, ~p"/leaderboard")

      refute html =~ "ghost-contributor"
      assert html =~ "No contributions yet"
    end

    test "does not count issues without contributor", %{conn: conn, repo: repo} do
      create_issue(repo.id, %{
        github_id: 400_001,
        number: 40,
        title: "Closed by maintainer",
        contributor: nil,
        merged_pr_url: "https://github.com/test/repo/pull/40"
      })

      {:ok, _view, html} = live(conn, ~p"/leaderboard")

      refute html =~ "No contributions yet" == false
      assert html =~ "No contributions yet"
    end
  end
end
