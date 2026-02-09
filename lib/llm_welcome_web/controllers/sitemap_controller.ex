defmodule LlmWelcomeWeb.SitemapController do
  use LlmWelcomeWeb, :controller

  @base_url "https://llmwelcome.dev"

  def index(conn, _params) do
    sitemap = """
    <?xml version="1.0" encoding="UTF-8"?>
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
      <url>
        <loc>#{@base_url}/</loc>
        <changefreq>daily</changefreq>
        <priority>1.0</priority>
      </url>
      <url>
        <loc>#{@base_url}/about</loc>
        <changefreq>monthly</changefreq>
        <priority>0.8</priority>
      </url>
      <url>
        <loc>#{@base_url}/llm-welcome.skill.md</loc>
        <changefreq>weekly</changefreq>
        <priority>0.9</priority>
      </url>
      <url>
        <loc>#{@base_url}/prepare-for-llm-welcome.skill.md</loc>
        <changefreq>weekly</changefreq>
        <priority>0.9</priority>
      </url>
    </urlset>
    """

    conn
    |> put_resp_content_type("application/xml", "utf-8")
    |> resp(200, sitemap)
    |> send_resp()
  end
end
