defmodule LlmWelcomeWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use LlmWelcomeWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <div class="relative isolate min-h-screen">
      <div class="mx-auto flex w-full max-w-7xl flex-1 flex-col px-3 pb-8 pt-5 sm:px-6 lg:px-8">
        <header class="flex flex-nowrap items-center justify-between gap-2 sm:gap-4">
          <.link
            navigate={~p"/"}
            class="text-base font-semibold tracking-tight text-base-content sm:text-xl"
          >
            <span class="text-primary">llm</span>welcome<span class="text-base-content/50">.dev</span>
          </.link>
          <div class="flex items-center gap-3 sm:gap-5">
            <.link
              navigate={~p"/about"}
              class="text-sm font-medium text-base-content/70 transition hover:text-base-content"
            >
              About
            </.link>
            <a
              href="https://github.com/tomasz-tomczyk/llm-welcome"
              target="_blank"
              rel="noopener"
              class="inline-flex items-center gap-1.5 text-sm font-medium text-base-content/70 transition hover:text-base-content"
            >
              <svg class="size-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path
                  fill-rule="evenodd"
                  d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"
                  clip-rule="evenodd"
                />
              </svg>
              <span class="hidden sm:inline">GitHub</span>
            </a>
            <.theme_toggle />
          </div>
        </header>

        <main class="mt-8 flex-1 px-1 pb-2 sm:px-2 sm:pb-4">
          {render_slot(@inner_block)}
        </main>

        <footer class="mt-8 border-t border-base-300 pt-6 text-sm text-base-content/60">
          <div class="flex flex-col items-center gap-3 sm:flex-row sm:justify-between">
            <div class="flex items-center gap-4">
              <.link navigate={~p"/about"} class="hover:text-base-content transition">About</.link>
              <a
                href="https://github.com/tomasz-tomczyk/llm-welcome"
                target="_blank"
                rel="noopener"
                class="inline-flex items-center gap-1.5 hover:text-base-content transition"
              >
                <svg class="size-4" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                  <path
                    fill-rule="evenodd"
                    d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"
                    clip-rule="evenodd"
                  />
                </svg>
                GitHub
              </a>
            </div>
            <p>
              Created by
              <a
                href="https://github.com/tomasz-tomczyk"
                target="_blank"
                rel="noopener"
                class="hover:text-base-content transition"
              >
                Tomasz Tomczyk
              </a>
            </p>
          </div>
        </footer>
      </div>
    </div>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="relative flex items-center rounded-full border border-base-300 bg-base-100 p-1 shadow-sm">
      <div class="absolute left-1 top-1 h-6 w-6 rounded-full bg-base-200 transition-[left] [[data-theme=light]_&]:left-[28px] [[data-theme=dark]_&]:left-[52px]" />

      <button
        id="theme-system"
        class="relative z-10 flex h-6 w-6 items-center justify-center"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-3 opacity-70" />
      </button>

      <button
        id="theme-light"
        class="relative z-10 flex h-6 w-6 items-center justify-center"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-3 text-amber-500" />
      </button>

      <button
        id="theme-dark"
        class="relative z-10 flex h-6 w-6 items-center justify-center"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-3 opacity-70" />
      </button>
    </div>
    """
  end
end
